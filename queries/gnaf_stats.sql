-- some interesting states about vic addresses
-- how many addresses are uniquely defined by flat_number, street_number and level_number?
with high_redundancy as (
    select flat_number, number_first, level_number, count(*) 
    from address_view 
    group by (flat_number, number_first, level_number)
    having count(*) = 1
)
select count(*) from high_redundancy;

-- find number of distinct addresses that can be uniquely defined 
-- by a single phrase
-- join to get the full address
with temp as (
    select distinct unnest(addr_ids) as addr_id, tokenphrase
    from phraseinverted where frequency = 1
)
select temp.addr_id, addrtext.addr, temp.tokenphrase
from temp
inner join addrtext
on temp.addr_id=addrtext.addr_id;

with addr_tokens as (
    select * from phrase where addr_id='GAVIC424465868'
)
select * from addr_tokens 
join 

with unnested_phrases as (
    select unnest(t1.addr_ids) as addr_id, t1.tokenphrase, frequency
    from phraseinverted t1
    where unnested_phrases.addr_id='GAVIC424465868'
)
select * from unnested_phrases
inner join phrase t2 
on t2.addr_id=unnested_phrases.addr_id;

