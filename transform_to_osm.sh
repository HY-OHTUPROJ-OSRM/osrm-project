SQL="SELECT
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

ogr2osm -o route-data.osm --sql "$SQL" "PG:dbname=postgres host=localhost user=postgres password=pass"
