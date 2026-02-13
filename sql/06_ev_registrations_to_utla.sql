-- ================================================
-- 06_ev_registrations_to_utla.sql
-- Aggregates LAD-level EV registrations to UTLA analysis spine
-- Includes cleaning, aggregation, and sense checks
-- ================================================

-- 1. Clean LAD EV registrations
DROP TABLE IF EXISTS ev_registrations_lad_clean;

CREATE TABLE ev_registrations_lad_clean AS
SELECT
    TRIM(UPPER(lad_code)) AS lad_code,
    TRIM(REPLACE(REPLACE(lad_name,'  ',' '),'  ',' ')) AS lad_name,
    ev_registrations
FROM ev_registrations_lad;

-- 2. Optional: Check for unmatched LADs in LAD->UTLA mapping
-- Rows returned here indicate LADs in EV data that cannot be mapped to a UTLA
SELECT ev.lad_code, ev.lad_name, ev.ev_registrations
FROM ev_registrations_lad_clean ev
LEFT JOIN lad_to_utla ltu
  ON ev.lad_code = ltu.lad_code
WHERE ltu.lad_code IS NULL;

-- 3. Aggregate EV registrations to UTLA using the analysis spine
DROP TABLE IF EXISTS utla_ev_registrations;

CREATE TABLE utla_ev_registrations AS
SELECT
    spine.utla_code,
    spine.utla_name,
    COALESCE(SUM(ev.ev_registrations), 0) AS ev_registrations
FROM utla_analysis_spine AS spine
LEFT JOIN lad_to_utla AS ltu
    ON spine.utla_code = ltu.utla_code
LEFT JOIN ev_registrations_lad_clean AS ev
    ON ltu.lad_code = ev.lad_code
GROUP BY
    spine.utla_code,
    spine.utla_name
ORDER BY
    spine.utla_code;

-- ================================================
-- Sense-check queries
-- ================================================

-- 4. Check number of UTLAs
SELECT COUNT(*) AS num_utlas
FROM utla_ev_registrations;

-- 5. Check total EV registrations before and after aggregation
SELECT 
    (SELECT SUM(ev_registrations) FROM ev_registrations_lad_clean) AS total_ev_lads,
    (SELECT SUM(ev_registrations) FROM utla_ev_registrations) AS total_ev_utlas;

-- 6. Optional: Spot-check top 10 UTLAs by EV registrations
SELECT *
FROM utla_ev_registrations
ORDER BY ev_registrations DESC
LIMIT 10;