# set up the GNAF database
from phrasegeo import GNAFLoader

# specify the name of the database
gnaf = GNAFLoader("postgresql:///GNAF_VIC")

# path to the auth and the state psv files
gnaf_path = '/Users/vic2e3a/Desktop/Data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard'
gnaf_aut_path = '/Users/vic2e3a/Desktop/Data/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code'

# load up the psv files
gnaf.load_data(gnaf_path, gnaf_aut_path, state_names=['VIC'])

# add the FK contraints
gnaf.add_constraints()

# create the 'nice' addresses
gnaf.create_addresses()