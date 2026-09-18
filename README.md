# Africa Crypto Market Intelligence — MEPS

## Market Expansion Priority Score

**MEPS** is a data-driven market intelligence framework designed to help a crypto or fintech company decide **which African market to prioritize when expansion resources are limited**.

The project combines public market, digital infrastructure, financial access, crypto demand, and crypto activity indicators into a reproducible scoring framework that ranks markets and translates the ranking into potential growth actions.

MEPS is designed as a **market prioritization framework**, not a prediction model. A higher score represents stronger relative priority based on the selected indicators; it does not guarantee commercial success.

---

## Business Problem

Expanding into a new market requires decisions about where to allocate limited resources such as:

* Market research
* Partnerships
* Marketing spend
* Community development
* Business development
* Product localization
* Regulatory and operational preparation

The question MEPS aims to answer is:

> **If we can prioritize only a few African markets, which markets should we investigate or activate first, and why?**

MEPS connects market-level evidence to a structured prioritization framework so that expansion decisions can be supported by reproducible data rather than isolated indicators.

---

## Markets

The initial analysis covers four African markets:

| Country      | Code |
| ------------ | ---- |
| Ghana        | GHA  |
| Kenya        | KEN  |
| Nigeria      | NGA  |
| South Africa | ZAF  |

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

* Population
* GDP per capita
* Personal remittances received (% of GDP)

#### 2. Digital Readiness

* Internet penetration
* Smartphone adoption

#### 3. Financial Accessibility

* Account ownership
* Digital payment usage

#### 4. Crypto Demand

* Relative Google search interest for `crypto`

#### 5. Crypto Activity

* Chainalysis 2024 Global Crypto Adoption Index rank

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
```

The scoring methodology will normalize indicators before combining them.

The model will also include sensitivity analysis to test whether market rankings remain reasonably stable under changes to assumptions and weights.

MEPS will preserve raw source values and separate data ingestion from analytical transformation. For example, the Chainalysis adoption rank remains a raw rank during ingestion and staging; direction handling and normalization occur later during feature engineering.

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

---

### 2. Global Findex 2025

The Global Findex dataset provides financial access and digital payment indicators.

Current indicators:

* Account ownership
* Digital payment usage
* Smartphone adoption

The current MEPS extraction uses the latest common survey year available for the four initial markets: **2024**.

---

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

---

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

---

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

The rank is **not converted into an artificial score during ingestion**. Direction handling and normalization will occur during feature engineering.

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
Automated Data Quality Tests
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

The current analytical grain is generally:

```text
country_code + indicator + year
```

where applicable.

The complete Milestone 3 dbt build currently passes:

* **5 staging models**
* **19 data tests**
* **24 total build operations**
* **0 errors**
* **0 warnings**

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

The data foundation has been expanded beyond the original World Bank dataset.

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

### Next Milestone — Data Engineering

**Milestone 4 — Data Engineering**

The next stage will transform the validated staging layer into reusable intermediate and analytical models.

Planned work includes:

* [ ] Build integrated analytical dataset
* [ ] Align indicators across sources
* [ ] Establish intermediate dbt models
* [ ] Establish analytical marts
* [ ] Add integrated-model data-quality tests
* [ ] Prepare reproducible transformation workflow
* [ ] Document the analytical data model

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

### 5. Normalize before aggregation

Indicators measured on different scales will be transformed before they are combined.

### 6. Test the model

Weights, assumptions, and model outputs will be challenged through sensitivity analysis.

### 7. Separate exploration from production

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

Specific source limitations are also important.

**Google Trends**

Google Trends measures relative search interest. It should not be interpreted as absolute search volume, number of crypto users, transaction volume, or guaranteed market demand.

**Chainalysis**

The current MEPS implementation uses the **2024 Global Crypto Adoption Index rank** because the publicly accessible 2025 materials do not provide a reproducible country-level score table for all four MEPS markets.

The rank is therefore preserved as the raw activity measure and will be transformed only during feature engineering.

**Public data coverage**

Different datasets use different reference periods, methodologies, and collection frequencies. These differences will be documented and considered when integrating the indicators.

Where direct measures are unavailable, proxies will be explicitly identified and their limitations documented.

---

## Project Objective

The final output of MEPS is intended to answer:

> **Which African market should a crypto/fintech company prioritize, what evidence supports that decision, and what growth actions should follow from it?**

The goal is to connect:

**Data Engineering → Analytics → Market Intelligence → Growth Strategy → Business Decision-Making**

in one reproducible portfolio project.
