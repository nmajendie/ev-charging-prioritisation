-- ============================================
-- 05_create_analysis_spine.sql
-- Purpose: Define final UTLA analysis dataset
-- ============================================

DROP VIEW IF EXISTS utla_analysis_spine;

CREATE VIEW utla_analysis_spine AS
SELECT
    u.utla_code,
    u.utla_name,
    p.total_population
FROM utla_lookup u
JOIN utla_population p
  ON u.utla_code = p.utla_code;