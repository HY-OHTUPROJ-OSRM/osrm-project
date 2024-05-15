CREATE SEQUENCE id_seq;
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
CREATE INDEX digiroad_routing_wkb_geometry_idx ON digiroad_routing USING GIST (geom);
