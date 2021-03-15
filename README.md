# Phrase geocoder

This is a simple geocoder written in Python and Postgres, based on the paper: https://arxiv.org/abs/1708.01402

## Requirements
- Poetry
- Python 3.6+
- Postgres 12
- Geocoded National Address File (https://data.gov.au/dataset/ds-dga-19432f89-dc3a-4ef3-b943-5326ef1dbecc/details)

## Installation
Install poetry
```
pip install poetry
poetry install
```

## Usage
To set up the GNAF first download it from the link above. Then use the following code, replacing the paths in gnaf_path and gnaf_aut_path with the paths of the folders where the data has been extracted to

```
# set up the GNAF database
from phrasegeo import GNAFLoader

# specify the name of the database
gnaf = GNAFLoader("postgresql:///GNAF_VIC")

# path to the auth and the state psv files
gnaf_path = '/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Standard'
gnaf_aut_path = '/GNAF/nov20_gnaf_pipeseparatedvalue/G-NAF/G-NAF NOVEMBER 2020/Authority Code'

# load up the psv files
gnaf.load_data(gnaf_path, gnaf_aut_path, state_names=['VIC'])

# add the FK contraints
gnaf.add_constraints()

# create the 'nice' addresses
gnaf.create_addresses()
```
The following example shows how to set up the GNAF and geocode some example addresses

```
import pandas as pd 
import results 
from phrasegeo import Matcher

# load up the db
db_name = 'GNAF_today'
DB = f"postgresql:///{db_name}"
db = results.db(DB)

# set up the matcher
matcher = Matcher(db)

# load up the test addresses
df = pd.read_csv('phrasegeo/datasets/addresses1.csv')
addresslist = list(df['ADDRESS'].values)

# set up the geocoder if this hasn't already been done
# i.e., create the phrase and inverted index tables
matcher.setup()

# do the matching
matches = matcher.match(addresslist)

# convert to a pandas dataframe
df_matches = pd.DataFrame(matches)
```