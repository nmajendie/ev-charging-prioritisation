-- 07_add_ev_intensity_metrics.sql
-- Adds EV intensity metrics to the UTLA analysis spine

DROP VIEW IF EXISTS utla_ev_metrics;

CREATE VIEW utla_ev_metrics AS
SELECT
    spine.utla_code,
    spine.utla_name,
    spine.total_population,
    ev.ev_registrations,
    ROUND(
        CAST(ev.ev_registrations AS REAL) 
        / spine.total_population * 1000,
        2
    ) AS evs_per_1000_people
FROM utla_analysis_spine AS spine
LEFT JOIN utla_ev_registrations AS ev
    ON spine.utla_code = ev.utla_code;