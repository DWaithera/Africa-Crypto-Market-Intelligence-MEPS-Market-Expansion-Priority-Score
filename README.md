# Africa Crypto Market Intelligence — MEPS

## Market Expansion Priority Score

**MEPS** is a data-driven market intelligence framework designed to help a crypto or fintech company decide **which African market to prioritize when expansion resources are limited**.

The project combines public market, digital infrastructure, financial access, and crypto-market indicators into a reproducible scoring framework that ranks markets and translates the ranking into potential growth actions.

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

MEPS is therefore a **market prioritization framework**, not a prediction model. A high score indicates stronger relative priority based on the selected indicators; it does not guarantee commercial success.

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

MEPS is being developed around six dimensions:

1. **Market Attractiveness**
2. **Digital Readiness**
3. **Financial Accessibility**
4. **Crypto Demand**
5. **Crypto Activity**
6. **Growth Potential**

Each indicator will be evaluated based on:

* The business question it answers
* Its relevance to market expansion
* Measurement methodology
* Data quality
* Direction of impact
* Potential overlap with other indicators
* Data availability
* Appropriate weighting

The final framework will be frozen only after these assumptions have been challenged and tested.

---

## Methodology

The analytical pipeline follows:

```text
Data Sources
      ↓
Python Ingestion
      ↓
Raw Data
      ↓
Validation & Quality Checks
      ↓
DuckDB
      ↓
dbt Staging
      ↓
Feature Engineering
      ↓
Dimension Scores
      ↓
MEPS Score
      ↓
Country Ranking
      ↓
Market Intelligence
      ↓
Growth Activation
      ↓
Business Recommendation
```

The scoring methodology will normalize indicators before combining them and will include sensitivity analysis to determine whether country rankings are robust to reasonable changes in assumptions and weights.

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

---

## Data Foundation

The first completed data source is the **World Bank**.

Current indicators include:

* Population
* GDP per capita
* Internet penetration

Coverage:

* 4 countries
* 3 indicators
* 2015–2025
* 132 expected observations

The World Bank ingestion pipeline validates the expected countries, indicators, years, numeric ranges, duplicate grain, row count, and missing observations before the data enters the analytical workflow.

Missing values are preserved rather than silently imputed.

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
│   └── processed/
│
├── dbt/
│   ├── models/
│   │   ├── sources/
│   │   └── staging/
│   ├── tests/
│   └── dbt_project.yml
│
├── docs/
│   └── data_dictionary.md
│
├── notebooks/
│
├── sql/
│
├── src/
│   └── ingestion/
│       ├── world_bank.py
│       └── load_world_bank_duckdb.py
│
└── README.md
```

---

## Current Project Status

### Milestone 1 — Data Foundation

**Status: Complete and locked**

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

### Milestone 2 — MEPS Indicator Framework

**Status: In progress**

* [ ] Define the final business decision
* [ ] Challenge the six dimensions
* [ ] Select final indicators
* [ ] Define measurement methodology
* [ ] Define normalization approach
* [ ] Define weighting methodology
* [ ] Freeze the MEPS framework

### Upcoming

* [ ] Expand data sources
* [ ] Build production-style transformation pipeline
* [ ] Feature engineering
* [ ] MEPS scoring engine
* [ ] Market intelligence layer
* [ ] Growth activation analysis
* [ ] Dashboard
* [ ] Sensitivity analysis and QA
* [ ] Final market recommendations

---

## Data & Methodology Principles

MEPS follows several principles:

**1. Business question first**

Indicators are selected because they answer a decision-relevant question, not simply because the data is available.

**2. No silent assumptions**

Missing data, proxies, limitations, and methodological decisions will be documented.

**3. Avoid double counting**

Highly correlated indicators will be reviewed to avoid giving the same underlying concept excessive influence.

**4. Normalize before aggregation**

Indicators measured on different scales will be transformed before they are combined.

**5. Test the model**

Weights and assumptions will be challenged through sensitivity analysis.

**6. Separate exploration from production**

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

Where direct measures are unavailable, proxies will be explicitly identified and their limitations documented.

---

## Project Objective

The final output of MEPS is intended to answer:

> **Which African market should a crypto/fintech company prioritize, what evidence supports that decision, and what growth actions should follow from it?**

The goal is to connect **data engineering → analytics → market intelligence → growth strategy → business decision-making** in one reproducible project.
