-- given the input table t_to_match, create the phrases
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
            SELECT t1.address_id, (regexp_matches(
                -- exclude postcodes
                regexp_replace(t1.address, '3\d{3}$', ''), '\d+', 'g'))[1] i
            FROM input_addresses t1
        ) temp
        GROUP BY address_id
    ) t2
    ON t1.address_id=t2.address_id
),
input_phrases AS NOT MATERIALIZED (
    SELECT
    m.address_id,
    (regexp_matches(
        regexp_replace(m.address,'[^A-Z0-9]+',' ','g'),'[A-Z0-9+]+ [A-Z0-9+]+','g'))[1]
            AS phrase
    FROM input_addresses m
    UNION
    SELECT
    m.address_id,
    (regexp_matches(regexp_replace(regexp_replace(m.address,'[^A-Z0-9]',' ','g'),
    '[A-Z0-9]+','') ,'[A-Z0-9+]+ [A-Z0-9+]+','g'))[1] AS phrase
    FROM input_addresses m
),
input_trigramphrases AS NOT MATERIALIZED (
    SELECT
    t1.address_id address_id, 
    t1.trigram || ' ' || t2.trigram trigramphrase
    FROM (
        SELECT 
        address_id,
        phrase,
        replace(upper(unnest(show_trgm((string_to_array(phrase, ' '))[1]))), ' ', '') trigram
        FROM input_phrases
        ) t1
    LEFT JOIN
    (
        SELECT
        address_id, 
        phrase,
        replace(upper(unnest(show_trgm((string_to_array(phrase, ' '))[2]))), ' ', '') trigram
    FROM input_phrases
    ) t2 
    ON t1.address_id=t2.address_id
    WHERE t1.phrase=t2.phrase
    AND t1.trigram similar TO '[A-Z0-9]{2,3}' AND t2.trigram similar TO '[A-Z0-9]{2,3}'
),
input_phrase_matched AS NOT MATERIALIZED (
    SELECT l.trigramphrase, l.address_id AS address_id1, r.address_ids AS address_ids2
    FROM input_trigramphrases l
    LEFT JOIN trigramphraseinverted r
    ON l.trigramphrase = r.trigramphrase
    AND r.frequency < 4000
),
input_proposed_match AS NOT MATERIALIZED (
    SELECT DISTINCT address_id1, t2.address_id2
    FROM input_phrase_matched AS t1
    LEFT JOIN lateral unnest(address_ids2) AS t2(address_id2) 
    ON true
),
match AS NOT materialized (
    SELECT t1.address_id1 AS address_id1, t1.address_id2 AS address_id2, 
    t2.address AS ADDRESS, t2.numeric_tokens, t3.addr, 
    CASE WHEN t3.addr IS NOT NULL THEN
    similarity(t2.address, t3.addr)
    ELSE 0.0 END AS similarity 
    FROM input_proposed_match t1
    LEFT JOIN input_addresses_with_numerics t2 ON t1.address_id1=t2.address_id
    LEFT JOIN addrtext t3 ON t1.address_id2=t3.addr_id
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
SELECT * from best_match;