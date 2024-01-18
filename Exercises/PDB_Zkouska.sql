--creating table
CREATE TABLE POLYNOM_ZKOUSKA(
    id_polygonu NUMBER(3) PRIMARY KEY,
    nazev       VARCHAR(10),
    obsah       NUMBER,
    hranice     MDSYS.SDO_GEOMETRY
);

--inserting values into the table
INSERT INTO polynom_zkouska VALUES(
    1,
    'P1',
    NULL,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 1),
        SDO_ORDINATE_ARRAY(
            1, 1,
            1, 10,
            5, 10,
            5, 1,
            1, 1
        )
    )
);

INSERT INTO polynom_zkouska VALUES(
    2,
    'P2',
    NULL,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 1),
        SDO_ORDINATE_ARRAY(
            5, 1,
            5, 10,
            10, 10,
            10, 1,
            5, 1
        )
    )
);

--delete dat

TRUNCATE TABLE polynom_zkouska;

--zobrazeni metadat
SELECT * FROM user_sdo_geom_metadata;

-- generace prostoroveho indexu
CREATE INDEX zkouska_spatial_idx
ON polynom_zkouska (hranice)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

-- vypocitani obsahu
UPDATE polynom_zkouska
SET obsah = SDO_GEOM.SDO_AREA(hranice, 0.005);

--zobrazeni tabulek
SELECT * FROM polynom_zkouska;

-- overeni touch
SELECT p1.id_polygonu AS poly1_id, p1.nazev AS poly1_nazev,
       p2.id_polygonu AS poly2_id, p2.nazev AS poly2_nazev
FROM POLYNOM_ZKOUSKA p1, POLYNOM_ZKOUSKA p2
WHERE p1.id_polygonu < p2.id_polygonu --npouziti != aby zaznam nebyl v tabulce 2x
  AND SDO_TOUCH(p1.hranice, p2.hranice) = 'TRUE';
  
--vypsani WKT a WBT
SELECT id_polygonu,
       nazev,
       obsah,
       MDSYS.SDO_UTIL.TO_WKTGEOMETRY(hranice) AS wkt_representation,
       MDSYS.SDO_UTIL.TO_WKBGEOMETRY(hranice) AS wkb_representation
FROM POLYNOM_ZKOUSKA;