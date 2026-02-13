-- 08_utla_area_and_density.sql
-- Aggregate LAD land area to UTLA and calculate population density

DROP VIEW IF EXISTS utla_area;

CREATE VIEW utla_area AS
SELECT
    lu.utla_code,
    SUM(la.AREALHECT) * 0.01 AS area_km2
FROM lad_area la
JOIN lad_to_utla lu
    ON la.LAD23CD = lu.lad_code
GROUP BY lu.utla_code;


DROP VIEW IF EXISTS utla_deployability_metrics;

CREATE VIEW utla_deployability_metrics AS
SELECT
    m.utla_code,
    m.utla_name,
    m.total_population,
    a.area_km2,
    ROUND(
        m.total_population / a.area_km2,
        1
    ) AS population_density_per_km2,
    m.ev_registrations,
    m.evs_per_1000_people
FROM utla_ev_metrics m
LEFT JOIN utla_area a
    ON m.utla_code = a.utla_code;