-- this can take a while
INSERT INTO trigramphrase
SELECT
t1.addr_id, 
t1.trigram || ' ' || t2.trigram trigramphrase
FROM 
(
    SELECT 
    addr_id,
    tokenphrase,
    replace(upper(unnest(show_trgm((string_to_array(tokenphrase, ' '))[1]))), ' ', '') trigram
    FROM phrase
) t1
INNER JOIN
(
    SELECT 
    addr_id,
    tokenphrase,
    replace(upper(unnest(show_trgm((string_to_array(tokenphrase, ' '))[2]))), ' ', '') trigram
    FROM phrase
) t2 
ON t1.addr_id=t2.addr_id
WHERE t1.tokenphrase=t2.tokenphrase
AND t1.trigram similar TO '[A-Z0-9]{2,3}' AND t2.trigram similar TO '[A-Z0-9]{2,3}';
