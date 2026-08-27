\# MEPS Staging Data Model



\## Purpose



The staging layer converts source-specific raw data into clean, standardized datasets.



Staging models should:



\- Rename columns consistently

\- Standardize country codes

\- Cast data types

\- Standardize dates

\- Handle obvious source-level nulls

\- Remove exact duplicates

\- Preserve the original meaning of the source fields



Staging models should NOT contain MEPS scoring logic.



\---



\## stg\_world\_bank



| Column | Type | Description |

|---|---|---|

| country\_code | string | ISO country code |

| country | string | Country name |

| indicator\_code | string | World Bank indicator |

| indicator\_name | string | Indicator description |

| year | integer | Observation year |

| value | numeric | Indicator value |

| extracted\_at | timestamp | Extraction timestamp |



\---



\## stg\_google\_trends



| Column | Type | Description |

|---|---|---|

| country\_code | string | ISO country code |

| country | string | Country name |

| keyword | string | Search term |

| date | date | Observation date |

| search\_interest | numeric | Relative search interest |

| extracted\_at | timestamp | Extraction timestamp |



\---



\## stg\_coingecko



| Column | Type | Description |

|---|---|---|

| asset\_id | string | CoinGecko asset ID |

| symbol | string | Cryptocurrency symbol |

| date | date | Observation date |

| price\_usd | numeric | Asset price |

| market\_cap\_usd | numeric | Market capitalization |

| total\_volume\_usd | numeric | Trading volume |

| extracted\_at | timestamp | Extraction timestamp |



\---



\## stg\_regulatory



| Column | Type | Description |

|---|---|---|

| country\_code | string | ISO country code |

| country | string | Country name |

| assessment | string | Regulatory assessment |

| source | string | Source organization |

| source\_url | string | Evidence URL |

| published\_date | date | Publication date |

| extracted\_at | timestamp | Extraction timestamp |



\---



\## stg\_exchange\_access



| Column | Type | Description |

|---|---|---|

| country\_code | string | ISO country code |

| exchange | string | Exchange name |

| availability | string | Availability assessment |

| payment\_methods | string | Supported payment methods |

| source\_url | string | Evidence URL |

| extracted\_at | timestamp | Extraction timestamp |

