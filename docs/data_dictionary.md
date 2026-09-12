# MEPS Data Dictionary

## 1. Purpose

This document defines the data sources, indicators, analytical grain, coverage, validation rules, and reproducibility requirements for the MEPS (Market Expansion Priority Score) framework.

MEPS evaluates African markets for potential crypto/fintech expansion by combining macroeconomic, digital-readiness, financial-accessibility, crypto-demand, and crypto-activity indicators.

The initial MEPS markets are:

* Ghana (GHA)
* Kenya (KEN)
* Nigeria (NGA)
* South Africa (ZAF)

The data foundation currently consists of:

1. World Bank indicators
2. World Bank Global Findex 2025 indicators
3. World Bank remittances indicators

---

# 2. Common Data Standards

## 2.1 Target Countries

| Country      | ISO 3-letter code |
| ------------ | ----------------- |
| Ghana        | GHA               |
| Kenya        | KEN               |
| Nigeria      | NGA               |
| South Africa | ZAF               |

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

## 2.3 Missing Values

Missing source observations are preserved.

MEPS does not silently impute missing values during ingestion.

Any future imputation or estimation must be explicitly documented at the analytical/modeling layer.

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
MEPS scoring
```

---

# 3. World Bank Data

## 3.1 Dataset Overview

The MEPS World Bank dataset provides macroeconomic and digital-readiness indicators for the four initial MEPS markets.

The current World Bank dataset covers annual observations from **2015 to 2025**.

These indicators form part of the foundational dataset used by the MEPS framework.

## 3.2 Data Source

**Source:** World Bank

The data is retrieved programmatically through the World Bank API using the MEPS Python ingestion pipeline.

Raw source file:

```text
data/raw/world_bank/world_bank_indicators.csv
```

## 3.3 Source Indicators

| Indicator Code | MEPS Name            | Description                          | Unit            |
| -------------- | -------------------- | ------------------------------------ | --------------- |
| SP.POP.TOTL    | population           | Total population                     | Persons         |
| NY.GDP.PCAP.CD | gdp_per_capita       | GDP per capita in current US dollars | Current US$     |
| IT.NET.USER.ZS | internet_penetration | Individuals using the internet       | % of population |

## 3.4 Dataset Grain

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

## 3.5 Coverage

| Attribute        | Value                               |
| ---------------- | ----------------------------------- |
| Countries        | Ghana, Kenya, Nigeria, South Africa |
| Country codes    | GHA, KEN, NGA, ZAF                  |
| Indicators       | 3                                   |
| Years            | 2015–2025                           |
| Expected records | 132                                 |

## 3.6 World Bank Validation

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

Therefore:

```text
Total records: 132
Missing values: 4
Duplicate grain records: 0
```

## 3.7 World Bank DuckDB

Raw DuckDB table:

```text
raw.raw_world_bank_indicators
```

The table is populated by:

```text
src/ingestion/load_world_bank_duckdb.py
```

## 3.8 World Bank dbt

dbt source:

```text
world_bank.raw_world_bank_indicators
```

dbt staging model:

```text
stg_world_bank
```

The staging layer standardizes the raw source for downstream MEPS transformations.

A singular dbt test validates uniqueness of:

```text
country_code
indicator_code
year
```

---

# 4. Global Findex 2025

## 4.1 Dataset Overview

The Global Findex Database 2025 provides country-level indicators covering financial inclusion, payments, mobile phone ownership, internet use, digital safety, saving, borrowing, and related topics.

The 2025 edition reports country-level indicators for survey years including **2024, 2021, 2017, 2014, and 2011**. The 2025 edition is based on nationally representative surveys conducted during 2024.

For the current MEPS core scoring dataset, the **2024 observations** are used.

## 4.2 Data Source

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

## 4.3 Selected Findex Indicators

| Findex Series | MEPS Name             | Description                                                                | Unit             |
| ------------- | --------------------- | -------------------------------------------------------------------------- | ---------------- |
| account.t.d   | account_ownership     | Adults with an account at a financial institution or mobile money provider | Proportion (0–1) |
| g20.any       | digital_payment_usage | Adults who made or received a digital payment                              | Proportion (0–1) |
| con9a         | smartphone_adoption   | Adults whose main mobile phone is a smartphone                             | Proportion (0–1) |

The Global Findex database provides country-level indicators across financial inclusion and digital connectivity topics.

## 4.4 Indicator Selection Rationale

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

## 4.5 Dataset Grain

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

## 4.6 Coverage

| Attribute               | Value                               |
| ----------------------- | ----------------------------------- |
| Countries               | Ghana, Kenya, Nigeria, South Africa |
| Country codes           | GHA, KEN, NGA, ZAF                  |
| Core year               | 2024                                |
| Indicators              | 3                                   |
| Expected records        | 12                                  |
| Missing core values     | 0                                   |
| Duplicate grain records | 0                                   |

## 4.7 Findex Extraction Rules

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

## 4.8 Findex Validation

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

## 4.9 Findex Values

The validated 2024 observations are:

| Country      | Account Ownership | Digital Payment Usage | Smartphone Adoption |
| ------------ | ----------------: | --------------------: | ------------------: |
| Ghana        |          0.812430 |              0.803643 |            0.535256 |
| Kenya        |          0.901199 |              0.892835 |            0.549135 |
| Nigeria      |          0.632614 |              0.544771 |            0.336764 |
| South Africa |          0.811260 |              0.671722 |            0.675104 |

Values are retained as proportions between 0 and 1.

Conversion to percentages should occur only in presentation or dashboard layers.

## 4.10 Findex DuckDB

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

## 4.11 Findex dbt

dbt source:

```text
global_findex.raw_global_findex
```

dbt staging model:

```text
stg_global_findex
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

## 4.12 Findex dbt Tests

The following tests are implemented:

### Analytical grain uniqueness

```text
tests/test_stg_global_findex.sql
```

Validates uniqueness of:

```text
country_code
indicator
year
```

### Value range

```text
tests/test_stg_global_findex_value_range.sql
```

Validates that non-null indicator values remain within:

```text
0 ≤ value ≤ 1
```

Both tests currently pass.

---

# 5. World Bank Remittances

## 5.1 Dataset Overview

The MEPS remittances dataset contains annual personal remittances received as a percentage of GDP for the four initial MEPS markets:

* Ghana (GHA)
* Kenya (KEN)
* Nigeria (NGA)
* South Africa (ZAF)

The indicator is sourced from the World Bank World Development Indicators (WDI).

## 5.2 Source Indicator

| Field                     | Definition                                                                            |
| ------------------------- | ------------------------------------------------------------------------------------- |
| World Bank indicator code | `BX.TRF.PWKR.DT.GD.ZS`                                                                |
| MEPS indicator name       | `remittances_pct_gdp`                                                                 |
| Indicator                 | Personal remittances, received (% of GDP)                                             |
| Source                    | World Bank World Development Indicators                                               |
| Frequency                 | Annual                                                                                |
| Unit                      | Percentage of GDP                                                                     |
| Direction                 | Higher values indicate greater remittance inflows relative to the size of the economy |

## 5.3 Coverage

| Dimension             | Coverage           |
| --------------------- | ------------------ |
| Countries             | GHA, KEN, NGA, ZAF |
| Years                 | 2015–2025          |
| Expected observations | 44                 |
| Actual observations   | 44                 |

The historical series is retained because remittances may contribute to future MEPS trajectory analysis in addition to the current market-attractiveness assessment.

## 5.4 Dataset Grain

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

## 5.5 Raw Data

The validated raw extract is stored at:

```text
data/raw/world_bank/world_bank_remittances.csv
```

The raw extract is produced by:

```text
src/ingestion/world_bank_remittances.py
```

The ingestion pipeline retrieves the World Bank API response, filters the approved countries and years, standardizes the indicator name, validates the data contract, and writes the validated CSV.

## 5.6 Data Validation

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

## 5.7 DuckDB Storage

The validated CSV is loaded into DuckDB using:

```text
src/ingestion/load_world_bank_remittances_duckdb.py
```

Raw DuckDB table:

```text
raw.raw_world_bank_remittances
```

## 5.8 dbt Source

The raw DuckDB table is registered as a dbt source:

```text
world_bank_remittances.raw_world_bank_remittances
```

Source definition:

```text
dbt/models/sources/src_world_bank_remittances.yml
```

## 5.9 dbt Staging

The staging model is:

```text
dbt/models/staging/stg_world_bank_remittances.sql
```

The staging model standardizes the `year` and `value` fields while preserving the source indicator, country, and provenance fields.

Resulting relation:

```text
main.stg_world_bank_remittances
```

## 5.10 dbt Tests

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

## 5.11 MEPS Role

Remittances belong to the:

**Market Attractiveness** dimension.

The indicator provides a measure of the relative importance of remittance inflows within each economy.

It should not be interpreted independently as evidence that a country will have higher crypto adoption.

Instead, it contributes one component of the broader market-attractiveness assessment.

## 5.12 Methodological Considerations

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

# 6. Current Data Pipeline

The current MEPS data foundation is:

```text
                           DATA SOURCES
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
         World Bank       Global Findex     World Bank
         Core Data            2025          Remittances
              │                 │                 │
              ▼                 ▼                 ▼
      Python ingestion   Python ingestion   Python ingestion
              │                 │                 │
              ▼                 ▼                 ▼
          Raw CSV            Raw CSV            Raw CSV
              │                 │                 │
              └─────────────────┼─────────────────┘
                                ▼
                              DuckDB
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
         Raw World Bank    Raw Global Findex   Raw Remittances
              │                 │                 │
              └─────────────────┼─────────────────┘
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
                          MEPS scoring
```

Current raw DuckDB tables:

```text
raw.raw_world_bank_indicators
raw.raw_global_findex
raw.raw_world_bank_remittances
```

Current dbt staging models:

```text
stg_world_bank
stg_global_findex
stg_world_bank_remittances
```

---

# 7. Reproducibility

## 7.1 World Bank Core Data

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

## 7.2 Global Findex

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

## 7.3 World Bank Remittances

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

# 8. Data Quality Principles

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
14. MEPS scoring should occur only after the underlying data foundation has passed validation.

---

# 9. Current Data Foundation Status

| Dataset                    | Status    |
| -------------------------- | --------- |
| World Bank core indicators | 🔒 Locked |
| Global Findex 2025         | 🔒 Locked |
| World Bank remittances     | 🔒 Locked |

Current validated data foundation:

```text
World Bank
    ├── Population
    ├── GDP per capita
    └── Internet penetration

Global Findex 2025
    ├── Account ownership
    ├── Digital payment usage
    └── Smartphone adoption

World Bank Remittances
    └── Personal remittances received (% of GDP)
```

---

# 10. Limitations

The current data foundation has several limitations.

## 10.1 Temporal Coverage

The World Bank datasets provide annual historical observations, while the Global Findex core extract currently uses 2024 observations.

The different observation periods should be considered when combining indicators in the scoring layer.

## 10.2 Missing Values

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

## 10.3 Indicator Interpretation

Individual indicators do not independently predict crypto-market success.

They provide evidence about specific dimensions of market conditions.

MEPS therefore combines multiple dimensions rather than relying on a single indicator.

## 10.4 Source Comparability

Different datasets may have different survey periods, definitions, methodologies, and update frequencies.

These differences must be considered during feature engineering and scoring.

## 10.5 MEPS Is a Prioritization Framework

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

# 11. Next Data Engineering Stage

The current data foundation supports the next MEPS engineering stages:

```text
Validated raw data
        ↓
dbt staging
        ↓
Feature engineering
        ↓
Normalization
        ↓
Dimension scores
        ↓
MEPS weighting
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

The next major data-engineering work will expand the remaining approved MEPS indicators, including crypto-demand and crypto-activity signals, before the feature-engineering and scoring layers are implemented.
