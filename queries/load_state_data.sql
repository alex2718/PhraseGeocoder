COPY ADDRESS_ALIAS
FROM :address_alias_path
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_DEFAULT_GEOCODE
FROM :address_default_geocode_path
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_DETAIL
FROM :address_detail_path
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_FEATURE
FROM :address_feature_path
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_MESH_BLOCK_2011
FROM :address_mesh_block_2011_path
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_MESH_BLOCK_2016
FROM :address_mesh_block_2016_path
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_SITE
FROM :address_site_path
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_SITE_GEOCODE
FROM :address_site_geocode_path
DELIMITER '|'
CSV HEADER;

COPY LOCALITY
FROM :locality_path
DELIMITER '|'
CSV HEADER;

COPY LOCALITY_ALIAS
FROM :locality_alias_path
DELIMITER '|'
CSV HEADER;

COPY LOCALITY_NEIGHBOUR
FROM :locality_neighbour_path
DELIMITER '|'
CSV HEADER;

COPY LOCALITY_POINT
FROM :locality_point_path
DELIMITER '|'
CSV HEADER;

COPY MB_2011
FROM :mb_2011_path
DELIMITER '|'
CSV HEADER;

COPY MB_2016
FROM :mb_2016_path
DELIMITER '|'
CSV HEADER;

COPY STATE
FROM :state_path
DELIMITER '|'
CSV HEADER;

COPY STREET_LOCALITY
FROM :street_locality_path
DELIMITER '|'
CSV HEADER;

COPY STREET_LOCALITY_ALIAS
FROM :street_locality_alias_path
DELIMITER '|'
CSV HEADER;

COPY STREET_LOCALITY_POINT
FROM :street_locality_point_path
DELIMITER '|'
CSV HEADER;