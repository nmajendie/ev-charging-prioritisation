-- 09_rank_pilot_candidates.sql
-- Create a transparent ranking for pilot prioritisation
-- Based on: EV intensity (demand) + population density (deployability)

DROP VIEW IF EXISTS utla_pilot_ranking;

CREATE VIEW utla_pilot_ranking AS
WITH base AS (
    SELECT
        utla_code,
        utla_name,
        total_population,
        ev_registrations,
        evs_per_1000_people,
        area_km2,
        population_density_per_km2
    FROM utla_deployability_metrics
    -- guardrails: avoid divide-by-zero / null metrics
    WHERE total_population IS NOT NULL
      AND total_population > 0
      AND population_density_per_km2 IS NOT NULL
      AND evs_per_1000_people IS NOT NULL
),
ranked AS (
    SELECT
        *,
        -- percentile ranks: 0 (lowest) -> 1 (highest)
        PERCENT_RANK() OVER (ORDER BY evs_per_1000_people) AS pr_evs_per_1000,
        PERCENT_RANK() OVER (ORDER BY population_density_per_km2) AS pr_density
    FROM base
)
SELECT
    utla_code,
    utla_name,
    total_population,
    area_km2,
    population_density_per_km2,
    ev_registrations,
    evs_per_1000_people,

    pr_evs_per_1000,
    pr_density,

    -- equal-weight composite (transparent + defensible)
    ROUND((pr_evs_per_1000 + pr_density) / 2.0, 4) AS pilot_score,

    -- simple quadrant labels for interpretation
    CASE
        WHEN pr_evs_per_1000 >= 0.75 AND pr_density >= 0.75 THEN 'High EV, High density (prime pilots)'
        WHEN pr_evs_per_1000 >= 0.75 AND pr_density < 0.75 THEN 'High EV, lower density (driveway-heavy risk)'
        WHEN pr_evs_per_1000 < 0.75 AND pr_density >= 0.75 THEN 'Lower EV, high density (emerging hotspots)'
        ELSE 'Lower EV, lower density'
    END AS quadrant
FROM ranked;