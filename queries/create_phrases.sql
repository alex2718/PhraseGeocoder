-- insert values into addrtext

-- Creates the two token phrases
-- to do: create the phrase made from pairs of trigrams
INSERT INTO phrase
SELECT
    addr_id,
    (regexp_matches(
        regexp_replace(addr,'[^A-Z0-9]+',' ','g'),
        '[A-Z0-9+]+ [A-Z0-9+]+','g'))[1]
FROM addrtext
UNION
SELECT
addr_id,
(regexp_matches(
    regexp_replace(
        regexp_replace(addr,'[^A-Z0-9]',' ','g') ,
        '[A-Z0-9]+','') ,'[A-Z0-9+]+ [A-Z0-9+]+','g'))[1]
        FROM addrtext;
        
