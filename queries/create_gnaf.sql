-- Create the GNAF (in this case November 2020)

-- run the create table statements from create_tables_ansi.sql

-- load up the data from the psv files into the tables
-- do this for each of the states
-- 19 psv files for each of the states + 16 authority code files
-- Create python code to call each of these
COPY ADDRESS_ALIAS
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_ADDRESS_ALIAS_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_DEFAULT_GEOCODE
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_ADDRESS_DEFAULT_GEOCODE_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_DETAIL
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_ADDRESS_DETAIL_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_FEATURE
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_ADDRESS_FEATURE_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_MESH_BLOCK_2011
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_ADDRESS_MESH_BLOCK_2011_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_MESH_BLOCK_2016
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_ADDRESS_MESH_BLOCK_2016_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_SITE
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_ADDRESS_SITE_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_SITE_GEOCODE
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_ADDRESS_SITE_GEOCODE_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY LOCALITY
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_LOCALITY_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY LOCALITY_ALIAS
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_LOCALITY_ALIAS_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY LOCALITY_NEIGHBOUR
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_LOCALITY_NEIGHBOUR_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY LOCALITY_POINT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_LOCALITY_POINT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY MB_2011
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_MB_2011_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY MB_2016
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_MB_2016_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY STATE
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_STATE_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY STREET_LOCALITY
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_STREET_LOCALITY_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY STREET_LOCALITY_ALIAS
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_STREET_LOCALITY_ALIAS_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY STREET_LOCALITY_POINT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard/VIC_STREET_LOCALITY_POINT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_ALIAS_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_ADDRESS_ALIAS_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_CHANGE_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_ADDRESS_CHANGE_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY ADDRESS_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_ADDRESS_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY FLAT_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_FLAT_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY GEOCODED_LEVEL_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_GEOCODED_LEVEL_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY GEOCODE_RELIABILITY_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_GEOCODE_RELIABILITY_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY GEOCODE_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_GEOCODE_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY LEVEL_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_LEVEL_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY LOCALITY_ALIAS_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_LOCALITY_ALIAS_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY LOCALITY_CLASS_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_LOCALITY_CLASS_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY MB_MATCH_CODE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_MB_MATCH_CODE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY PS_JOIN_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_PS_JOIN_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY STREET_CLASS_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_STREET_CLASS_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY STREET_LOCALITY_ALIAS_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_STREET_LOCALITY_ALIAS_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY STREET_SUFFIX_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_STREET_SUFFIX_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;

COPY STREET_TYPE_AUT
FROM '/Users/vic2e3a/Desktop/data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code/Authority_Code_STREET_TYPE_AUT_psv.psv'
DELIMITER '|'
CSV HEADER;
