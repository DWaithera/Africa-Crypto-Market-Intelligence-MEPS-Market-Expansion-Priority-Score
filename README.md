Yes. **Copy the entire block below and paste it into `README.md`, replacing everything currently there.** This is the full README, not just the M6 section.
````markdown
# Africa Crypto Market Intelligence — MEPS
## Market Expansion Priority Score
**MEPS** is a data-driven market intelligence framework designed to help a crypto or fintech company decide **which African market to prioritize when expansion resources are limited**.
The project combines public market, digital infrastructure, financial access, crypto demand, and crypto activity indicators into a reproducible scoring framework that ranks markets and translates the ranking into potential growth actions.
MEPS is designed as a **market prioritization framework**, not a prediction model. A higher score represents stronger relative priority based on the selected indicators; it does not guarantee commercial success.
---
## Business Problem
Expanding into a new market requires decisions about where to allocate limited resources such as:
- Market research
- Partnerships
- Marketing spend
- Community development
- Business development
- Product localization
- Regulatory and operational preparation
The question MEPS aims to answer is:
> **If we can prioritize only a few African markets, which markets should we investigate or activate first, and why?**
MEPS connects market-level evidence to a structured prioritization framework so that expansion decisions can be supported by reproducible data rather than isolated indicators.
---
## Markets
The initial analysis covers four African markets:
| Country | Code |
|---|---|
| Ghana | GHA |
| Kenya | KEN |
| Nigeria | NGA |
| South Africa | ZAF |
The framework is designed so that additional African markets can be added as the data pipeline expands.
---
## Analytical Framework
The final MEPS framework contains **five core dimensions**:
1. **Market Attractiveness**
2. **Digital Readiness**
3. **Financial Accessibility**
4. **Crypto Demand**
5. **Crypto Activity**
### Core Indicators
#### 1. Market Attractiveness
- Population
- GDP per capita
- Personal remittances received (% of GDP)
#### 2. Digital Readiness
- Internet penetration
- Smartphone adoption
#### 3. Financial Accessibility
- Account ownership
- Digital payment usage
#### 4. Crypto Demand
- Relative Google search interest for `crypto`
#### 5. Crypto Activity
- Chainalysis 2024 Global Crypto Adoption Index rank
### Trajectory Analysis
**Growth Potential** is no longer treated as a core MEPS dimension.
Instead, historical change in selected indicators will be evaluated separately as a **Trajectory Analysis layer** after the core market ranking.
This prevents future growth from being mixed directly into the current-state market attractiveness score.
---
## Methodology
The analytical pipeline follows:
```text
Data Sources
      ↓
Python Ingestion
      ↓
Raw Source Data
      ↓
Validation & Quality Checks
      ↓
DuckDB Raw Layer
      ↓
dbt Sources
      ↓
dbt Staging
      ↓
Integrated Analytical Models
      ↓
Feature Engineering
      ↓
Dimension Scores
      ↓
MEPS Score
      ↓
Country Ranking
      ↓
Trajectory Analysis
      ↓
Market Intelligence
      ↓
Growth Activation
      ↓
Business Recommendation
````
The scoring methodology normalizes indicators before combining them.
The model also includes sensitivity analysis to test whether market rankings remain reasonably stable under changes to assumptions and weights.
MEPS preserves raw source values and separates data ingestion from analytical transformation.
---
## Growth Activation
MEPS does not stop at ranking countries.
The intended decision layer connects market priority to potential growth execution:
```text
Market
  ↓
Target Segment
  ↓
User Problem
  ↓
Use Case
  ↓
Channel
  ↓
KOL / Community / Events / Partnerships
  ↓
Sign-up
  ↓
Verification
  ↓
First Transaction
  ↓
Repeat Activity
  ↓
Retention
  ↓
Trading Volume / Revenue
```
This allows the analysis to move from:
**"Which market looks attractive?"**
to:
**"What could we actually do in that market?"**
Events, community programs, KOLs, and partnerships are treated as **growth activation levers**, rather than as core MEPS scoring indicators.
---
## Data Foundation
The MEPS data foundation currently integrates five public data sources.
### 1. World Bank
Current indicators:
* Population
* GDP per capita
* Internet penetration
Coverage:
* 4 countries
* 3 indicators
* 2015–2025
* 132 expected observations
### 2. Global Findex 2025
Current indicators:
* Account ownership
* Digital payment usage
* Smartphone adoption
The current MEPS extraction uses the latest common survey year available for the four initial markets: **2024**.
### 3. World Bank Remittances
Indicator:
* Personal remittances received (% of GDP)
World Bank indicator:
```text
BX.TRF.PWKR.DT.GD.ZS
```
Coverage:
* 4 countries
* 2015–2025
* 44 expected observations
Missing observations are preserved and documented rather than silently imputed.
### 4. Google Trends
Google Trends is used as a proxy for **relative crypto search interest**.
Current indicator:
```text
crypto_search_interest
```
Method:
* Search term: `crypto`
* Geography: worldwide request
* Resolution: country
* Reference period: 2025
* Output: relative search interest index from 0–100
The measure represents **relative search interest**, not absolute search volume, number of users, transaction volume, or crypto adoption.
### 5. Chainalysis
Chainalysis provides the Crypto Activity indicator.
Current indicator:
```text
crypto_adoption_rank
```
Dataset:
**2024 Global Crypto Adoption Index**
Current ranks:
| Country      | Global Rank |
| ------------ | ----------: |
| Ghana        |          46 |
| Kenya        |          28 |
| Nigeria      |           2 |
| South Africa |          30 |
The raw value is retained as a **global rank**.
Lower rank indicates stronger relative crypto adoption/activity.
The rank is not converted into an artificial score during ingestion. Direction handling and normalization occur during feature engineering.
---
## Data Pipeline
The current data foundation follows:
```text
Public Data Sources
        ↓
Python Ingestion
        ↓
Raw CSV Extracts
        ↓
Data Contract Validation
        ↓
DuckDB Raw Tables
        ↓
dbt Source Definitions
        ↓
dbt Staging Models
        ↓
Integrated Analytical Models
        ↓
Automated Data Quality Tests
        ↓
Analytical Market Mart
```
Current raw DuckDB tables:
```text
raw.raw_world_bank_indicators
raw.raw_world_bank_remittances
raw.raw_global_findex
raw.raw_google_trends
raw.raw_chainalysis_crypto_adoption
```
Current dbt staging models:
```text
stg_world_bank
stg_world_bank_remittances
stg_global_findex
stg_google_trends
stg_chainalysis
```
Current dbt analytical models:
```text
int_meps_indicators
mart_meps_market
```
---
## Data Engineering Layer
### Integrated Indicator Model
Model:
`int_meps_indicators`
Purpose:
Standardize the five staging datasets into a single long-form analytical indicator layer.
Analytical grain:
```text
country_code + indicator + reference_year
```
Columns:
| Column           | Description                      |
| ---------------- | -------------------------------- |
| `country_code`   | ISO3 country code                |
| `country`        | Country name                     |
| `indicator`      | Standardized MEPS indicator name |
| `value`          | Source indicator value           |
| `reference_year` | Original source reference year   |
| `source`         | Source organization              |
| `source_dataset` | Source dataset                   |
The model preserves historical observations and does not normalize, score, or weight indicators.
### Market Mart
Model:
`mart_meps_market`
Purpose:
Provide a wide, feature-ready representation of the four MEPS markets.
Grain:
```text
country_code
```
The mart contains one row per MEPS market and includes the latest available valid observation for each indicator.
Each indicator retains its corresponding reference year in a dedicated `*_year` field.
The mart does not perform MEPS scoring or normalization.
### Reference-Year Strategy
MEPS uses the **latest available valid observation** for the current-state market mart.
Source reference years are preserved rather than overwritten.
Where the latest observation is missing, the model selects the most recent valid observation rather than silently imputing a value.
Missing-value treatment for scoring is handled later during Feature Engineering.
### M4 Validation
The complete dbt build passes:
* **7 models**
* **23 data tests**
* **30 total build operations**
* **0 errors**
* **0 warnings**
The integrated indicator layer currently contains **236 observations** across the nine MEPS indicators.
---
## Feature Engineering Layer
### Feature Model
Model:
`int_meps_features`
Purpose:
Transform the current-state MEPS market indicators into comparable analytical features for downstream MEPS scoring.
The feature model sits between the analytical market mart and the MEPS scoring engine:
```text
mart_meps_market
        ↓
int_meps_features
        ↓
MEPS dimension scoring
        ↓
Final MEPS score
```
M5 does **not** calculate dimension scores or the final MEPS score. Those calculations are part of Milestone 6.
### Feature Engineering Methodology
The feature engineering process follows four steps:
1. Preserve the original indicator values.
2. Apply transformations where analytically justified.
3. Normalize indicators to a 0–1 scale.
4. Validate the resulting features before downstream scoring.
### Transformation Rules
#### Population
Population is transformed using:
`log1p(population)`
This reduces the influence of extreme population differences while preserving the relative ordering of the four MEPS markets.
The transformed population is then Min-Max normalized.
#### Crypto Adoption Rank
Chainalysis adoption rank has an inverse direction:
* Lower rank = stronger crypto activity.
* Higher rank = weaker crypto activity.
The rank is therefore direction-reversed before normalization.
The transformation is:
```text
max(rank) - rank
```
### Normalization
The remaining indicators are normalized using Min-Max scaling:
```text
(x - min(x)) / (max(x) - min(x))
```
The resulting feature values range from:
```text
0 = lowest relative value among the MEPS markets
1 = highest relative value among the MEPS markets
```
The normalization is comparative across the four current MEPS markets.
### Feature Treatment Matrix
| Indicator              | Transformation    | Direction             | Normalization |
| ---------------------- | ----------------- | --------------------- | ------------- |
| Population             | `log1p`           | Higher = stronger     | Min-Max       |
| GDP per capita         | None              | Higher = stronger     | Min-Max       |
| Remittances (% GDP)    | None              | Higher = stronger     | Min-Max       |
| Internet penetration   | None              | Higher = stronger     | Min-Max       |
| Smartphone adoption    | None              | Higher = stronger     | Min-Max       |
| Account ownership      | None              | Higher = stronger     | Min-Max       |
| Digital payment usage  | None              | Higher = stronger     | Min-Max       |
| Crypto search interest | None              | Higher = stronger     | Min-Max       |
| Crypto adoption rank   | Reverse direction | Lower rank = stronger | Min-Max       |
### Feature Model Output
Transformation columns:
* `population_transformed`
* `crypto_adoption_rank_transformed`
Normalized feature columns:
* `population_feature`
* `gdp_per_capita_feature`
* `remittances_pct_gdp_feature`
* `internet_penetration_feature`
* `smartphone_adoption_feature`
* `account_ownership_feature`
* `digital_payment_usage_feature`
* `crypto_search_interest_feature`
* `crypto_adoption_rank_feature`
### M5 Validation
The feature-engineering model is validated using three dbt tests:
* Feature range validation
* Country grain validation
* Not-null validation
Current validation result:
* **3 data tests**
* **3 passed**
* **0 errors**
* **0 warnings**
### Methodological Boundary
M5 produces normalized analytical features only.
It does not:
* calculate dimension scores;
* apply MEPS dimension weights;
* calculate the final MEPS score;
* rank the markets.
Those decisions belong to Milestone 6.
---
# Milestone 6 — MEPS Scoring Engine
Milestone 6 transforms the normalized features produced in Milestone 5 into interpretable dimension scores, a composite Market Expansion Priority Score (MEPS), market rankings, and sensitivity scenarios.
### Scoring Architecture
```text
Normalized Features
        ↓
Dimension Scores
        ↓
Baseline Dimension Weights
        ↓
MEPS Composite Score
        ↓
Market Ranking
        ↓
Sensitivity Analysis
```
### 6.1 MEPS Dimensions
| Dimension               | Features                                        |
| ----------------------- | ----------------------------------------------- |
| Market Attractiveness   | Population, GDP per capita, Remittances (% GDP) |
| Digital Readiness       | Internet penetration, Smartphone adoption       |
| Financial Accessibility | Account ownership, Digital payment usage        |
| Crypto Demand           | Crypto search interest                          |
| Crypto Activity         | Crypto adoption rank feature                    |
All underlying inputs are normalized to a 0–1 scale in Milestone 5.
### 6.2 Dimension Scoring
Features within multi-feature dimensions are combined using an equal-weight arithmetic mean.
**Market Attractiveness**
```text
(
    Population Feature
    + GDP per Capita Feature
    + Remittances Feature
) / 3
```
**Digital Readiness**
```text
(
    Internet Penetration Feature
    + Smartphone Adoption Feature
) / 2
```
**Financial Accessibility**
```text
(
    Account Ownership Feature
    + Digital Payment Usage Feature
) / 2
```
Crypto Demand and Crypto Activity each contain one approved feature and therefore use their normalized feature directly.
### 6.3 Baseline Dimension Weights
| Dimension               |   Weight |
| ----------------------- | -------: |
| Market Attractiveness   |      20% |
| Digital Readiness       |      20% |
| Financial Accessibility |      20% |
| Crypto Demand           |      20% |
| Crypto Activity         |      20% |
| **Total**               | **100%** |
Equal weighting is used as the initial benchmark because there is not yet sufficient empirical evidence to justify assigning greater importance to one dimension.
### 6.4 MEPS Composite Score
```text
MEPS =
    0.20 × Market Attractiveness
    + 0.20 × Digital Readiness
    + 0.20 × Financial Accessibility
    + 0.20 × Crypto Demand
    + 0.20 × Crypto Activity
```
The resulting score remains between 0 and 1.
A higher score indicates stronger **relative expansion priority within the current MEPS comparison universe**.
### 6.5 Baseline Market Results
| Rank | Market       | MEPS Score |
| ---: | ------------ | ---------: |
|    1 | Nigeria      | **0.5477** |
|    2 | South Africa | **0.4638** |
|    3 | Kenya        | **0.4367** |
|    4 | Ghana        | **0.3539** |
These scores are relative to the four markets currently included in MEPS.
They are not predictions of guaranteed market success, revenue, adoption, or market share.
### 6.6 Dimension Profiles
| Market       | Market Attractiveness | Digital Readiness | Financial Accessibility | Crypto Demand | Crypto Activity |
| ------------ | --------------------: | ----------------: | ----------------------: | ------------: | --------------: |
| Nigeria      |                0.6667 |            0.0719 |                  0.0000 |        1.0000 |          1.0000 |
| Ghana        |                0.2088 |            0.7221 |                  0.7066 |        0.1321 |          0.0000 |
| South Africa |                0.4402 |            1.0000 |                  0.5149 |        0.0000 |          0.3636 |
| Kenya        |                0.3287 |            0.3138 |                  1.0000 |        0.1321 |          0.4091 |
The dimension layer is retained so that the composite score can be decomposed into the underlying market characteristics.
### 6.7 Sensitivity Analysis
Four scenarios are currently evaluated:
| Scenario      | Market | Digital | Financial | Demand | Activity |
| ------------- | -----: | ------: | --------: | -----: | -------: |
| Baseline      |    20% |     20% |       20% |    20% |      20% |
| Market-led    |    30% |     20% |       20% |    15% |      15% |
| Crypto-led    |    15% |     15% |       15% |    25% |      30% |
| Readiness-led |    15% |     30% |       25% |    15% |      15% |
Every scenario totals 100%.
### 6.8 Sensitivity Results
| Scenario      | 1st          | 2nd          | 3rd   | 4th     |
| ------------- | ------------ | ------------ | ----- | ------- |
| Baseline      | Nigeria      | South Africa | Kenya | Ghana   |
| Market-led    | Nigeria      | South Africa | Kenya | Ghana   |
| Crypto-led    | Nigeria      | South Africa | Kenya | Ghana   |
| Readiness-led | South Africa | Kenya        | Ghana | Nigeria |
The baseline ordering remains unchanged under the market-led and crypto-led scenarios.
The readiness-led scenario produces a different ordering:
```text
South Africa
Kenya
Ghana
Nigeria
```
Under the crypto-led scenario:
```text
South Africa = 0.402360
Kenya        = 0.402127
Difference   ≈ 0.000234
```
Ranks should therefore be interpreted alongside the underlying scores.
### 6.9 MEPS Data Models
```text
int_meps_features
        ↓
int_meps_dimension_scores
        ↓
mart_meps_score
        ↓
mart_meps_market_ranking
int_meps_dimension_scores
        ↓
int_meps_sensitivity
```
| Model                       | Purpose                                                  |
| --------------------------- | -------------------------------------------------------- |
| `int_meps_dimension_scores` | Aggregates normalized features into five MEPS dimensions |
| `mart_meps_score`           | Calculates the baseline composite MEPS score             |
| `int_meps_sensitivity`      | Tests alternative dimension-weight scenarios             |
| `mart_meps_market_ranking`  | Produces the baseline production market ranking          |
### 6.10 Validation
Milestone 6 validates:
* Dimension scores remain within 0–1
* One dimension-score record per country
* No missing dimension scores
* MEPS scores remain within 0–1
* One baseline MEPS record per country
* No missing MEPS scores
* Sensitivity scores remain within 0–1
* Sensitivity ranks are valid
* Four markets are present in every sensitivity scenario
* No missing sensitivity scores or ranks
* One production ranking record per country
* Production ranking fields are populated
* Production ranks remain within 1–4
Full dbt pipeline validation:
```text
PASS=65
WARN=0
ERROR=0
SKIP=0
NO-OP=0
REUSED=0
```
### 6.11 Interpretation Boundary
MEPS is a **market-prioritization and decision-support framework**.
It is not:
* A prediction of future revenue
* A probability of expansion success
* An estimate of market share
* An investment recommendation
* An absolute measure of crypto adoption
MEPS results depend on:
* The markets included
* Indicator selection
* Source-data quality
* Reference periods
* Feature transformations
* Normalization methodology
* Dimension definitions
* Weighting assumptions
Because Min-Max normalization is relative to the current comparison universe, adding or removing markets can change feature values and therefore MEPS scores.
MEPS should therefore be used alongside commercial, regulatory, operational, and qualitative market intelligence.
### 6.12 Milestone 6 Status
**M6 — MEPS Scoring Engine: TECHNICAL BUILD COMPLETE**
Completed:
* ✅ Five dimension scoring
* ✅ Baseline MEPS calculation
* ✅ Sensitivity analysis
* ✅ Production market ranking
* ✅ M6 test suite
* ✅ Full dbt pipeline validation
---
## Current Milestone
**Milestone 6 — MEPS Scoring Engine**
The technical scoring engine is complete.
The next stage is **Milestone 7 — Market Intelligence**, which will translate the MEPS results and dimension profiles into market-specific insights and business implications.
---
## Data Quality
The data foundation uses explicit data contracts and automated validation.
Validation currently covers:
* Expected countries
* Expected indicators
* Expected years
* Expected row counts
* Required columns
* Numeric values
* Valid value ranges
* Positive Chainalysis ranks
* Duplicate analytical grain
* Missing observations
* dbt staging model integrity
* Integrated indicator uniqueness
* Integrated country coverage
* Market mart uniqueness
* Market mart country coverage
The integrated analytical grain is:
```text
country_code + indicator + reference_year
```
The market mart grain is:
```text
country_code
```
---
## Data Engineering Stack
| Layer               | Technology                 |
| ------------------- | -------------------------- |
| Data ingestion      | Python                     |
| Data manipulation   | Pandas                     |
| Analytical database | DuckDB                     |
| Transformation      | dbt                        |
| Query language      | SQL                        |
| Analysis            | Python                     |
| Visualization       | Power BI / dashboard layer |
| Version control     | Git / GitHub               |
---
## Repository Structure
```text
MEPS/
│
├── data/
│   ├── raw/
│   │   ├── world_bank/
│   │   ├── global_findex/
│   │   ├── google_trends/
│   │   └── chainalysis/
│   └── processed/
│
├── dbt/
│   ├── models/
│   │   ├── sources/
│   │   ├── staging/
│   │   ├── intermediate/
│   │   └── marts/
│   ├── tests/
│   └── dbt_project.yml
│
├── docs/
│   ├── data_dictionary.md
│   └── indicator_framework.md
│
├── notebooks/
│
├── sql/
│
├── src/
│   └── ingestion/
│       ├── world_bank.py
│       ├── load_world_bank_duckdb.py
│       ├── world_bank_remittances.py
│       ├── global_findex.py
│       ├── google_trends.py
│       ├── load_google_trends_duckdb.py
│       ├── chainalysis.py
│       └── load_chainalysis_duckdb.py
│
└── README.md
```
---
## Current Project Status
### Milestone 1 — Data Foundation 🔒 LOCKED
Completed:
* [x] World Bank data contract
* [x] Python ingestion pipeline
* [x] Raw data validation
* [x] DuckDB loading
* [x] dbt source definition
* [x] dbt staging model
* [x] dbt data-quality tests
* [x] Unique analytical grain validation
* [x] Data dictionary
* [x] GitHub checkpoint
---
### Milestone 2 — MEPS Indicator Framework 🔒 LOCKED
Completed:
* [x] Define the final business decision
* [x] Challenge the original six dimensions
* [x] Select final core dimensions
* [x] Select final indicators
* [x] Define measurement methodology
* [x] Remove Growth Potential from the core score
* [x] Redesign Growth Potential as Trajectory Analysis
* [x] Freeze the MEPS indicator framework
* [x] Document the final framework
Final core dimensions:
```text
Market Attractiveness
Digital Readiness
Financial Accessibility
Crypto Demand
Crypto Activity
```
---
### Milestone 3 — Data Expansion 🔒 LOCKED
Completed:
* [x] Global Findex pipeline
* [x] World Bank remittances pipeline
* [x] Google Trends crypto demand pipeline
* [x] Chainalysis crypto activity pipeline
* [x] DuckDB raw-layer loading
* [x] dbt source definitions
* [x] dbt staging models
* [x] Automated data-quality tests
* [x] Data dictionary update
* [x] README update
* [x] GitHub checkpoint
Current data sources:
```text
World Bank
Global Findex
World Bank Remittances
Google Trends
Chainalysis
```
---
### Milestone 4 — Data Engineering 🔒 LOCKED
Completed:
* [x] Define analytical data grain
* [x] Preserve source reference years
* [x] Build integrated long-form indicator model
* [x] Build current-state market mart
* [x] Add intermediate-model data-quality tests
* [x] Add mart data-quality tests
* [x] Validate four-market coverage
* [x] Run full dbt build
* [x] Document the analytical data model
* [x] GitHub checkpoint
Current transformation layer:
```text
5 staging models
      ↓
int_meps_indicators
      ↓
mart_meps_market
```
Full dbt build result:
* **7 models**
* **23 data tests**
* **30 total operations**
* **0 errors**
* **0 warnings**
---
### Milestone 5 — Feature Engineering 🔒 LOCKED
Completed:
* [x] Define indicator direction
* [x] Define normalization methodology
* [x] Define transformations
* [x] Build normalized feature model
* [x] Validate feature ranges
* [x] Validate country grain
* [x] Validate feature completeness
* [x] Document feature methodology
* [x] GitHub checkpoint
Feature model:
```text
mart_meps_market
      ↓
int_meps_features
```
Feature engineering includes:
* Population `log1p` transformation
* Chainalysis rank direction reversal
* Min-Max normalization
* 0–1 feature validation
Validation result:
* **3 data tests**
* **3 passed**
* **0 errors**
* **0 warnings**
---
### Milestone 6 — MEPS Scoring Engine 🟡 TECHNICAL BUILD COMPLETE
Completed:
* [x] Five dimension scoring
* [x] Equal feature aggregation within dimensions
* [x] Baseline 20% dimension weights
* [x] Composite MEPS calculation
* [x] Sensitivity analysis
* [x] Production market ranking
* [x] M6 test suite
* [x] Full dbt pipeline validation
* [x] README documentation
Baseline production results:
| Rank | Market       |   MEPS |
| ---: | ------------ | -----: |
|    1 | Nigeria      | 0.5477 |
|    2 | South Africa | 0.4638 |
|    3 | Kenya        | 0.4367 |
|    4 | Ghana        | 0.3539 |
Full pipeline validation:
```text
PASS=65
WARN=0
ERROR=0
SKIP=0
NO-OP=0
REUSED=0
```
**GitHub lock is pending final documentation QA and repository verification.**
---
## Data & Methodology Principles
MEPS follows several principles:
### 1. Business question first
Indicators are selected because they answer a decision-relevant question, not simply because the data is available.
### 2. No silent assumptions
Missing data, proxies, limitations, and methodological decisions are documented.
### 3. Avoid double counting
Highly correlated indicators will be reviewed to avoid giving the same underlying concept excessive influence.
### 4. Preserve raw data
Raw source values are retained without analytical transformations. Transformations such as normalization, direction handling, and scoring occur in downstream layers.
### 5. Preserve reference periods
Source reference years are retained throughout the analytical pipeline rather than being overwritten to create artificial temporal consistency.
### 6. Normalize before aggregation
Indicators measured on different scales will be transformed before they are combined.
### 7. Test the model
Weights, assumptions, and model outputs will be challenged through sensitivity analysis.
### 8. Separate exploration from production
Notebooks are used for exploration and analysis, while the reproducible pipeline is maintained through Python, SQL, DuckDB, and dbt.
---
## Data Limitations
MEPS relies primarily on publicly available data. Public indicators may not fully capture:
* Country-level crypto adoption
* Exchange-specific market share
* Regulatory conditions
* Local competitive intensity
* User acquisition costs
* Product-market fit
* Payment reliability
* Customer lifetime value
* Local partnership availability
### Google Trends
Google Trends measures relative search interest. It should not be interpreted as absolute search volume, number of crypto users, transaction volume, or guaranteed market demand.
### Chainalysis
The current MEPS implementation uses the **2024 Global Crypto Adoption Index rank** because the publicly accessible 2025 materials do not provide a reproducible country-level score table for all four MEPS markets.
The rank is therefore preserved as the raw activity measure and transformed only during feature engineering.
### Reference Periods
Different datasets use different reference periods, methodologies, and collection frequencies. MEPS preserves these source reference periods rather than treating observations from different years as if they were collected simultaneously.
### Missing Observations
Missing observations are preserved through the raw and integrated layers. The current-state mart selects the latest valid observation where a newer observation is missing.
Where direct measures are unavailable, proxies will be explicitly identified and their limitations documented.
---
## Project Objective
The final output of MEPS is intended to answer:
> **Which African market should a crypto/fintech company prioritize, what evidence supports that decision, and what growth actions should follow from it?**
