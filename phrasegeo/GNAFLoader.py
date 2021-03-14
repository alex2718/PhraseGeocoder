import results 
from pathlib import Path 

CREATE_TABLES = Path('queries/create_tables_ansi.sql').read_text()
LOAD_DATA = Path('queries/create_gnaf.sql').read_text()
ADDRESS_VIEW = Path('queries/address_view.sql').read_text()
ADD_FK_CONSTRAINTS = Path('queries/add_fk_constraints.sql').read_text()
STATE_DATA = Path('queries/load_state_data.sql').read_text()
AUTH_DATA = Path('queries/load_aut_data.sql').read_text()
MAKE_ADDRESSES = Path('queries/make_addresses.sql').read_text()

table_names_state = {'address_alias_path': 'ADDRESS_ALIAS_psv.psv', 
'address_default_geocode_path': 'ADDRESS_DEFAULT_GEOCODE_psv.psv',
'address_detail_path': 'ADDRESS_DETAIL_psv.psv', 
'address_feature_path': 'ADDRESS_FEATURE_psv.psv', 
'address_mesh_block_2011_path': 'ADDRESS_MESH_BLOCK_2011_psv.psv', 
'address_mesh_block_2016_path': 'ADDRESS_MESH_BLOCK_2016_psv.psv',
'address_site_path': 'ADDRESS_SITE_psv.psv', 
'address_site_geocode_path': 'ADDRESS_SITE_GEOCODE_psv.psv', 
'locality_path': 'LOCALITY_psv.psv', 
'locality_alias_path': 'LOCALITY_ALIAS_psv.psv', 
'locality_neighbour_path': 'LOCALITY_NEIGHBOUR_psv.psv', 
'locality_point_path': 'LOCALITY_POINT_psv.psv', 
'mb_2011_path': 'MB_2011_psv.psv', 
'mb_2016_path': 'MB_2016_psv.psv', 
'state_path': 'STATE_psv.psv',
'street_locality_path': 'STREET_LOCALITY_psv.psv', 
'street_locality_alias_path': 'STREET_LOCALITY_ALIAS_psv.psv', 
'street_locality_point_path': 'STREET_LOCALITY_POINT_psv.psv'}

table_names_aut = {'address_alias_type_aut_path': 'ADDRESS_ALIAS_TYPE_AUT_psv.psv',
'address_change_type_aut_path': 'ADDRESS_CHANGE_TYPE_AUT_psv.psv',
'address_type_aut_path': 'ADDRESS_TYPE_AUT_psv.psv',
'flat_type_aut_path': 'FLAT_TYPE_AUT_psv.psv',
'geocoded_level_type_aut_path': 'GEOCODED_LEVEL_TYPE_AUT_psv.psv',
'geocode_reliability_aut_path': 'GEOCODE_RELIABILITY_AUT_psv.psv',
'geocode_type_aut_path': 'GEOCODE_TYPE_AUT_psv.psv',
'level_type_aut_path': 'LEVEL_TYPE_AUT_psv.psv',
'locality_alias_type_aut_path': 'LOCALITY_ALIAS_TYPE_AUT_psv.psv',
'locality_class_aut_path': 'LOCALITY_CLASS_AUT_psv.psv',
'mb_match_code_aut_path': 'MB_MATCH_CODE_AUT_psv.psv',
'ps_join_type_aut_path': 'PS_JOIN_TYPE_AUT_psv.psv',
'street_class_aut_path': 'STREET_CLASS_AUT_psv.psv',
'street_locality_alias_type_aut_path': 'STREET_LOCALITY_ALIAS_TYPE_AUT_psv.psv',
'street_suffix_aut_path': 'STREET_SUFFIX_AUT_psv.psv',
'street_type_aut_path': 'STREET_TYPE_AUT_psv.psv'}

class GNAFLoader:
    def __init__(self, db_name):
        db = results.db(DB)
        self.db = db.create_database()

    def load_data(self, gnaf_path, gnaf_aut_path, state_names=['VIC']):
        self.gnaf_aut_path = gnaf_aut_path
        self.gnaf_path = gnaf_path
        self.states = state_names

        print('Creating tables...')
        db.ss(CREATE_TABLES)

        # the paths of the aut files
        for table_name in table_names_aut:
            filename = table_names_aut[table_name]
            table_names_aut[table_name] = f'{gnaf_aut_path}/Authority_Code_{filename}' 
            
        # load up the state data
        for state_name in state_names:
            print(f'Loading up the state data for {state_name}...')
            table_names_state_temp = dict({table_name: f'{gnaf_path}/{state_name}_{filename}' for table_name, filename in table_names_state.items()})
            self.db.ss(STATE_DATA, table_names_state_temp)
    
        # load up the auth data (independent of the states)
        print('Loading up the authority code tables...')
        self.db.ss(AUTH_DATA, table_names_aut)

    def add_constraints(self):
        print('Adding the foreign key contraints...')
        self.db.ss(ADD_FK_CONSTRAINTS)

    def create_addresses(self):
        print('Creating the address view...')
        self.db()
        self.db.ss(ADDRESS_VIEW)
        self.db.ss(MAKE_ADDRESSES)

        print('Standardizing spacing...')
        # tidy up to remove additional spaces
        db.ss(r"""UPDATE addrtext
        SET addr = trim(regexp_replace(addr, '\s+', ' ', 'g')
        );""")
