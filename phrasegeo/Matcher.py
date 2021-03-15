import results 
from pathlib import Path

DO_MATCH = Path("queries/do_match.sql").read_text()
CREATE_GEOCODER_TABLES = Path("queries/create_geocoder_tables.sql").read_text()
MAKE_ADDRESSES = Path("queries/make_addresses.sql").read_text()
CREATE_PHRASES = Path("queries/create_phrases.sql").read_text()
INVERTED_INDEX = Path("queries/phrase_inverted.sql").read_text()
CREATE_INDEXES = Path("queries/create_indexes.sql").read_text()

# todo: create a BaseMatcher class and inherit all matches from this
class Matcher(object):
    def __init__(self, db=None, initialize=False, threshold=0.5):
        """
        Initialize the matcher object. Requires a DB to connect to
        """
        self.db = db 
        self.threshold = threshold # the threshold when chaining matchers together

    def setup(self):
        """
        Create the inverted index and phrase tables 
        """
        # create phrases
        print("Creating geocoder tables...")
        self.db.ss(CREATE_GEOCODER_TABLES)
        
        print('Creating phrases...')
        self.db.ss(CREATE_PHRASES)
        
        print('Creating inverted index...')
        # create inverted index
        self.db.ss(INVERTED_INDEX)
        
        # create indexes
        self.db.ss(CREATE_INDEXES)

    def match(self, address_list):
        with self.db.transaction() as t:
            t.ex(
                "create temporary table input_addresses(address_id bigint not null, address text not null);"
            )

            input_list = [
                dict(address_id=i, address=a.upper())
                for i, a in enumerate(address_list)
            ]
            t.insert("input_addresses", input_list)
            answers = t.ex(DO_MATCH)
            t.ex("drop table input_addresses;")
        return answers

    def query(self, query):
        """
        Execute a generic SQL query using the database of the matcher
        """
        results = self.db.ss(query)
        return results