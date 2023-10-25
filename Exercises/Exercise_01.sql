-- vytvoreni taulky pro mìsta
CREATE TABLE cities (
    id          NUMBER(6) PRIMARY KEY,
    name        VARCHAR2(100),
    area        NUMBER,
    def_point   MDSYS.SDO_GEOMETRY,
    boundary    MDSYS.SDO_GEOMETRY
);

--select everything
SELECT * FROM CITIES;

INSERT INTO cities VALUES(
    123456,
    'Pilsen',
    NULL,
    MDSYS.SDO_GEOMETRY(
        2001, --SDO_GTYPE (2 - 2D; 01 - POINT)
        NULL, --SDO_SRID (NULL - mistni SS)
        SDO_POINT_TYPE(2, 4, NULL), -- (in case of point geometry)
        NULL,
        NULL
    ),
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 1),
        SDO_ORDINATE_ARRAY(1, 8, 1, 4, 3, 1, 10, 1, 10, 5, 7, 7, 7, 8, 1, 8)
    )
);

INSERT INTO user_sdo_geom_metadata
    (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
    VALUES (
        'cities',
        'def_point',
        SDO_DIM_ARRAY(
            SDO_DIM_ELEMENT('X', 0, 10, 0.5),
            SDO_DIM_ELEMENT('Y', 0, 10, 0.5)
        ),
        NULL
);

INSERT INTO user_sdo_geom_metadata
    (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
    VALUES (
        'cities',
        'boundary',
        SDO_DIM_ARRAY(
            SDO_DIM_ELEMENT('X', 0, 10, 0.5),
            SDO_DIM_ELEMENT('Y', 0, 10, 0.5)
        ),
        NULL
);

CREATE INDEX cities_def_point_spatial_idx
ON cities(def_point)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

CREATE INDEX cities_def_boundary_spatial_idx
ON cities(boundary)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;