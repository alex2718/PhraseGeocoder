-- Austrac geocoding algorithm
WITH input_addresses_with_numerics AS (
    SELECT 
    t1.address_id,
    t1.address,
    t2.numeric_tokens::int[]
    FROM input_addresses t1
    LEFT JOIN 
    (
        SELECT address_id, array_agg(i) as numeric_tokens
        FROM (
            SELECT t1.address_id, (regexp_matches(t1.address, '\d+', 'g'))[1] i 
            FROM input_addresses t1
        ) temp
        GROUP BY address_id
    ) t2
    ON t1.address_id=t2.address_id
),
input_phrases AS (
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
input_phrase_inverted AS (
    SELECT phrase, array_agg(address_id) as address_ids, count(1) as frequency
    FROM input_phrases 
    GROUP BY phrase
),
input_phrase_matched AS (
    SELECT l.phrase, l.address_ids AS address_ids1, r.addr_ids AS address_ids2
    FROM input_phrase_inverted as l 
    INNER JOIN phraseinverted as r 
    ON l.phrase=r.tokenphrase and l.frequency < 1000 and r.frequency < 1000
),
input_proposed_match AS (
    SELECT address_id1, unnest(address_ids2) AS address_id2
    FROM (
        SELECT unnest(address_ids1) as address_id1, address_ids2
        FROM input_phrase_matched
    ) AS tmp
),
match AS (
    SELECT t1.address_id1, t2.address, t2.numeric_tokens, t1.address_id2, 
    CASE WHEN t3.addr_id IS NOT NULL THEN
    similarity(t2.address, t3.addr)
    ELSE 0.0 END AS similarity
    FROM input_proposed_match t1,
    input_addresses_with_numerics t2,
    addrtext t3
    WHERE t1.address_id1=t2.address_id
    AND t1.address_id2=t3.addr_id
),
final_match AS (
    SELECT t1.address_id1, t1.address, t1.address_id2, t3.addr as matched_address, t2.*, t1.similarity
    FROM match t1
    LEFT JOIN address_view t2
    ON t1.address_id2=t2.address_detail_pid
    LEFT JOIN addrtext t3 
    ON t1.address_id2=t3.addr_id
    WHERE t1.numeric_tokens <@ t3.addr_tokens
    ORDER BY t1.address_id1 ASC, t1.similarity DESC
),
best_match AS (
    SELECT DISTINCT t1.address_id1, t1.address as input_address, t1.matched_address, 
    street_locality_pid, locality_pid, building_name, lot_number_prefix, lot_number, lot_number_suffix, 
    flat_type, flat_number_prefix, flat_number, flat_number_suffix, level_type, level_number_prefix, 
    level_number, level_number_suffix, number_first_prefix, number_first, number_first_suffix, 
    number_last_prefix, number_last, number_last_suffix, street_name, street_class_code, 
    street_class_type, street_type_code, street_suffix_code, street_suffix_type, locality_name, 
    state_abbreviation, postcode, latitude, longitude, geocode_type, alias_principal, primary_secondary, 
    legal_parcel_id, date_created, t1.similarity 
    FROM final_match t1
    INNER JOIN (
        SELECT address_id1, max(similarity) as similarity
        FROM final_match
        GROUP BY address_id1
    ) t2
    ON t1.address_id1=t2.address_id1 AND t2.similarity=t1.similarity
)
SELECT * FROM best_match;
