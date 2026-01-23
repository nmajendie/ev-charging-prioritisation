EV Charging Pilot Prioritisation for UK Local Authorities
Overview
This project explores how an early-stage EV charging startup might prioritise UK local authorities for pilot deployments of public charging infrastructure. It frames the problem as a strategy and operations decision under real-world constraints, using publicly available data to support transparent, defensible recommendations.
The analysis focuses on near-term pilots (12–18 months), where capital, delivery capacity, and political feasibility are limiting factors.

Decision Question
Which UK local authorities should be prioritised for EV charging pilot deployments, given demand pressure, deployability constraints, and commercial viability?

Analytical Approach
Local authorities are assessed across three dimensions:
	1	Demand pressure
	◦	EV adoption levels
	◦	EVs per public charger as a proxy for unmet demand
	2	Deployability
	◦	Population density
	◦	Housing stock composition (on-street vs off-street charging need)
	3	Commercial & strategic viability
	◦	Income or deprivation proxies
	◦	Authority size and similarity to others (replicability)
The emphasis is on decision support, not predictive modelling or technical optimisation.

Data Sources
This project uses publicly available UK datasets, including:
	•	ONS local authority lookup and population estimates
	•	DVLA electric vehicle registrations by local authority
	•	National Chargepoint Registry (public charging infrastructure)
	•	ONS dwelling stock by housing type
	•	ONS Gross Disposable Household Income or Index of Multiple Deprivation
Raw data is not included in this repository. Sources, snapshot dates, and download links are documented separately.

Data & Geography
This project uses the Office for National Statistics (ONS) April 2025 Local Authority District (LAD) to Upper-Tier Local Authority (UTLA) lookup to define geographic boundaries (153 UTLAs in England).

Population data is sourced at the LAD level and aggregated to UTLA. Due to boundary alignment differences between ONS datasets, population data is available for 151 of 153 UTLAs. Barnsley and Sheffield are therefore excluded from population-based analysis.

All geographic joins and exclusions are handled explicitly in SQL to ensure reproducibility.

Methodology
	1	Clean and standardise datasets at local authority level using SQL
	2	Join datasets into a single analytical table
	3	Create simple, interpretable metrics and proxies
	4	Segment local authorities into archetypes
	5	Rank candidates using a transparent scoring framework
	6	Stress-test results using qualitative reasoning

The final analytical dataset is defined in sql/05_create_analysis_spine.sql, which restricts analysis to UTLAs with complete population coverage.

Outputs
	•	A prioritised shortlist of UK local authorities suitable for pilot deployments
	•	Clear rationale for inclusion and exclusion decisions
	•	Local authority archetypes to support replication strategy
	•	A short strategy memo outlining implications for rollout and execution

Repository Structure

├── README.md
├── sql/              # SQL scripts for cleaning and joining data
├── notebooks/        # Exploratory analysis and visualisation
├── data/
│   ├── raw/          # Raw data (not tracked)
│   └── processed/    # Cleaned, derived datasets

Notes
This project is designed to mirror how strategy and operations analyses are conducted in early-stage technology companies, particularly in regulated and infrastructure-heavy sectors.

Status
In progress.