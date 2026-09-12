# MEPS Data Dictionary

## 1. Purpose

This document defines the data sources, indicators, analytical grain, coverage, validation rules, methodology, and reproducibility requirements for the MEPS (Market Expansion Priority Score) framework.

MEPS evaluates African markets for potential crypto/fintech expansion by combining macroeconomic, digital-readiness, financial-accessibility, crypto-demand, and crypto-activity indicators.

The core business question is:

> **If expansion resources are limited, which market should be prioritized first, and what evidence supports that decision?**

The initial MEPS markets are:

* Ghana (GHA)
* Kenya (KEN)
* Nigeria (NGA)
* South Africa (ZAF)

The current data foundation consists of:

1. World Bank core indicators
2. World Bank Global Findex 2025 indicators
3. World Bank remittances
4. Google Trends crypto demand

The final MEPS core dimensions are:

1. Market Attractiveness
2. Digital Readiness
3. Financial Accessibility
4. Crypto Demand
5. Crypto Activity

Growth Potential is not treated as a separate core scoring dimension. Historical changes in selected indicators will instead be examined through a **Trajectory Analysis** layer after the core MEPS score.

---

# 2. Common Data Standards

## 2.1 Target Countries

| Country      | ISO 3-letter code |
| ------------ | ----------------- |
| Ghana        | GHA               |
| Kenya        | KEN               |
| Nigeria      | NGA               |
| South Africa | ZAF               |

---

## 2.2 Analytical Grain

The standard MEPS analytical grain is:

**One country × one indicator × one year**

The exact uniqueness key depends on the source.

### World Bank

```text
country_code
indicator_code
year
```

### Global Findex

```text
country_code
indicator
year
```

### Google Trends

```text
country_code
indicator
year
```

---

## 2.3 Missing Values

Missing source observations are preserved.

MEPS does not silently impute missing values during ingestion.

Any future imputation, estimation, or gap-filling must be explicitly documented at the analytical/modeling layer.

---

## 2.4 Data Transformation Principle

Raw source data is not overwritten.

The general MEPS pipeline is:

```text
External source
      ↓
Raw source file
      ↓
Python ingestion
      ↓
Validation
      ↓
Raw DuckDB table
      ↓
dbt source
      ↓
dbt staging
      ↓
Feature engineering
      ↓
Normalization
      ↓
Dimension scores
      ↓
MEPS scoring
      ↓
Country ranking
      ↓
Trajectory analysis
      ↓
Market intelligence
      ↓
Growth activation
      ↓
Dashboard
```

---

# 3. MEPS Indicator Framework

## 3.1 Core Dimensions

The current MEPS framework contains five core analytical dimensions.

| Dimension               | Approved indicators                             |
| ----------------------- | ----------------------------------------------- |
| Market Attractiveness   | Population, GDP per capita, Remittances (% GDP) |
| Digital Readiness       | Internet penetration, Smartphone adoption       |
| Financial Accessibility | Account ownership, Digital payment usage        |
| Crypto Demand           | Crypto search interest                          |
| Crypto Activity         | Crypto adoption index                           |

---

## 3.2 Market Attractiveness

Market Attractiveness evaluates the structural economic opportunity and size of a market.

Approved indicators:

* Population
* GDP per capita
* Personal remittances received (% of GDP)

---

## 3.3 Digital Readiness

Digital Readiness evaluates whether the population has the connectivity and device access required to participate in digital products.

Approved indicators:

* Internet penetration
* Smartphone adoption

---

## 3.4 Financial Accessibility

Financial Accessibility evaluates the degree to which consumers have access to and use formal or digital financial services.

Approved indicators:

* Account ownership
* Digital payment usage

Account ownership already includes accounts held through financial institutions and mobile-money providers. Mobile-money account ownership is therefore not treated as an additional independent core indicator.

---

## 3.5 Crypto Demand

Crypto Demand evaluates market-level interest in cryptocurrency.

Approved indicator:

* Crypto search interest

Google Trends is used as a proxy for relative search interest rather than as a direct measure of users, adoption, or transaction activity.

---

## 3.6 Crypto Activity

Crypto Activity is intended to capture observable cryptocurrency adoption/activity at the market level.

Approved indicator:

* Crypto adoption index

The adoption index will be incorporated after the crypto-demand pipeline is completed.

---

## 3.7 Trajectory Analysis

Historical change is treated as a separate analytical layer rather than an additional core MEPS dimension.

Trajectory analysis will examine changes in selected indicators over time to identify:

* improving markets
* declining markets
* accelerating markets
* structural changes
* emerging opportunities

Trajectory analysis should not be allowed to double-count the same underlying signal inside the core MEPS score.

---

# 4. World Bank Data

## 4.1 Dataset Overview

The MEPS World Bank dataset provides macroeconomic and digital-readiness indicators for the four initial MEPS markets.

The current World Bank core dataset covers annual observations from **2015 to 2025**.

These indicators form part of the foundational dataset used by the MEPS framework.

---

## 4.2 Data Source

**Source:** World Bank

The data is retrieved programmatically through the World Bank API using the MEPS Python ingestion pipeline.

Raw source file:

```text
data/raw/world_bank/world_bank_indicators.csv
```

---

## 4.3 Source Indicators

| Indicator Code | MEPS Name            | Description                          | Unit            |
| -------------- | -------------------- | ------------------------------------ | --------------- |
| SP.POP.TOTL    | population           | Total population                     | Persons         |
| NY.GDP.PCAP.CD | gdp_per_capita       | GDP per capita in current US dollars | Current US$     |
| IT.NET.USER.ZS | internet_penetration | Individuals using the internet       | % of population |

---

## 4.4 Dataset Grain

The analytical grain is:

**One country × one indicator × one year**

Uniqueness key:

```text
country_code
indicator_code
year
```

Expected grain:

```text
4 countries
×
3 indicators
×
11 years
=
132 records
```

---

## 4.5 Coverage

| Attribute        | Value                               |
| ---------------- | ----------------------------------- |
| Countries        | Ghana, Kenya, Nigeria, South Africa |
| Country codes    | GHA, KEN, NGA, ZAF                  |
| Indicators       | 3                                   |
| Years            | 2015–2025                           |
| Expected records | 132                                 |

---

## 4.6 World Bank Validation

The ingestion pipeline validates:

* required API response structure
* required columns
* target countries
* target indicators
* year range
* numeric values
* non-negative population
* non-negative GDP per capita
* internet penetration within 0–100
* duplicate analytical grain
* expected record count

Missing observations are preserved rather than imputed.

Current known missing observations:

```text
GHA — IT.NET.USER.ZS — 2025
KEN — IT.NET.USER.ZS — 2025
NGA — IT.NET.USER.ZS — 2025
ZAF — IT.NET.USER.ZS — 2025
```

Current validation results:

```text
Total records: 132
Missing values: 4
Duplicate grain records: 0
```

---

## 4.7 World Bank DuckDB

Raw DuckDB table:

```text
raw.raw_world_bank_indicators
```

The table is populated by:

```text
src/ingestion/load_world_bank_duckdb.py
```

---

## 4.8 World Bank dbt

dbt source:

```text
world_bank.raw_world_bank_indicators
```

dbt staging model:

```text
dbt/models/staging/stg_world_bank.sql
```

Resulting relation:

```text
main.stg_world_bank
```

The staging layer standardizes the raw source for downstream MEPS transformations.

A singular dbt test validates uniqueness of:

```text
country_code
indicator_code
year
```

---

# 5. Global Findex 2025

## 5.1 Dataset Overview

The Global Findex Database 2025 provides country-level indicators covering financial inclusion, payments, mobile phone ownership, internet use, digital safety, saving, borrowing, and related topics.

The 2025 edition reports country-level indicators for survey years including **2024, 2021, 2017, 2014, and 2011**.

For the current MEPS core scoring dataset, the **2024 observations** are used.

---

## 5.2 Data Source

**Source:** World Bank Global Findex 2025

Original raw workbook:

```text
data/raw/global_findex/global_findex_2025.xlsx
```

The raw workbook is retained unchanged.

The MEPS-specific extraction is produced by:

```text
src/ingestion/global_findex.py
```

Validated analytical extract:

```text
data/raw/global_findex/global_findex_meps.csv
```

---

## 5.3 Selected Findex Indicators

| Findex Series | MEPS Name             | Description                                                                | Unit             |
| ------------- | --------------------- | -------------------------------------------------------------------------- | ---------------- |
| account.t.d   | account_ownership     | Adults with an account at a financial institution or mobile money provider | Proportion (0–1) |
| g20.any       | digital_payment_usage | Adults who made or received a digital payment                              | Proportion (0–1) |
| con9a         | smartphone_adoption   | Adults whose main mobile phone is a smartphone                             | Proportion (0–1) |

---

## 5.4 Indicator Selection Rationale

### Account Ownership

```text
account.t.d
→ account_ownership
```

This is used as the core financial-accessibility measure.

Mobile money account ownership is not added as a separate core indicator because account ownership already captures account ownership through financial institutions and mobile money providers.

This avoids double-counting the same underlying financial-access concept.

### Digital Payment Usage

```text
g20.any
→ digital_payment_usage
```

This captures the use of digital payment mechanisms and provides a behavioral measure of digital financial activity.

### Smartphone Adoption

```text
con9a
→ smartphone_adoption
```

This measures whether the respondent's main mobile phone is a smartphone.

Other smartphone-related variables in the workbook are not used for the core MEPS indicator.

---

## 5.5 Dataset Grain

The analytical grain is:

**One country × one indicator × one year**

Uniqueness key:

```text
country_code
indicator
year
```

For the core MEPS extract:

```text
4 countries
×
3 indicators
×
1 year
=
12 records
```

---

## 5.6 Coverage

| Attribute               | Value                               |
| ----------------------- | ----------------------------------- |
| Countries               | Ghana, Kenya, Nigeria, South Africa |
| Country codes           | GHA, KEN, NGA, ZAF                  |
| Core year               | 2024                                |
| Indicators              | 3                                   |
| Expected records        | 12                                  |
| Missing core values     | 0                                   |
| Duplicate grain records | 0                                   |

---

## 5.7 Findex Extraction Rules

The ingestion pipeline applies the following filters:

```text
year = 2024
group = all
group2 = all
country_code ∈ {GHA, KEN, NGA, ZAF}
```

The following Findex series are extracted:

```text
account.t.d
g20.any
con9a
```

The original 466-column workbook is not modified.

---

## 5.8 Findex Validation

The ingestion pipeline validates:

* target countries
* target year
* target Findex series
* expected number of records
* numeric indicator values
* proportion range of 0–1
* duplicate analytical grain
* missing values

Current core extract results:

```text
Rows: 12
Countries: 4
Indicators: 3
Year: 2024
Missing values: 0
Duplicate grain records: 0
```

---

## 5.9 Findex Values

The validated 2024 observations are:

| Country      | Account Ownership | Digital Payment Usage | Smartphone Adoption |
| ------------ | ----------------: | --------------------: | ------------------: |
| Ghana        |          0.812430 |              0.803643 |            0.535256 |
| Kenya        |          0.901199 |              0.892835 |            0.549135 |
| Nigeria      |          0.632614 |              0.544771 |            0.336764 |
| South Africa |          0.811260 |              0.671722 |            0.675104 |

Values are retained as proportions between 0 and 1.

Conversion to percentages should occur only in presentation or dashboard layers.

---

## 5.10 Findex DuckDB

Raw DuckDB table:

```text
raw.raw_global_findex
```

The table is populated by:

```text
src/ingestion/load_global_findex_duckdb.py
```

Validation confirms:

```text
Rows: 12
Countries: 4
Indicators: 3
Missing values: 0
Duplicate grain records: 0
```

---

## 5.11 Findex dbt

dbt source:

```text
global_findex.raw_global_findex
```

dbt staging model:

```text
dbt/models/staging/stg_global_findex.sql
```

Resulting relation:

```text
main.stg_global_findex
```

The staging model standardizes:

```text
country_code
country
year
series
indicator
value
source
```

The staging model casts:

```text
year → integer
value → double
```

---

## 5.12 Findex dbt Tests

### Analytical grain uniqueness

```text
dbt/tests/test_stg_global_findex.sql
```

Validates uniqueness of:

```text
country_code
indicator
year
```

### Value range

```text
dbt/tests/test_stg_global_findex_value_range.sql
```

Validates that non-null indicator values remain within:

```text
0 ≤ value ≤ 1
```

Both tests currently pass.

---

# 6. World Bank Remittances

## 6.1 Dataset Overview

The MEPS remittances dataset contains annual personal remittances received as a percentage of GDP for the four initial MEPS markets:

* Ghana (GHA)
* Kenya (KEN)
* Nigeria (NGA)
* South Africa (ZAF)

The indicator is sourced from the World Bank World Development Indicators (WDI).

---

## 6.2 Source Indicator

| Field                     | Definition                                                                            |
| ------------------------- | ------------------------------------------------------------------------------------- |
| World Bank indicator code | `BX.TRF.PWKR.DT.GD.ZS`                                                                |
| MEPS indicator name       | `remittances_pct_gdp`                                                                 |
| Indicator                 | Personal remittances, received (% of GDP)                                             |
| Source                    | World Bank World Development Indicators                                               |
| Frequency                 | Annual                                                                                |
| Unit                      | Percentage of GDP                                                                     |
| Direction                 | Higher values indicate greater remittance inflows relative to the size of the economy |

---

## 6.3 Coverage

| Dimension             | Coverage           |
| --------------------- | ------------------ |
| Countries             | GHA, KEN, NGA, ZAF |
| Years                 | 2015–2025          |
| Expected observations | 44                 |
| Actual observations   | 44                 |

The historical series is retained because remittances may contribute to future MEPS trajectory analysis in addition to the current market-attractiveness assessment.

---

## 6.4 Dataset Grain

The dataset grain is:

**One country × one indicator × one year**

The uniqueness key is:

```text
country_code
indicator_code
year
```

Expected grain:

```text
4 countries
×
1 indicator
×
11 years
=
44 records
```

---

## 6.5 Raw Data

The validated raw extract is stored at:

```text
data/raw/world_bank/world_bank_remittances.csv
```

The raw extract is produced by:

```text
src/ingestion/world_bank_remittances.py
```

The ingestion pipeline retrieves the World Bank API response, filters the approved countries and years, standardizes the indicator name, validates the data contract, and writes the validated CSV.

---

## 6.6 Data Validation

The ingestion pipeline validates:

* target countries
* indicator code
* indicator name
* year range
* expected record count
* numeric values
* non-negative values
* duplicate grain
* missing values

Missing source observations are preserved rather than imputed.

Current missing observation:

| Country | Year | Indicator             |
| ------- | ---: | --------------------- |
| Kenya   | 2025 | `remittances_pct_gdp` |

The missing observation is retained as `NULL` in downstream analytical layers.

Current validation results:

```text
Rows: 44
Countries: 4
Indicators: 1
Missing values: 1
Duplicate grain records: 0
Negative values: 0
```

---

## 6.7 DuckDB Storage

The validated CSV is loaded into DuckDB using:

```text
src/ingestion/load_world_bank_remittances_duckdb.py
```

Raw DuckDB table:

```text
raw.raw_world_bank_remittances
```

---

## 6.8 dbt Source

The raw DuckDB table is registered as a dbt source:

```text
world_bank_remittances.raw_world_bank_remittances
```

Source definition:

```text
dbt/models/sources/src_world_bank_remittances.yml
```

---

## 6.9 dbt Staging

The staging model is:

```text
dbt/models/staging/stg_world_bank_remittances.sql
```

Resulting relation:

```text
main.stg_world_bank_remittances
```

The staging model standardizes the `year` and `value` fields while preserving the source indicator, country, and provenance fields.

---

## 6.10 dbt Tests

Two singular data-quality tests are applied.

### Analytical grain uniqueness

```text
dbt/tests/test_stg_world_bank_remittances.sql
```

Checks that:

```text
country_code + indicator_code + year
```

contains no duplicate records.

### Value range

```text
dbt/tests/test_stg_world_bank_remittances_value_range.sql
```

Checks that non-null remittance values are not negative.

Current result:

```text
PASS = 2
WARN = 0
ERROR = 0
```

---

## 6.11 MEPS Role

Remittances belong to the:

**Market Attractiveness** dimension.

The indicator provides a measure of the relative importance of remittance inflows within each economy.

It should not be interpreted independently as evidence that a country will have higher crypto adoption.

Instead, it contributes one component of the broader market-attractiveness assessment.

---

## 6.12 Methodological Considerations

Remittances are measured relative to GDP, which improves comparability across economies of different sizes.

However, the indicator should not be treated as a direct measure of:

* crypto usage
* crypto adoption
* exchange demand
* transaction volume
* profitability
* market-entry success

It is therefore used as a **contextual market indicator**, alongside digital readiness, financial accessibility, crypto demand, and crypto activity.

---

# 7. Google Trends

## 7.1 Dataset Overview

The MEPS Google Trends dataset provides country-level relative search interest for the term `crypto` and is used as a proxy for the **Crypto Demand** dimension.

---

## 7.2 Source Indicator

| Field          | Definition                                               |
| -------------- | -------------------------------------------------------- |
| Source         | Google Trends                                            |
| Query          | `crypto`                                                 |
| MEPS indicator | `crypto_search_interest`                                 |
| Geography      | Worldwide request with country-level extraction          |
| Period         | 2025                                                     |
| Frequency      | Country-level annual aggregate                           |
| Unit           | Relative search-interest index (0–100)                   |
| Direction      | Higher values indicate stronger relative search interest |

---

## 7.3 Coverage

| Attribute               | Value                               |
| ----------------------- | ----------------------------------- |
| Countries               | Ghana, Kenya, Nigeria, South Africa |
| Country codes           | GHA, KEN, NGA, ZAF                  |
| Year                    | 2025                                |
| Indicator               | `crypto_search_interest`            |
| Expected records        | 4                                   |
| Actual records          | 4                                   |
| Missing values          | 0                                   |
| Duplicate grain records | 0                                   |

---

## 7.4 Dataset Grain

The analytical grain is:

**One country × one indicator × one year**

Uniqueness key:

```text
country_code
indicator
year
```

---

## 7.5 Methodology

Google Trends results are normalized within a request and represented on a relative 0–100 scale.

To make the four MEPS markets comparable, the ingestion pipeline uses **one worldwide Google Trends request** and extracts country-level interest from that common request.

Independent country-specific requests are not used for cross-country scoring because each request may have its own normalization.

The Google Trends public interface is therefore treated as a relative search-interest source rather than an absolute search-volume source.

---

## 7.6 Validated Values

| Country      | Crypto Search Interest |
| ------------ | ---------------------: |
| Ghana        |                     31 |
| Kenya        |                     31 |
| Nigeria      |                     77 |
| South Africa |                     24 |

---

## 7.7 Interpretation

Higher values indicate stronger relative search interest for `crypto` within the common worldwide request.

The values do **not** represent:

* absolute search volume
* number of crypto users
* crypto adoption
* transaction volume
* trading volume
* revenue
* market size

Google Trends is therefore used as a **proxy signal for crypto demand**, not as a direct measure of crypto activity or adoption.

---

## 7.8 Raw Data

Validated raw extract:

```text
data/raw/google_trends/google_trends_crypto.csv
```

Python ingestion:

```text
src/ingestion/google_trends.py
```

---

## 7.9 DuckDB Storage

Raw DuckDB table:

```text
raw.raw_google_trends
```

DuckDB loader:

```text
src/ingestion/load_google_trends_duckdb.py
```

---

## 7.10 dbt Source

dbt source:

```text
google_trends.raw_google_trends
```

Source definition:

```text
dbt/models/sources/src_google_trends.yml
```

---

## 7.11 dbt Staging

Staging model:

```text
dbt/models/staging/stg_google_trends.sql
```

Resulting relation:

```text
main.stg_google_trends
```

The staging model standardizes the year and value fields while preserving country, indicator, and source information.

---

## 7.12 dbt Tests

Two singular data-quality tests are applied.

### Analytical grain uniqueness

```text
dbt/tests/test_stg_google_trends.sql
```

Checks that:

```text
country_code + indicator + year
```

contains no duplicate records.

### Value range

```text
dbt/tests/test_stg_google_trends_value_range.sql
```

Checks that Google Trends values remain within:

```text
0 ≤ value ≤ 100
```

Current result:

```text
PASS = 2
WARN = 0
ERROR = 0
```

The end-to-end dbt build also passed:

```text
PASS = 3
WARN = 0
ERROR = 0
```

This represents:

* 1 staging view successfully built
* 2 data-quality tests passed

---

## 7.13 MEPS Role

Google Trends belongs to the:

**Crypto Demand** dimension.

It provides a relative measure of search interest in cryptocurrency and complements the Crypto Activity dimension.

It should not be interpreted as direct evidence of:

* crypto adoption
* active users
* transaction activity
* exchange volume
* profitability

---

## 7.14 Limitations

Google Trends data is sampled, aggregated, anonymized, and normalized.

The 0–100 index is a relative measure rather than an absolute measure of search activity.

The current MEPS implementation uses the search term `crypto`. Search interest may therefore capture broad cryptocurrency-related interest rather than interest in a specific asset, exchange, product, or use case.

Cross-country comparison relies on a single common worldwide request to maintain a common normalization framework across the four MEPS markets.

The Google Trends alpha API is not required for the current MEPS pipeline.

---

# 8. Current Data Pipeline

The current MEPS data foundation is:

```text
                               DATA SOURCES
                                    │
       ┌────────────────────────────┼────────────────────────────┐
       │                            │                            │
       ▼                            ▼                            ▼
  World Bank                  Global Findex                Google Trends
  Core Data                       2025                    Crypto Demand
       │                            │                            │
       │                            │                            │
       ├── Population               ├── Account Ownership       │
       ├── GDP per capita           ├── Digital Payments        └── Crypto Search
       ├── Internet Penetration     └── Smartphone Adoption         Interest
       └── Remittances
       │                            │                            │
       └────────────────────────────┼────────────────────────────┘
                                    ▼
                              Python ingestion
                                    │
                                    ▼
                                Validation
                                    │
                                    ▼
                                  Raw CSV
                                    │
                                    ▼
                                  DuckDB
                                    │
                                    ▼
                              dbt sources
                                    │
                                    ▼
                              dbt staging
                                    │
                                    ▼
                           Feature engineering
                                    │
                                    ▼
                              Normalization
                                    │
                                    ▼
                             Dimension scores
                                    │
                                    ▼
                              MEPS scoring
                                    │
                                    ▼
                            Country ranking
                                    │
                                    ▼
                           Trajectory analysis
                                    │
                                    ▼
                           Market intelligence
                                    │
                                    ▼
                            Growth activation
                                    │
                                    ▼
                                Dashboard
```

---

## 8.1 Current Raw DuckDB Tables

```text
raw.raw_world_bank_indicators
raw.raw_global_findex
raw.raw_world_bank_remittances
raw.raw_google_trends
```

---

## 8.2 Current dbt Staging Models

```text
stg_world_bank
stg_global_findex
stg_world_bank_remittances
stg_google_trends
```

---

## 8.3 Current Data Flow

```text
World Bank
    ↓
Python ingestion
    ↓
Validated raw CSV
    ↓
DuckDB
    ↓
dbt source
    ↓
stg_world_bank

Global Findex
    ↓
Python extraction
    ↓
Validated MEPS CSV
    ↓
DuckDB
    ↓
dbt source
    ↓
stg_global_findex

World Bank Remittances
    ↓
Python ingestion
    ↓
Validated raw CSV
    ↓
DuckDB
    ↓
dbt source
    ↓
stg_world_bank_remittances

Google Trends
    ↓
Python ingestion
    ↓
Validated raw CSV
    ↓
DuckDB
    ↓
dbt source
    ↓
stg_google_trends
```

---

# 9. Reproducibility

## 9.1 World Bank Core Data

Python ingestion:

```text
src/ingestion/world_bank.py
```

DuckDB loader:

```text
src/ingestion/load_world_bank_duckdb.py
```

Raw data:

```text
data/raw/world_bank/world_bank_indicators.csv
```

---

## 9.2 Global Findex

Python ingestion:

```text
src/ingestion/global_findex.py
```

DuckDB loader:

```text
src/ingestion/load_global_findex_duckdb.py
```

Raw workbook:

```text
data/raw/global_findex/global_findex_2025.xlsx
```

Validated extract:

```text
data/raw/global_findex/global_findex_meps.csv
```

---

## 9.3 World Bank Remittances

Python ingestion:

```text
src/ingestion/world_bank_remittances.py
```

DuckDB loader:

```text
src/ingestion/load_world_bank_remittances_duckdb.py
```

Raw validated extract:

```text
data/raw/world_bank/world_bank_remittances.csv
```

dbt source:

```text
dbt/models/sources/src_world_bank_remittances.yml
```

dbt staging:

```text
dbt/models/staging/stg_world_bank_remittances.sql
```

dbt tests:

```text
dbt/tests/test_stg_world_bank_remittances.sql
dbt/tests/test_stg_world_bank_remittances_value_range.sql
```

---

## 9.4 Google Trends

Python ingestion:

```text
src/ingestion/google_trends.py
```

DuckDB loader:

```text
src/ingestion/load_google_trends_duckdb.py
```

Raw validated extract:

```text
data/raw/google_trends/google_trends_crypto.csv
```

dbt source:

```text
dbt/models/sources/src_google_trends.yml
```

dbt staging:

```text
dbt/models/staging/stg_google_trends.sql
```

dbt tests:

```text
dbt/tests/test_stg_google_trends.sql
dbt/tests/test_stg_google_trends_value_range.sql
```

The Google Trends pipeline uses a single worldwide request with country-level extraction to maintain a common normalization framework across the four MEPS markets.

---

# 10. Data Quality Principles

MEPS follows these principles:

1. Raw source files are preserved.
2. Ingestion is reproducible through code.
3. Data contracts are validated before analytical use.
4. Analytical grain is explicitly defined.
5. Duplicate records are explicitly tested.
6. Numeric ranges are validated where applicable.
7. Missing source observations are preserved.
8. Missing values are not silently imputed.
9. Source definitions are documented.
10. Indicator selection is tied to the MEPS business decision.
11. Correlated indicators should not be blindly combined.
12. Transformations should be reproducible.
13. Raw data should not be overwritten by analytical transformations.
14. Cross-country comparability must be explicitly considered.
15. Relative indicators must not be interpreted as absolute measures.
16. MEPS scoring should occur only after the underlying data foundation has passed validation.
17. Every core indicator must have a defined analytical role.
18. Indicators should not be added solely because data is available.

---

# 11. Current Data Foundation Status

| Dataset                          | Status     |
| -------------------------------- | ---------- |
| World Bank core indicators       | 🔒 Locked  |
| Global Findex 2025               | 🔒 Locked  |
| World Bank remittances           | 🔒 Locked  |
| Google Trends crypto demand      | 🔒 Locked  |
| Crypto activity / adoption index | 🔴 Pending |

---

## 11.1 Validated Data Foundation

```text
World Bank
    ├── Population
    ├── GDP per capita
    ├── Internet penetration
    └── Personal remittances received (% of GDP)

Global Findex 2025
    ├── Account ownership
    ├── Digital payment usage
    └── Smartphone adoption

Google Trends
    └── Crypto search interest
```

---

## 11.2 Current Validation Status

```text
World Bank core
    ✓ Data contract
    ✓ Raw CSV
    ✓ DuckDB
    ✓ dbt source
    ✓ dbt staging
    ✓ dbt tests

Global Findex
    ✓ Data contract
    ✓ Raw workbook preserved
    ✓ MEPS extraction
    ✓ DuckDB
    ✓ dbt source
    ✓ dbt staging
    ✓ dbt tests

World Bank remittances
    ✓ Data contract
    ✓ Raw CSV
    ✓ DuckDB
    ✓ dbt source
    ✓ dbt staging
    ✓ dbt tests

Google Trends
    ✓ Methodology validation
    ✓ Common worldwide request
    ✓ Raw CSV
    ✓ DuckDB
    ✓ dbt source
    ✓ dbt staging
    ✓ dbt tests
    ✓ End-to-end dbt build
```

---

# 12. Limitations

The current data foundation has several limitations.

## 12.1 Temporal Coverage

The World Bank datasets provide annual historical observations, while the Global Findex core extract currently uses 2024 observations and Google Trends uses 2025 data.

The different observation periods should be considered when combining indicators in the scoring layer.

---

## 12.2 Missing Values

Some source datasets contain missing observations.

Known current missing values include:

```text
World Bank internet penetration:
GHA — 2025
KEN — 2025
NGA — 2025
ZAF — 2025

World Bank remittances:
KEN — 2025
```

These values remain missing until an explicit analytical treatment is defined.

---

## 12.3 Indicator Interpretation

Individual indicators do not independently predict crypto-market success.

They provide evidence about specific dimensions of market conditions.

MEPS therefore combines multiple dimensions rather than relying on a single indicator.

---

## 12.4 Source Comparability

Different datasets may have different:

* survey periods
* definitions
* methodologies
* frequencies
* update schedules

These differences must be considered during feature engineering and scoring.

---

## 12.5 Google Trends Limitations

Google Trends is a relative search-interest dataset.

The index:

* is not absolute search volume
* is not a count of users
* does not measure transactions
* does not measure exchange volume
* does not measure revenue
* does not directly measure adoption

The current MEPS methodology uses one worldwide request to maintain a common normalization framework across the four target markets.

---

## 12.6 Indicator Correlation

Some indicators may measure related underlying concepts.

For example:

```text
Account ownership
        ↕
Digital payment usage
        ↕
Smartphone adoption
        ↕
Internet penetration
```

These indicators should therefore be evaluated for correlation before final MEPS weighting.

The scoring model should avoid allowing highly correlated indicators to unintentionally dominate the final ranking.

---

## 12.7 MEPS Is a Prioritization Framework

MEPS is designed to prioritize markets under limited expansion resources.

It is not intended to guarantee:

* user growth
* trading volume
* revenue
* adoption
* regulatory approval
* market-entry success

The final score should therefore be interpreted as a **relative prioritization signal**, not a prediction of future performance.

---

# 13. Next Data Engineering Stage

The current validated data foundation supports the next MEPS engineering stages:

```text
Validated raw data
        ↓
dbt staging
        ↓
Data integration
        ↓
Feature engineering
        ↓
Normalization
        ↓
Dimension scores
        ↓
MEPS weighting
        ↓
Sensitivity analysis
        ↓
Country ranking
        ↓
Trajectory analysis
        ↓
Market intelligence
        ↓
Growth activation
        ↓
Dashboard
```

The next major data-engineering task is to add the approved **Crypto Activity** signal.

After the crypto-activity pipeline passes validation, the project will move into the feature-engineering and scoring stages.

The scoring layer will not be implemented until the underlying approved data foundation has passed the required validation checks.

---

# 14. MEPS Analytical Principle

MEPS should answer a business decision, not simply produce a ranking.

The final analytical chain is:

```text
DATA
  ↓
What is happening in each market?
  ↓
SIGNALS
  ↓
What do the indicators tell us?
  ↓
DIMENSIONS
  ↓
How attractive, ready, accessible and active is each market?
  ↓
MEPS SCORE
  ↓
Which markets should receive priority?
  ↓
TRAJECTORY
  ↓
Which markets are improving or changing?
  ↓
MARKET INTELLIGENCE
  ↓
Why does the ranking look this way?
  ↓
GROWTH ACTIVATION
  ↓
What should the company actually do?
```

The purpose of MEPS is therefore to connect **data engineering → analytical modeling → market intelligence → growth execution** in one reproducible framework.
