\# MEPS Data Quality



\## World Bank — Initial Ingestion



\### Coverage



Analysis window: 2015–2025



Countries:



\- Ghana

\- Kenya

\- Nigeria

\- South Africa



Indicators:



\- Population

\- GDP per capita

\- Internet penetration



\### Results



| Indicator | Expected Records | Available Records | Missing |

|---|---:|---:|---:|

| Population | 44 | 44 | 0 |

| GDP per capita | 44 | 44 | 0 |

| Internet penetration | 44 | 40 | 4 |



\### Missing Observations



Internet penetration is missing for 2025 for all four countries.



This is treated as source-level missingness rather than an error.



\### MEPS Handling Rule



For each country-indicator pair, MEPS will use the latest available observation within the 2015–2025 analysis window.



Missing observations will not be artificially interpolated or fabricated.



\### Validation Checks



The ingestion pipeline verifies:



\- Four target countries are present.

\- Three expected indicators are present.

\- Data falls within the 2015–2025 analysis window.

\- Source is identified as World Bank.

\- Missing observations are explicitly measurable.

\- Raw data is preserved before transformation.

