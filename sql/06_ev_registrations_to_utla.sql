-- ============================================
-- 06_ev_registrations_to_utla.sql
-- Purpose: aggregate EV registrations data to utla level.
-- ============================================

DROP TABLE IF EXISTS utla_ev_registrations;

CREATE TABLE utla_ev_registrations AS
SELECT
    ltu.utla_code,
    ltu.utla_name,
    SUM(ler.ev_registrations) AS ev_registrations
FROM
    lad_to_utla_lookup ltu
LEFT JOIN
    lad_ev_registrations ler
    ON ltu.lad_code = ler.lad_code
GROUP BY
    ltu.utla_code,
    ltu.utla_name
ORDER BY
    ltu.utla_name;