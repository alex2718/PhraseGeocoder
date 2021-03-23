import pandas as pd 
import results 
from phrasegeo import Matcher, MatcherPipeline
from time import time

# load up the db
db_name = 'GNAF_VIC'
DB = f"postgresql:///{db_name}"
db = results.db(DB)

# set up the matchers
matcher1 = Matcher(db, how='standard')
matcher2 = Matcher(db, how='slow')
matcher3 = Matcher(db, how='trigram')

# pipeline setup
pipeline = MatcherPipeline([matcher1, matcher2, matcher3])

# load up the test addresses
df = pd.read_csv('phrasegeo/datasets/addresses1.csv')
addresslist = list(df['ADDRESS'].values)

# another set of test addresses
df = pd.read_csv('phrasegeo/datasets/nab_atm_vic.csv')
addresslist = list(df['address'].values)

# set up the geocoder if this hasn't already been done
# i.e., create the phrase and inverted index tables
# will throw an error if this has already been setup
# or if the GNAF has not been setup correctly
matcher.setup()

# do the matching for a single matcher
t1 = time()
matches = matcher1.match(addresslist)
t2 = time()
print(f'Matched {len(matches)} addresses in {round(t2-t1, 2)} sec.')

# do the matching through a pipeline
t1 = time()
matches = pipeline.match(addresslist)
t2 = time()
print(f'Matched {len(matches)} addresses in {round(t2-t1, 2)} sec.')

# convert to a pandas dataframe
df_matches = pd.DataFrame(matches)
df_matches.to_csv('/Users/vic2e3a/Desktop/Data/GNAF/outputs_2021/nab_atm_geocoded.csv', index=False)