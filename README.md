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