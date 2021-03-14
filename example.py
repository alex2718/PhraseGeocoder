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