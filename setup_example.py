# set up the GNAF database
from phrasegeo import GNAFLoader

gnaf = GNAFLoader("GNAF_VIC")

# path to the auth and the state psv files
gnaf_path = ''
gnaf_aut_path = ''

# load up the psv files
gnaf.load_data(self, gnaf_path, gnaf_aut_path, state_names=['VIC'])

# add the FK contraints
gnaf.add_constraints()

# create the 'nice' addresses
gnaf.create_addresses()