import results 
from pathlib import Path

DO_MATCH_BASIC = Path("queries/do_match4.sql").read_text() # threshold 400 - for fast matching
DO_MATCH_SLOW = Path("queries/do_match_slower.sql").read_text() # threshold 10000 - for slower but more accurate
DO_MATCH_TRIGRAM = Path("queries/do_trigram_match2.sql").read_text() # trigram phrases - slowest but most accurate

CREATE_GEOCODER_TABLES = Path("queries/create_geocoder_tables.sql").read_text()
MAKE_ADDRESSES = Path("queries/make_addresses.sql").read_text()

CREATE_PHRASES = Path("queries/create_phrases.sql").read_text()
INVERTED_INDEX = Path("queries/phrase_inverted.sql").read_text()
CREATE_INDEXES = Path("queries/create_indexes.sql").read_text()

CREATE_TRIGRAMPHRASES = Path("queries/create_trigram_phrases.sql").read_text()
TRIGRAMINVERTED_INDEX = Path("queries/trigram_phrase_inverted.sql").read_text()
CREATE_TRIGRAMINDEXES = Path("queries/create_trigram_indexes.sql").read_text()

# todo: create a BaseMatcher class and inherit all matches from this
class Matcher(object):
    def __init__(self, db=None, how='standard', initialize=False, threshold=0.5):
        """
        Initialize the matcher object. Requires a DB to connect to
        """
        self.db = db 
        self.threshold = threshold # the threshold when chaining matchers together
        self.how = how # which SQL query to use

    def setup(self):
        """
        Create the inverted index and phrase tables 
        """
        # create phrases
        print("Creating geocoder tables...")
        self.db.ss(CREATE_GEOCODER_TABLES)
        
        print('Creating phrases...')
        self.db.ss(CREATE_PHRASES)

        print('Creating trigram phrases...')
        self.db.ss(CREATE_TRIGRAMPHRASES)
        
        print('Creating inverted index...')
        # create inverted index
        self.db.ss(INVERTED_INDEX)
        # create inverted index for trigram phrases
        self.db.ss(TRIGRAMINVERTED_INDEX)

        # create indexes
        self.db.ss(CREATE_INDEXES)
        self.db.ss(CREATE_TRIGRAMINDEXES)

    def match(self, addresses, address_ids=None):
        how = self.how
        
        with self.db.transaction() as t:
            t.ex(
                "create temporary table input_addresses(address_id bigint not null, address text not null);"
            )

            if address_ids:
                input_list = [
                    dict(address_id=i, address=a.upper())
                    for i, a in zip(address_ids, addresses)  
                    ]
            else:
                input_list = [
                    dict(address_id=i, address=a.upper())
                    for i, a in enumerate(addresses)
                    ]

            t.insert("input_addresses", input_list)
            if how == 'standard':
                answers = t.ex(DO_MATCH_BASIC)
            elif how == 'trigram':
                answers = t.ex(DO_MATCH_TRIGRAM)
            elif how == 'slow':
                answers = t.ex(DO_MATCH_SLOW)
            else:
                print(f'No query for {how} matching, using standard phrase geocoder')
                answers = t.ex(DO_MATCH_BASIC)
            t.ex("drop table input_addresses;")
        return answers

    def query(self, query):
        """
        Execute a generic SQL query using the database of the matcher
        """
        results = self.db.ss(query)
        return results