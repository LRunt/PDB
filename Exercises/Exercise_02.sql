CREATE TABLE parks (
    id  NUMBER(6) PRIMARY KEY,
    name    VARCHAR2(100),
    area    NUMBER,
    boundary    MDSYS.SDO_GEOMETRY,
    id_city     number(6),
    FOREIGN KEY(id_city) REFERENCES cities(id)

);

INSERT INTO parks VALUES (
    111111,
    'Lochotin park',
    NULL,
    MDSYS.SDO_GEOMETRY(
        2003, --SDO_GYTPE(2- 2D;01 - POUNT)
        NULL, --SDO_SRID (NULL - mistni SS)
        NULL,
        SDO_ELEM_INFO_ARRAY(1,1003,1),
        SDO_ORDINATE_ARRAY(3,8,3,5,5,5,6,8,3,8)
    ),
    123456
);

INSERT INTO parks VALUES (
    222222,
    'Bory park',
    NULL,
    MDSYS.SDO_GEOMETRY(
        2003, --SDO_GYTPE(2- 2D;01 - POUNT)
        NULL, --SDO_SRID (NULL - mistni SS)
        NULL,
        SDO_ELEM_INFO_ARRAY(1,1003,1),
        SDO_ORDINATE_ARRAY(4,3,4,2,9,2,9,3,4,3)
    ),
    123456
);

INSERT INTO user_sdo_geom_metadata
    (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
    VALUES(
    'parks',
    'boundary',
    SDO_DIM_ARRAY(
        SDO_DIM_ELEMENT('X',0,10,0.5), --3. cislo hodnota tolerance (dva body povazuji za identicke)
        SDO_DIM_ELEMENT('Y',0,10,0.5)
        ),
    NULL
    
);

CREATE INDEX parks_boundary_spatial_idx 
ON parks(boundary)
INDEXTYPE IS MDSYS.SPaTIAL_INDEX;


CREATE TABLE rivers(
     id NUMBER(6) PRIMARY KEY,
     name VARCHAR2(100),
     geom MDSYS.SDO_GEOMETRY,
     id_city NUMBER(6),
     FOREIGN KEY (id_city) REFERENCES cities(id)
);

INSERT INTO rivers VALUES(
 333333,
 'radbuza',
 SDO_GEOMETRY(
 2002,
 NULL,
 NULL,
 SDO_ELEM_INFO_ARRAY(1,2,1), -- compound line string
 SDO_ORDINATE_ARRAY(5,1,7,4,8,4,7,7)
 ),
 123456
);

INSERT INTO user_sdo_geom_metadata
    (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
    VALUES(
    'rivers',
    'geom',
    SDO_DIM_ARRAY(
        SDO_DIM_ELEMENT('X',0,10,0.5), --3. cislo hodnota tolerance (dva body povazuji za identicke)
        SDO_DIM_ELEMENT('Y',0,10,0.5)
        ),
    NULL
    
);

CREATE INDEX rivers_boundary_spatial_idx 
ON rivers(geom)
INDEXTYPE IS MDSYS.SPaTIAL_INDEX;


UPDATE parks
SET area = SDO_GEOM.SDO_AREA(boundary, 0.5);

SELECT name, area
FROM parks
ORDER BY area DESC;