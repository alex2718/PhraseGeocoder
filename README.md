# Phrase geocoder

A geocoder written in Python and Postgres, based on the paper: https://arxiv.org/abs/1708.01402

- Author: Alex Lee
- Contributors: Rob Lechte (https://github.com/djrobstep)
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

## Setup of GNAF
To set up the GNAF first download the data from the link above. 

Once the poetry shell has been opened, enter a Python shell and use the following code, replacing the paths in gnaf_path and gnaf_aut_path with the paths of the folders where the data has been extracted to

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

## Setup matcher and run on example data
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

## Using a pipeline for multi-stage matching
We can setup multiple matcher objects and pass the list of addresses through each one consecutively with
those that are unmatched by one sent as input addresses to the next matcher in the pipeline. This is 
useful for increasing the recall of lower quality addresses without sacrificing too much speed.

Assuming the database has been setup as above:

```
import pandas as pd 
from phrasegeo import Matcher, MatcherPipeline

# set up the matchers
matcher1 = Matcher(db, how='standard')
matcher2 = Matcher(db, how='slow')
matcher3 = Matcher(db, how='trigram')

# set up the pipeline
pipeline = MatcherPipeline([matcher1, matcher2, matcher3])

# load up the test addresses
df = pd.read_csv('phrasegeo/datasets/addresses1.csv')
addresslist = list(df['ADDRESS'].values)

# do the matching
matches = pipeline.match(addresslist)

# convert to a pandas dataframe
df_matches = pd.DataFrame(matches)
```
