# MEPS Data Dictionary — World Bank

## 1. Dataset Overview

The MEPS World Bank dataset provides macroeconomic and digital-readiness indicators for four initial African markets:

- Ghana (GHA)
- Kenya (KEN)
- Nigeria (NGA)
- South Africa (ZAF)

The dataset covers annual observations from 2015 to 2025.

The da ta forms part of the foundational dataset used by the MEPS (Market Expansion Priority Score) framework to evaluate African markets for potential crypto/fintech expansion.

---

## 2. Data Source

**Source:** World Bank

The data is retrieved programmatically through the World Bank API using the MEPS Python ingestion pipeline.

**Source indicators:**

| Indicator Code | MEPS Name | Description |
|---|---|---|
| SP.POP.TOTL | population | Total population |
| NY.GDP.PCAP.CD | gdp_per_capita | GDP per capita in current US dollars |
| IT.NET.USER.ZS | internet_penetration | Individuals using the internet (% of population) |

---

## 3. Dataset Grain

The analytical grain is:

**One country × one indicator × one year**

The combination of:

```text
country_code
indicator_code
year