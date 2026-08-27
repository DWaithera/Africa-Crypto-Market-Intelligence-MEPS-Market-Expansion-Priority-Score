\# MEPS Raw Data Model



\## Design Principle



The raw layer stores source data as close to the original format as practical.



Transformations and business logic are applied downstream.



\---



\## 1. World Bank Indicators



\### Table: raw\_world\_bank



| Column | Description |

|---|---|

| country\_code | ISO country code |

| country | Country name |

| indicator\_code | World Bank indicator code |

| indicator\_name | Indicator name |

| year | Observation year |

| value | Indicator value |

| source | Data source |

| extracted\_at | Extraction timestamp |



\---



\## 2. Google Trends



\### Table: raw\_google\_trends



| Column | Description |

|---|---|

| country\_code | ISO country code |

| country | Country name |

| keyword | Search keyword |

| date | Observation date |

| search\_interest | Google Trends relative interest |

| extracted\_at | Extraction timestamp |



\---



\## 3. CoinGecko



\### Table: raw\_coingecko



| Column | Description |

|---|---|

| asset\_id | CoinGecko asset identifier |

| symbol | Cryptocurrency symbol |

| date | Observation date |

| price\_usd | Asset price |

| market\_cap\_usd | Market capitalization |

| total\_volume\_usd | Trading volume |

| extracted\_at | Extraction timestamp |



\---



\## 4. Regulatory Research



\### Table: raw\_regulatory



| Column | Description |

|---|---|

| country\_code | ISO country code |

| country | Country name |

| source | Regulatory source |

| assessment | Regulatory assessment |

| source\_url | Source URL |

| published\_date | Publication date |

| extracted\_at | Extraction timestamp |



\---



\## 5. Exchange Accessibility



\### Table: raw\_exchange\_access



| Column | Description |

|---|---|

| country\_code | ISO country code |

| exchange | Exchange name |

| availability | Availability assessment |

| payment\_methods | Supported payment methods |

| source\_url | Source URL |

| extracted\_at | Extraction timestamp |

