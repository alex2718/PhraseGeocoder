# set up the GNAF database
from phrasegeo import GNAFLoader

# specify the name of the database
gnaf = GNAFLoader("postgresql:///GNAF_VICNSW")

# path to the auth and the state psv files
base_path = "/Users/vic2e3a/Desktop/Data"
gnaf_path = f"{base_path}/GNAF/FEB21_GNAF_PipeSeparatedValue_20210222101749/G-NAF/G-NAF FEBRUARY 2021/Standard"
gnaf_aut_path = f"{base_path}/GNAF/FEB21_GNAF_PipeSeparatedValue_20210222101749/G-NAF/G-NAF FEBRUARY 2021/Authority Code"

# load up the psv files
gnaf.load_data(gnaf_path, gnaf_aut_path, state_names=["VIC", "NSW"])

# add the FK contraints
gnaf.add_constraints()

# create the 'nice' addresses
gnaf.create_addresses()
