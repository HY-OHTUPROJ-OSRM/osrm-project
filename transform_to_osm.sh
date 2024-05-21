#! /usr/bin/bash
combineSQL="CREATE SEQUENCE id_seq;
CREATE TABLE digiroad_routing AS
SELECT nextval('id_seq') as ogc_fid
   , CAST(
        ST_Force2D(COALESCE(N.geom, L.geom))
        AS GEOMETRY(LineString, 3067)
      ) as geom
   , link_mmlid
   , COALESCE(N.kuntakoodi, L.kuntakoodi) AS kuntakoodi
   , CAST(CASE WHEN N.arvo = 0 THEN null ELSE N.arvo END AS NUMERIC(5)) AS nopeus
   , L.hallinn_lk
   , L.toiminn_lk
   , L.linkkityyp
   , L.ajosuunta
   , L.tienimi_su
   , L.tienimi_ru
   , L.tienimi_sa
   , cast('digiroad' as text) as datasource
   , L.link_tila
FROM dr_linkki_k AS L
LEFT OUTER JOIN dr_nopeusrajoitus_k AS N USING (segm_id);
 
ALTER TABLE digiroad_routing ADD PRIMARY KEY (ogc_fid);
CREATE INDEX digiroad_routing_geom_idx ON digiroad_routing USING GIST (geom);"

convertSQL="SELECT
ST_Transform(
  ST_ReducePrecision(
    CASE ajosuunta
      WHEN 3
      THEN ST_Reverse(geom)
      ELSE geom
    END,
    1
  ),
  4326
) AS geometry,
CASE
  WHEN linkkityyp IN (8,9) OR toiminn_lk = 8
    THEN 'footway'
  ELSE CASE
    WHEN linkkityyp != 21
      THEN CASE
        WHEN toiminn_lk = 1 THEN 'motorway'
        WHEN toiminn_lk = 2 THEN 'trunk'
        WHEN toiminn_lk = 3 THEN 'primary'
        WHEN toiminn_lk = 4 THEN 'secondary'
        WHEN toiminn_lk = 5 THEN 'tertiary'
        ELSE 'residential'
      END
  END
END AS highway,
CASE
  WHEN linkkityyp = 21 AND toiminn_lk != 8
    THEN 'ferry'
END AS route,
CASE ajosuunta
  WHEN 2 THEN 'no'
  WHEN 3 THEN 'yes'
  WHEN 4 THEN 'yes'
END AS oneway,
nopeus AS maxspeed,
COALESCE(tienimi_su,tienimi_ru,tienimi_sa) AS name
FROM digiroad_routing"

port=$1
gpkg_path=$2

blue="\033[0;36m"
nc="\033[0m"

dbcontid=$(docker run -d -e 'POSTGRES_HOST_AUTH_METHOD=trust' -p ${port}:5432 postgis/postgis)

echo -e "${blue}Waiting for database container to start.${nc}"
sleep 5

pgstring="PG:dbname=postgres host=localhost port=$port user=postgres"
psqlopts="-h localhost -p $port -U postgres"

echo -e "${blue}Creating database.${nc}"
ogr2ogr -f PostgreSQL "$pgstring" $gpkg_path -where "kuntakoodi=91"

echo -e "${blue}Combining link and speed tables.${nc}"
psql $psqlopts -c "$combineSQL"

echo -e "${blue}Converting data.${nc}"
ogr2osm --positive-id -o route-data.osm --sql "$convertSQL" "$pgstring"

echo -e "${blue}Cleaning up.${nc}"
docker stop $dbcontid

