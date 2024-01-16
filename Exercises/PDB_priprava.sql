CREATE TABLE polynom_priprava (
    id_polygonu NUMBER(3) PRIMARY KEY,
    nazev       VARCHAR(10),
    obsah       NUMBER,
    hranice     MDSYS.SDO_GEOMETRY
);

INSERT INTO polynom_priprava VALUES(
    1,
    'A',
    NULL,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL, 
        SDO_ELEM_INFO_ARRAY(1, 1003, 1,  11, 2003, 1, 21, 2003, 1, 31, 2003, 1),
        SDO_ORDINATE_ARRAY(
            1, 1,
            1, 6,
            6, 6,
            6, 1,
            1, 1,
            
            2, 4,
            3, 4,
            3, 5,
            2, 5,
            2, 4,
            
            4, 4,
            5, 4,
            5, 5,
            4, 5,
            4, 4,
            
            2, 2,
            5, 2,
            5, 3,
            2, 3,
            2, 2
            
            )
        )
);

TRUNCATE TABLE polynom_priprava;

-- metadata

INSERT INTO user_sdo_geom_metadata  -- zase dokumentace
(    
    TABLE_NAME,
    COLUMN_NAME,
    DIMINFO,
    SRID
)    
VALUES(
    'polynom_priprava', -- nazev tabulky ve ktery to je
    'hranice', -- nazev sloupecku ve kterm jsme
    SDO_DIM_ARRAY( -- ted chceme diminfo, dimarray
        SDO_DIM_ELEMENT('X',0,10,0.05), --(nazev osy,pocatek,konec osy,tolerance (rozliseni blizkzch bodu v sjtsk bz y bylo presnejsi))
        SDO_DIM_ELEMENT('Y',0,10,0.05) -- To same pro osu Y
    ),
    NULL
);

SELECT * FROM user_sdo_geom_metadata;

-- spatial index

CREATE INDEX priprava_spatial_idx
ON polynom_priprava (hranice)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

DROP INDEX priprava_spatial_idx;

SELECT * FROM USER_SDO_INDEX_INFO WHERE TABLE_NAME = 'polynom_priprava';

-- pocitani obsahu

SELECT id_polygonu, SDO_GEOM.SDO_AREA(hranice, 0.005) as obsah 
FROM polynom_priprava
ORDER BY obsah desc;

UPDATE polynom_priprava
SET obsah = SDO_GEOM.SDO_AREA(hranice, 0.005);

SELECT * FROM polynom_priprava;
