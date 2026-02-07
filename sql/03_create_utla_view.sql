-- ================================================
-- 03_create_utla_view.sql
-- Purpose: Clean LAD -> UTLA table and create UTLA spine for 2025
-- Notes: ONS 2025 geography includes 153 UTLAs
-- ================================================

-- 1. Remove rows with missing or blank UTLA codes
DELETE FROM lad_to_utla
WHERE utla_code IS NULL OR utla_code = '';

-- 2. Trim whitespace from all relevant columns
UPDATE lad_to_utla
SET 
    lad_code = TRIM(lad_code),
    lad_name = TRIM(lad_name),
    utla_code = TRIM(utla_code),
    utla_name = TRIM(utla_name);

-- Optional: standardize UTLA names to uppercase for consistency
UPDATE lad_to_utla
SET utla_name = UPPER(utla_name);

-- 3. Drop existing view if it exists
DROP VIEW IF EXISTS utla_lookup;

-- 4. Create UTLA spine view using official code patterns
--    Includes all 153 UTLAs as of 2025
CREATE VIEW utla_lookup AS
SELECT 
    utla_code,
    MIN(utla_name) AS utla_name  -- pick one name if multiple LADs exist
FROM lad_to_utla
WHERE utla_code LIKE 'E06%'    -- unitary / metro
   OR utla_code LIKE 'E07%'    -- counties
   OR utla_code LIKE 'E08%'    -- metropolitan districts
   OR utla_code LIKE 'E09%'    -- London boroughs
   OR utla_code LIKE 'E10%'    -- later authorities
GROUP BY utla_code;

-- 5. Verification queries

-- Total number of UTLAs should now be 153
SELECT COUNT(*) AS num_utlas
FROM utla_lookup;

-- Sample first 10 UTLAs
SELECT * 
FROM utla_lookup
ORDER BY utla_name
LIMIT 10;

-- Optional: check distribution of LADs per UTLA
SELECT utla_code, COUNT(*) AS lad_count
FROM lad_to_utla
WHERE utla_code IN (SELECT utla_code FROM utla_lookup)
GROUP BY utla_code
ORDER BY lad_count DESC;