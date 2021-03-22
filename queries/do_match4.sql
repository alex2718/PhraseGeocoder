WITH input_addresses_with_numerics AS not materialized (
    SELECT 
    t1.address_id,
    t1.address,
    t2.numeric_tokens::int[]
    FROM input_addresses t1
    LEFT JOIN 
    (
        SELECT address_id, array_agg(i) as numeric_tokens
        FROM (
            SELECT t1.address_id, (regexp_matches(
                -- exclude postcodes
                regexp_replace(t1.address, '3\d{3}$', ''), '\d+', 'g'))[1] i
            FROM input_addresses t1
        ) temp
        GROUP BY address_id
    ) t2
    ON t1.address_id=t2.address_id
),
input_phrases AS NOT materialized (
    SELECT
    m.address_id,
    (regexp_matches(regexp_replace(m.address,'[^A-Z0-9]+',' ','g'),
    '[A-Z0-9+]+ [A-Z0-9+]+','g'))[1] as phrase
    FROM input_addresses as m
    UNION
    SELECT
    m.address_id,
    (regexp_matches(regexp_replace(regexp_replace(m.address,'[^A-Z0-9]',' ','g'),
    '[A-Z0-9]+','') ,'[A-Z0-9+]+ [A-Z0-9+]+','g'))[1] as phrase
    FROM input_addresses as m
),
input_phrase_matched AS NOT materialized (
    SELECT l.phrase, l.address_id AS address_id1, r.addr_ids AS address_ids2
    FROM input_phrases AS l 
    LEFT JOIN phraseinverted AS r 
    ON l.phrase=r.tokenphrase AND r.frequency < 400
),
input_proposed_match AS NOT materialized (
    SELECT distinct address_id1, t2.address_id2
    FROM input_phrase_matched as t1
    left join lateral unnest(address_ids2) as t2(address_id2) 
    on true
),
match AS NOT materialized (
    select t1.address_id1 as address_id1, t1.address_id2 as address_id2, 
    t2.address as address, t2.numeric_tokens, t3.addr, 
    case when t3.addr is not null then
    similarity(t2.address, t3.addr)
    else 0.0 end as similarity 
    from input_proposed_match t1
    left join input_addresses_with_numerics t2 on t1.address_id1=t2.address_id
    left join addrtext t3 on t1.address_id2=t3.addr_id
),
final_match AS NOT materialized (
    SELECT t1.address_id1, t1.address, t1.address_id2, 
    t3.addr as matched_address, t2.*, t1.similarity
    FROM match t1
    LEFT JOIN address_view t2
    ON t1.address_id2=t2.address_detail_pid
    LEFT JOIN addrtext t3 
    ON t1.address_id2=t3.addr_id
    WHERE 
    t1.numeric_tokens <@ t3.addr_tokens or address_id2 is null -- numeric tokens constraint
    ORDER BY t1.address_id1 ASC, t1.similarity DESC
),
best_match AS NOT materialized ( -- possible inefficiencies here. tidy up to make it faster
    SELECT DISTINCT on (t1.address_id1) address_id1, t1.address as input_address, 
    t1.matched_address, t1.similarity as similarity,
    street_locality_pid, locality_pid, building_name, 
    lot_number_prefix, lot_number, lot_number_suffix, 
    flat_type, flat_number_prefix, flat_number, flat_number_suffix, 
    level_type, level_number_prefix, level_number, level_number_suffix, 
    number_first_prefix, number_first, number_first_suffix, 
    number_last_prefix, number_last, number_last_suffix, 
    street_name, street_class_code, 
    street_class_type, street_type_code, street_suffix_code, street_suffix_type, 
    locality_name, state_abbreviation, postcode, latitude, longitude, 
    geocode_type, alias_principal, primary_secondary, legal_parcel_id, date_created
    FROM final_match t1
    ORDER BY address_id1 ASC, similarity DESC
)
SELECT * FROM best_match;