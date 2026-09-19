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
5. Chainalysis crypto activity

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

### Chainalysis

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
Data integration
      ↓
Analytical market mart
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
| Crypto Activity         | Crypto adoption rank                            |

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

* Crypto adoption rank

The Chainalysis 2024 Global Crypto Adoption Index rank is used as the raw source indicator.

Lower rank indicates stronger relative crypto adoption/activity.

The raw rank is preserved through ingestion and staging. Direction handling and normalization occur later during feature engineering.

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

# 8. Chainalysis Crypto Activity

## 8.1 Purpose

Chainalysis provides the Crypto Activity indicator for the MEPS framework.

The **2024 Global Crypto Adoption Index** is used as the current reproducible source extract for the four MEPS target markets.

---

## 8.2 Source

* Source organization: Chainalysis
* Dataset: 2024 Global Crypto Adoption Index
* Reference year: 2024
* Countries: Ghana, Kenya, Nigeria, South Africa

---

## 8.3 Indicator

| Field         | Definition                                     |
| ------------- | ---------------------------------------------- |
| Indicator     | `crypto_adoption_rank`                         |
| Unit          | Global rank                                    |
| Direction     | Lower rank = stronger crypto adoption/activity |
| Year          | 2024                                           |
| Grain         | Country + indicator + year                     |
| Expected rows | 4                                              |

---

## 8.4 Current Values

| Country      | Code | Rank |
| ------------ | ---- | ---: |
| Ghana        | GHA  |   46 |
| Kenya        | KEN  |   28 |
| Nigeria      | NGA  |    2 |
| South Africa | ZAF  |   30 |

---

## 8.5 Methodological Treatment

The raw Chainalysis rank is preserved during ingestion and staging.

No artificial score is created from the rank at the ingestion stage.

The transformation sequence is:

```text
Raw Chainalysis rank
→ staging
→ feature engineering
→ direction handling
→ normalization
→ Crypto Activity score
```

This prevents the raw data layer from mixing source values with analytical transformations.

---

## 8.6 Raw Data

Validated raw extract:

```text
data/raw/chainalysis/chainalysis_crypto_adoption_2024.csv
```

Python validation/ingestion:

```text
src/ingestion/chainalysis.py
```

The ingestion process validates the existing raw source extract without overwriting it.

---

## 8.7 DuckDB Storage

Raw DuckDB table:

```text
raw.raw_chainalysis_crypto_adoption
```

DuckDB loader:

```text
src/ingestion/load_chainalysis_duckdb.py
```

---

## 8.8 dbt Source

dbt source:

```text
chainalysis.raw_chainalysis_crypto_adoption
```

Source definition:

```text
dbt/models/sources/src_chainalysis.yml
```

---

## 8.9 dbt Staging

Staging model:

```text
dbt/models/staging/stg_chainalysis.sql
```

Resulting relation:

```text
main.stg_chainalysis
```

The staging model standardizes the year and rank fields while preserving country, indicator, source, and source-dataset provenance.

The raw adoption rank remains unchanged.

---

## 8.10 dbt Tests

Two singular data-quality tests are applied.

### Analytical grain uniqueness

```text
dbt/tests/test_stg_chainalysis.sql
```

Checks that:

```text
country_code + indicator + year
```

contains no duplicate records.

### Positive rank validation

```text
dbt/tests/test_stg_chainalysis_rank_positive.sql
```

Checks that:

```text
crypto_adoption_rank > 0
```

Current result:

```text
PASS = 2
WARN = 0
ERROR = 0
```

---

## 8.11 MEPS Role

Chainalysis belongs to the:

**Crypto Activity** dimension.

The rank provides a market-level signal of relative crypto adoption activity.

The rank does not directly represent:

* number of crypto users
* transaction volume
* exchange revenue
* profitability
* future growth
* market-entry success

The rank is therefore treated as an input signal rather than a prediction.

---

## 8.12 Methodological Limitation

The current reproducible public extract uses country rank rather than a direct country-level adoption score.

Therefore, the rank should not be interpreted as a cardinal measure of the difference between countries.

For example, a rank of 2 should not be interpreted as indicating twice the adoption activity of a country ranked 4.

Rank transformation and normalization are deliberately deferred to the feature-engineering stage.

---

# 9. Current Data Pipeline

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
       ├── Population               ├── Account Ownership       └── Crypto Search
       ├── GDP per capita           ├── Digital Payments             Interest
       ├── Internet Penetration     └── Smartphone Adoption
       └── Remittances
       │
       └────────────────────────────┬────────────────────────────┐
                                    │                            │
                                    ▼                            ▼
                              Chainalysis
                              Crypto Activity
                                    │
                                    └── Adoption Rank

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
                           Data integration
                                    │
                                    ▼
                         Analytical market mart
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

## 9.1 Current Raw DuckDB Tables

```text
raw.raw_world_bank_indicators
raw.raw_global_findex
raw.raw_world_bank_remittances
raw.raw_google_trends
raw.raw_chainalysis_crypto_adoption
```

---

## 9.2 Current dbt Staging Models

```text
stg_world_bank
stg_global_findex
stg_world_bank_remittances
stg_google_trends
stg_chainalysis
```

---

## 9.3 Integrated Analytical Models

### Integrated Indicator Model

```text
dbt/models/intermediate/int_meps_indicators.sql
```

Resulting relation:

```text
main.int_meps_indicators
```

Purpose:

Standardize the five staging datasets into one long-form analytical indicator layer.

Analytical grain:

```text
country_code + indicator + reference_year
```

The model preserves historical observations and source reference years.

Current size:

```text
236 observations
9 indicators
4 countries
```

The model does not normalize, score, weight, or rank indicators.

---

### Analytical Market Mart

```text
dbt/models/marts/mart_meps_market.sql
```

Resulting relation:

```text
main.mart_meps_market
```

Purpose:

Provide a wide, feature-ready representation of the four MEPS markets.

Grain:

```text
country_code
```

The mart contains one row per MEPS market and selects the latest available valid observation for each indicator.

Each indicator retains its corresponding source reference year in a dedicated `*_year` field.

The mart does not perform MEPS scoring or normalization.

---

## 9.4 Reference-Year Strategy

MEPS uses the **latest available valid observation** for the current-state analytical market mart.

Source reference years are preserved rather than overwritten.

Where the latest observation is missing, the model selects the most recent valid observation rather than silently imputing a value.

For example:

```text
Internet penetration
2025 → missing
2024 → valid
       ↓
mart uses 2024
```

and:

```text
Kenya remittances
2025 → missing
2024 → valid
       ↓
mart uses 2024
```

Missing-value treatment for downstream scoring is handled explicitly during feature engineering rather than through silent imputation.

---

## 9.5 M4 Data Engineering Validation

The complete M4 dbt build passed:

```text
7 models
23 data tests
30 total build operations
0 warnings
0 errors
```

---

# 10. Feature Engineering Layer

## 10.1 Feature Model

The feature-engineering model is:

```text
dbt/models/intermediate/int_meps_features.sql
```

Resulting relation:

```text
main.int_meps_features
```

Purpose:

Transform the current-state MEPS market indicators into comparable analytical features for downstream MEPS scoring.

The model contains one record per MEPS market.

Analytical grain:

```text
country_code
```

The feature model preserves the original indicator values while adding explicit transformation and normalized feature fields.

---

## 10.2 Feature Engineering Process

The M5 process is:

```text
mart_meps_market
        ↓
original indicators
        ↓
methodologically justified transformations
        ↓
direction handling
        ↓
Min-Max normalization
        ↓
0–1 analytical features
        ↓
MEPS scoring engine
```

M5 does not calculate dimension scores or the final MEPS score.

Those calculations belong to Milestone 6.

---

## 10.3 Transformation Rules

### Population

Population has a substantially larger scale than the other MEPS indicators.

The model therefore applies:

```text
log1p(population)
```

This reduces the influence of extreme population differences while preserving the relative ordering of the four MEPS markets.

The transformed value is stored as:

```text
population_transformed
```

It is then Min-Max normalized into:

```text
population_feature
```

### Crypto Adoption Rank

Chainalysis adoption rank has an inverse direction:

```text
Lower rank = stronger crypto activity
Higher rank = weaker crypto activity
```

The rank is therefore direction-reversed before normalization:

```text
max(rank) - rank
```

The transformed value is stored as:

```text
crypto_adoption_rank_transformed
```

The resulting normalized feature is:

```text
crypto_adoption_rank_feature
```

This ensures that stronger crypto adoption receives a higher feature value.

---

## 10.4 Normalization

The remaining indicators are normalized using Min-Max scaling:

```text
normalized_value =
    (value - minimum_value)
    /
    (maximum_value - minimum_value)
```

The resulting features range from:

```text
0 = lowest relative value among the MEPS markets
1 = highest relative value among the MEPS markets
```

The normalization is comparative across the four current MEPS markets.

Therefore, a value of `1.0` means that the market has the highest relative value within the current comparison set. It does not represent an absolute or universal score.

---

## 10.5 Feature Treatment Matrix

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

---

## 10.6 Feature Model Fields

### Original Indicators

| Field                    | Description                                         |
| ------------------------ | --------------------------------------------------- |
| `population`             | Population                                          |
| `gdp_per_capita`         | GDP per capita                                      |
| `remittances_pct_gdp`    | Personal remittances received as % of GDP           |
| `internet_penetration`   | Internet penetration                                |
| `smartphone_adoption`    | Smartphone adoption                                 |
| `account_ownership`      | Account ownership                                   |
| `digital_payment_usage`  | Digital payment usage                               |
| `crypto_search_interest` | Relative Google Trends search interest for `crypto` |
| `crypto_adoption_rank`   | Chainalysis global crypto adoption rank             |

### Transformation Fields

| Field                              | Description         |
| ---------------------------------- | ------------------- |
| `population_transformed`           | `log1p(population)` |
| `crypto_adoption_rank_transformed` | `max(rank) - rank`  |

### Normalized Features

| Field                            | Description                                    |
| -------------------------------- | ---------------------------------------------- |
| `population_feature`             | Normalized population feature                  |
| `gdp_per_capita_feature`         | Normalized GDP per capita feature              |
| `remittances_pct_gdp_feature`    | Normalized remittances feature                 |
| `internet_penetration_feature`   | Normalized internet penetration feature        |
| `smartphone_adoption_feature`    | Normalized smartphone adoption feature         |
| `account_ownership_feature`      | Normalized account ownership feature           |
| `digital_payment_usage_feature`  | Normalized digital payment usage feature       |
| `crypto_search_interest_feature` | Normalized crypto search-interest feature      |
| `crypto_adoption_rank_feature`   | Normalized direction-adjusted Chainalysis rank |

---

## 10.7 Feature Validation

The feature model is validated using three dbt tests:

```text
dbt/tests/test_int_meps_features.sql
dbt/tests/test_int_meps_features_country_grain.sql
dbt/tests/test_int_meps_features_not_null.sql
```

The tests validate:

* normalized features remain within `[0, 1]`;
* one feature record exists per MEPS market;
* normalized features are populated.

Current result:

```text
PASS = 3
WARN = 0
ERROR = 0
```

---

## 10.8 Feature Validation Example

The current engineered features produce the expected relative treatment:

| Market       | Population Feature | Crypto Activity Feature |
| ------------ | -----------------: | ----------------------: |
| Ghana        |             0.0000 |                  0.0000 |
| Kenya        |             0.2588 |                  0.4091 |
| Nigeria      |             1.0000 |                  1.0000 |
| South Africa |             0.3206 |                  0.3636 |

These values demonstrate:

* population was transformed using `log1p` before normalization;
* Nigeria has the highest population feature;
* Ghana has the lowest population feature;
* Chainalysis rank direction was correctly reversed;
* Nigeria's rank of 2 produces the highest Crypto Activity feature;
* Ghana's rank of 46 produces the lowest Crypto Activity feature.

---

## 10.9 Scoring Boundary

The feature model does not calculate:

* dimension scores;
* dimension weights;
* final MEPS score;
* market rankings.

Those calculations belong to the MEPS Scoring Engine in Milestone 6.

---

# 11. Reproducibility

## 11.1 World Bank Core Data

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

## 11.2 Global Findex

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

## 11.3 World Bank Remittances

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

## 11.4 Google Trends

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

## 11.5 Chainalysis

Python validation:

```text
src/ingestion/chainalysis.py
```

DuckDB loader:

```text
src/ingestion/load_chainalysis_duckdb.py
```

Raw validated extract:

```text
data/raw/chainalysis/chainalysis_crypto_adoption_2024.csv
```

dbt source:

```text
dbt/models/sources/src_chainalysis.yml
```

dbt staging:

```text
dbt/models/staging/stg_chainalysis.sql
```

dbt tests:

```text
dbt/tests/test_stg_chainalysis.sql
dbt/tests/test_stg_chainalysis_rank_positive.sql
```

---

## 11.6 Data Engineering Models

Integrated indicator model:

```text
dbt/models/intermediate/int_meps_indicators.sql
```

Analytical market mart:

```text
dbt/models/marts/mart_meps_market.sql
```

---

## 11.7 Feature Engineering

Feature model:

```text
dbt/models/intermediate/int_meps_features.sql
```

Feature tests:

```text
dbt/tests/test_int_meps_features.sql
dbt/tests/test_int_meps_features_country_grain.sql
dbt/tests/test_int_meps_features_not_null.sql
```

---

# 12. Data Quality Principles

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
19. Source rank values should not be converted into artificial scores during ingestion.
20. Direction handling and normalization should occur in the feature-engineering layer.
21. Feature transformations must be explicitly documented.
22. Normalized features must be validated before scoring.
23. Dimension weighting must be separated from feature normalization.
24. The final MEPS score must remain traceable to its underlying indicators.

---

# 13. Current Project Status

| Milestone | Description                  | Status         |
| --------- | ---------------------------- | -------------- |
| 0         | Project Foundation           | 🔒 Locked      |
| 1         | Data Foundation — World Bank | 🔒 Locked      |
| 2         | MEPS Indicator Framework     | 🔒 Locked      |
| 3         | Data Expansion               | 🔒 Locked      |
| 4         | Data Engineering             | 🔒 Locked      |
| 5         | Feature Engineering          | 🟡 In Progress |
| 6         | MEPS Scoring Engine          | 🔴 Pending     |
| 7         | Market Intelligence          | 🔴 Pending     |
| 8         | Growth Activation            | 🔴 Pending     |
| 9         | Dashboard                    | 🔴 Pending     |
| 10        | Validation & QA              | 🔴 Pending     |
| 11        | GitHub / Portfolio           | 🟡 Foundation  |
| 12        | Final Portfolio Story        | 🔴 Pending     |

---

## 13.1 M4 Data Engineering Status

Milestone 4 established:

```text
5 staging models
        ↓
int_meps_indicators
        ↓
mart_meps_market
```

Validation:

```text
7 models
23 data tests
30 total dbt operations
0 warnings
0 errors
```

Milestone 4 is locked in Git.

---

## 13.2 M5 Feature Engineering Status

Milestone 5 currently includes:

```text
mart_meps_market
        ↓
int_meps_features
        ↓
9 normalized features
```

Feature methodology:

```text
Population
→ log1p
→ Min-Max

Positive-direction indicators
→ Min-Max

Crypto adoption rank
→ reverse direction
→ Min-Max
```

Validation:

```text
3 feature tests
3 passed
0 warnings
0 errors
```

M5 documentation and Git lock remain to be completed.

---

# 14. Limitations

The current data foundation and feature-engineering layer have several limitations.

## 14.1 Temporal Coverage

The World Bank datasets provide annual historical observations, while the Global Findex core extract currently uses 2024 data, Google Trends uses 2025 data, and Chainalysis uses the 2024 Global Crypto Adoption Index.

The different observation periods should be considered when interpreting the combined MEPS feature set.

The source reference years are preserved in the analytical market mart.

---

## 14.2 Missing Values

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

The analytical market mart uses the latest available valid observation where the latest observation is missing.

No silent imputation is performed.

---

## 14.3 Indicator Interpretation

Individual indicators do not independently predict crypto-market success.

They provide evidence about specific dimensions of market conditions.

MEPS therefore combines multiple dimensions rather than relying on a single indicator.

---

## 14.4 Source Comparability

Different datasets may have different:

* survey periods
* definitions
* methodologies
* frequencies
* update schedules

These differences must be considered during feature engineering and scoring.

---

## 14.5 Relative Feature Interpretation

The current normalized features are calculated across the four MEPS markets.

Therefore:

```text
0
```

means the lowest relative value among the four markets, while:

```text
1
```

means the highest relative value among the four markets.

The values should not be interpreted as universal measures of market quality or attractiveness.

Adding new countries would change the normalization reference set and could therefore change the feature values.

---

## 14.6 Population Transformation

Population is transformed using `log1p` because its absolute scale is substantially larger than the other MEPS indicators.

The transformation reduces scale dominance but does not eliminate the influence of population size.

The choice should be revisited during later sensitivity analysis.

---

## 14.7 Google Trends Limitations

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

## 14.8 Chainalysis Limitations

The current Chainalysis extract uses **global country rank** rather than a directly observed country-level adoption score.

Therefore:

* rank differences are ordinal rather than cardinal;
* a rank difference does not represent a proportional difference in adoption;
* the raw rank should not be interpreted as transaction volume;
* the raw rank should not be interpreted as user count;
* the raw rank should not be interpreted as revenue;
* the raw rank should not be interpreted as future growth.

The rank is direction-adjusted and normalized only in the feature-engineering layer.

---

## 14.9 Indicator Correlation

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

## 14.10 MEPS Is a Prioritization Framework

MEPS is designed to prioritize markets under limited expansion resources.

It is not intended to guarantee:

* user growth
* trading volume
* revenue
* adoption
* regulatory approval
* market-entry success

The final score should therefore be interpreted as a **relative prioritization signal**, not a prediction of future performance or guaranteed market success.

---

# 15. Next Analytical Stage

Milestones 0–4 have established and validated the project foundation, indicator framework, expanded data foundation, and analytical data-engineering layer.

Milestone 5 has established the feature-engineering methodology and validated the normalized analytical features.

The next major stage is **Milestone 6 — MEPS Scoring Engine**.

M6 will focus on:

* grouping normalized features into the five approved MEPS dimensions;
* defining dimension-level aggregation;
* applying the approved dimension weights;
* calculating the composite MEPS score;
* producing the comparative market ranking;
* documenting the scoring methodology;
* testing the scoring engine;
* performing sensitivity analysis before treating the ranking as decision-ready.

The final score should remain a **relative market-prioritization signal**, not a prediction of future performance or guaranteed market success.

The analytical chain is:

```text
Validated data
        ↓
Data engineering
        ↓
Feature engineering
        ↓
Normalized features
        ↓
Dimension scores
        ↓
Weighted MEPS
        ↓
Market ranking
        ↓
Trajectory analysis
        ↓
Market intelligence
        ↓
Growth activation
```

---

# 16. MEPS Analytical Principle

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


---
Perfect. Now we need to add the **M6 section** to the Data Dictionary.

Since you already have the document open, go to the **very end** of the file and paste this:

````markdown
---

## 17. MEPS Scoring Engine — Milestone 6

### 17.1 Purpose

Milestone 6 transforms the normalized features produced in Milestone 5 into:

- MEPS dimension scores
- Baseline MEPS score
- Market ranking
- Sensitivity analysis

The scoring layer is separated from feature engineering so that transformations, scoring assumptions, and ranking logic remain independently auditable.

### 17.2 MEPS Dimensions

The final MEPS model contains five dimensions:

| Dimension | Features |
|---|---|
| Market Attractiveness | Population, GDP per capita, Remittances (% GDP) |
| Digital Readiness | Internet penetration, Smartphone adoption |
| Financial Accessibility | Account ownership, Digital payment usage |
| Crypto Demand | Crypto search interest |
| Crypto Activity | Crypto adoption rank feature |

### 17.3 Dimension Scoring

Features within multi-feature dimensions are combined using an equal-weight arithmetic mean.

#### Market Attractiveness

```text
(Population Feature
 + GDP per Capita Feature
 + Remittances Feature) / 3
````

#### Digital Readiness

```text
(Internet Penetration Feature
 + Smartphone Adoption Feature) / 2
```

#### Financial Accessibility

```text
(Account Ownership Feature
 + Digital Payment Usage Feature) / 2
```

Crypto Demand and Crypto Activity each contain one feature and therefore use the normalized feature directly.

### 17.4 Baseline Dimension Weights

The baseline MEPS model assigns equal weight to each dimension:

| Dimension               |   Weight |
| ----------------------- | -------: |
| Market Attractiveness   |      20% |
| Digital Readiness       |      20% |
| Financial Accessibility |      20% |
| Crypto Demand           |      20% |
| Crypto Activity         |      20% |
| **Total**               | **100%** |

Equal weighting is used as a transparent baseline because there is not yet sufficient empirical evidence to justify unequal dimension weights.

### 17.5 MEPS Formula

The baseline Market Expansion Priority Score is:

```text
MEPS =
    0.20 × Market Attractiveness
    + 0.20 × Digital Readiness
    + 0.20 × Financial Accessibility
    + 0.20 × Crypto Demand
    + 0.20 × Crypto Activity
```

The resulting MEPS score remains between 0 and 1.

The score represents **relative expansion priority within the current comparison universe**.

### 17.6 Baseline Results

| Rank | Market       | MEPS Score |
| ---: | ------------ | ---------: |
|    1 | Nigeria      |     0.5477 |
|    2 | South Africa |     0.4638 |
|    3 | Kenya        |     0.4367 |
|    4 | Ghana        |     0.3539 |

These results are relative to the four markets currently included in MEPS.

### 17.7 Dimension Profiles

| Market       | Market Attractiveness | Digital Readiness | Financial Accessibility | Crypto Demand | Crypto Activity |
| ------------ | --------------------: | ----------------: | ----------------------: | ------------: | --------------: |
| Nigeria      |                0.6667 |            0.0719 |                  0.0000 |        1.0000 |          1.0000 |
| Ghana        |                0.2088 |            0.7221 |                  0.7066 |        0.1321 |          0.0000 |
| South Africa |                0.4402 |            1.0000 |                  0.5149 |        0.0000 |          0.3636 |
| Kenya        |                0.3287 |            0.3138 |                  1.0000 |        0.1321 |          0.4091 |

### 17.8 Sensitivity Analysis

The scoring engine tests alternative dimension-weight scenarios.

| Scenario      | Market | Digital | Financial | Demand | Activity |
| ------------- | -----: | ------: | --------: | -----: | -------: |
| Baseline      |    20% |     20% |       20% |    20% |      20% |
| Market-led    |    30% |     20% |       20% |    15% |      15% |
| Crypto-led    |    15% |     15% |       15% |    25% |      30% |
| Readiness-led |    15% |     30% |       25% |    15% |      15% |

All scenarios total 100%.

Sensitivity results:

| Scenario      | 1st          | 2nd          | 3rd   | 4th     |
| ------------- | ------------ | ------------ | ----- | ------- |
| Baseline      | Nigeria      | South Africa | Kenya | Ghana   |
| Market-led    | Nigeria      | South Africa | Kenya | Ghana   |
| Crypto-led    | Nigeria      | South Africa | Kenya | Ghana   |
| Readiness-led | South Africa | Kenya        | Ghana | Nigeria |

The readiness-led scenario changes the market ordering, demonstrating that MEPS results depend partly on the strategic priorities represented by the dimension weights.

Under the crypto-led scenario, South Africa and Kenya are very close:

```text
South Africa = 0.402360
Kenya        = 0.402127
Difference   ≈ 0.000234
```

### 17.9 M6 Data Models

| Model                       | Purpose                                                  |
| --------------------------- | -------------------------------------------------------- |
| `int_meps_dimension_scores` | Aggregates normalized features into five MEPS dimensions |
| `mart_meps_score`           | Calculates the baseline composite MEPS score             |
| `int_meps_sensitivity`      | Tests alternative dimension-weight scenarios             |
| `mart_meps_market_ranking`  | Produces the baseline production market ranking          |

Model flow:

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

### 17.10 M6 Validation

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

### 17.11 Interpretation Boundary

MEPS is a **market-prioritization and decision-support framework**.

It is not:

* A prediction of future revenue
* A probability of expansion success
* An estimate of market share
* An investment recommendation
* An absolute measure of crypto adoption

MEPS results depend on:

* Markets included
* Indicator selection
* Source-data quality
* Reference periods
* Feature transformations
* Normalization methodology
* Dimension definitions
* Weighting assumptions

Because Min-Max normalization is relative to the current comparison universe, adding or removing markets can change feature values and therefore MEPS scores.

MEPS should therefore be used alongside commercial, regulatory, operational, and qualitative market intelligence.

### 17.12 M6 Status

**Milestone 6 — MEPS Scoring Engine: TECHNICAL BUILD COMPLETE**

Completed:

* [x] Five dimension scoring
* [x] Baseline MEPS calculation
* [x] Sensitivity analysis
* [x] Production market ranking
* [x] M6 test suite
* [x] Full dbt pipeline validation

--

Absolutely. Paste this **at the very end of the actual `docs/data_dictionary.md`** file. It is the clean M6 section without the accidental conversational text that appeared in the pasted copy.

````markdown
---

Yes — it is longer than necessary for the Data Dictionary. We can make M6 **much tighter** while still documenting the methodology, results, models, sensitivity analysis, and validation.

Use this shorter section instead. **Replace the M6 section with this:**

````markdown
---

# 17. MEPS Scoring Engine — Milestone 6

## 17.1 Purpose

Milestone 6 converts the normalized M5 features into the five MEPS dimension scores, the baseline MEPS score, sensitivity scenarios, and the production market ranking.

## 17.2 Dimension Structure

| Dimension | Features | Aggregation |
|---|---|---|
| Market Attractiveness | Population, GDP per capita, Remittances | Mean |
| Digital Readiness | Internet penetration, Smartphone adoption | Mean |
| Financial Accessibility | Account ownership, Digital payments | Mean |
| Crypto Demand | Crypto search interest | Direct |
| Crypto Activity | Crypto adoption rank feature | Direct |

All multi-feature dimensions use equal-weight arithmetic means.

## 17.3 Baseline MEPS

All five dimensions receive equal 20% weights:

```text
MEPS =
0.20 × Market Attractiveness
+ 0.20 × Digital Readiness
+ 0.20 × Financial Accessibility
+ 0.20 × Crypto Demand
+ 0.20 × Crypto Activity
````

The resulting score ranges from 0–1 and represents relative market priority within the four-market comparison set.

## 17.4 Baseline Results

| Rank | Market       |   MEPS |
| ---: | ------------ | -----: |
|    1 | Nigeria      | 0.5477 |
|    2 | South Africa | 0.4638 |
|    3 | Kenya        | 0.4367 |
|    4 | Ghana        | 0.3539 |

### Dimension Scores

| Market       | Attractiveness | Digital | Financial | Demand | Activity |
| ------------ | -------------: | ------: | --------: | -----: | -------: |
| Nigeria      |         0.6667 |  0.0719 |    0.0000 | 1.0000 |   1.0000 |
| South Africa |         0.4402 |  1.0000 |    0.5149 | 0.0000 |   0.3636 |
| Kenya        |         0.3287 |  0.3138 |    1.0000 | 0.1321 |   0.4091 |
| Ghana        |         0.2088 |  0.7221 |    0.7066 | 0.1321 |   0.0000 |

## 17.5 Sensitivity Analysis

Four weighting scenarios were tested:

| Scenario      | Market | Digital | Financial | Demand | Activity |
| ------------- | -----: | ------: | --------: | -----: | -------: |
| Baseline      |    20% |     20% |       20% |    20% |      20% |
| Market-led    |    30% |     20% |       20% |    15% |      15% |
| Crypto-led    |    15% |     15% |       15% |    25% |      30% |
| Readiness-led |    15% |     30% |       25% |    15% |      15% |

Results:

| Scenario      | Market Ordering                        |
| ------------- | -------------------------------------- |
| Baseline      | Nigeria → South Africa → Kenya → Ghana |
| Market-led    | Nigeria → South Africa → Kenya → Ghana |
| Crypto-led    | Nigeria → South Africa → Kenya → Ghana |
| Readiness-led | South Africa → Kenya → Ghana → Nigeria |

The readiness-led scenario changes the ordering, demonstrating that MEPS results are sensitive to strategic weighting assumptions.

## 17.6 M6 Models

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

| Model                       | Purpose                               |
| --------------------------- | ------------------------------------- |
| `int_meps_dimension_scores` | Calculates five dimension scores      |
| `mart_meps_score`           | Calculates baseline MEPS              |
| `int_meps_sensitivity`      | Tests alternative weighting scenarios |
| `mart_meps_market_ranking`  | Produces production ranking           |

## 17.7 Validation

Full M6 dbt build:

```text
PASS=65
WARN=0
ERROR=0
SKIP=0
NO-OP=0
REUSED=0
```

Validation covers dimension-score ranges, country grain, null checks, MEPS score ranges, sensitivity scenarios, and production ranking integrity.

## 17.8 Interpretation Boundary

MEPS is a **relative market-prioritization framework**, not a prediction of revenue, adoption, market share, or expansion success.

Results depend on the selected markets, indicators, reference periods, transformations, normalization method, dimension definitions, and weights.

Because Min-Max normalization is relative to the comparison universe, adding or removing markets can change the resulting scores.

## 17.9 M6 Status

**Technical build complete.**

The scoring engine, sensitivity analysis, ranking, tests, and documentation are complete. GitHub lock remains pending final repository verification.

```
