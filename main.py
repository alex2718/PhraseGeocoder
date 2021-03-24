from fastapi import FastAPI
from phrasegeo import Matcher, MatcherPipeline 
from pydantic import BaseModel
import results 

# load up the db
db_name = 'GNAF_VIC'
DB = f"postgresql:///{db_name}"
db = results.db(DB)

# set up the API
app = FastAPI()

# set up matchers and pipeline
matcher1 = Matcher(db, how='standard')
matcher2 = Matcher(db, how='slow')
matcher3 = Matcher(db, how='trigram')

matcher_mapping = {'standard': matcher1, 'slow': matcher2, 'trigram': matcher3}

class AddressBatch(BaseModel):
    addresses: list
    how: list

@app.get("/")
async def root():
    address = '34 / 121 exhibition st melburne'
    answers = matcher1.match([address])
    return answers

@app.post("/match/")
async def check_list(addresses: AddressBatch):
    addressesdict = addresses.dict()
    addresses = addressesdict['addresses']
    how = addressesdict['how']
    matchers = [matcher_mapping[key] for key in how]
    pipeline = MatcherPipeline(matchers)
    answers = pipeline.match(addresses)
    return answers