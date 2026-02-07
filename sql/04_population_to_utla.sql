-- 1. Clean data

UPDATE lad_population
SET lad_code = TRIM(lad_code);

DELETE FROM lad_population
WHERE lad_code IS NULL OR lad_code = '';

-- 2. Join test

SELECT
    l.lad_code,
    l.population,
    m.utla_code,
    m.utla_name
FROM lad_population l
JOIN lad_to_utla m
  ON l.lad_code = m.lad_code
LIMIT 10;

-- 3. Aggregate to UTLA

DROP VIEW IF EXISTS utla_population;

CREATE VIEW utla_population AS
SELECT
    m.utla_code,
    m.utla_name,
    SUM(l.population) AS total_population
FROM lad_population l
JOIN lad_to_utla m
  ON l.lad_code = m.lad_code
GROUP BY m.utla_code, m.utla_name;

-- 4. Verify

SELECT COUNT(*) FROM utla_population; -- Should return 153

SELECT * FROM utla_population
ORDER BY total_population DESC
LIMIT 10;

-- 5. Identify missing UTLAs
SELECT 
    u.utla_code,
    u.utla_name
FROM utla_lookup u
LEFT JOIN utla_population p
  ON u.utla_code = p.utla_code
WHERE p.utla_code IS NULL;

