from fastapi import FastAPI
from phrasegeo import Matcher, MatcherPipeline 
from pydantic import BaseModel
import results 

# load up the db
db_name = 'GNAF_VIC'
DB = f"postgresql:///{db_name}"
db = results.db(DB)

# set up the API and matcher
app = FastAPI()
matcher1 = Matcher(db, how='standard')

class AddressBatch(BaseModel):
    addresses: list

@app.get("/")
async def root():
    address = '34 / 121 exhibition st melburne'
    answers = matcher1.match([address])
    return answers

@app.post("/match/")
async def check_list(addresses: AddressBatch):
    addresses = addresses.dict()['addresses']
    answers = matcher1.match(addresses)
    return answers