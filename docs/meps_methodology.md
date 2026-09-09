# MEPS Measurement Methodology

## 1. Purpose

This document defines how MEPS converts raw market indicators into comparable scores and an overall market-priority ranking.

MEPS is a relative market-prioritization framework. It does not predict revenue, adoption, or commercial success.

---

## 2. Analytical Structure

The MEPS scoring pipeline is:

Raw indicator
→ validation
→ missing-value handling
→ normalization
→ indicator score
→ dimension score
→ weighted MEPS score
→ country ranking

Historical data is retained separately for trajectory analysis.

---

## 3. Normalization

Because indicators are measured using different units, all indicators are converted to a common 0–100 scale.

For positive indicators, where a higher value represents stronger market opportunity:

Score = ((x - minimum) / (maximum - minimum)) × 100

The country with the lowest observed value receives a score of 0 and the country with the highest observed value receives a score of 100.

The remaining countries receive proportional scores between 0 and 100.

All current core indicators are expected to have a positive direction unless explicitly documented otherwise.

---

## 4. Indicator Direction

Each indicator must have a documented direction of impact.

Positive indicator:
Higher value → higher MEPS contribution.

Negative indicator:
Higher value → lower MEPS contribution.

If a negative-direction indicator is introduced, the normalization formula will be reversed and documented in the indicator framework.

---

## 5. Dimension Scores

Where a dimension contains multiple validated indicators, the dimension score is calculated as the arithmetic mean of the indicator scores.

For example:

Digital Readiness Score
= (Internet Penetration Score + Smartphone Adoption Score) / 2

Indicators will only be combined after checking for conceptual overlap and data comparability.

---

## 6. Dimension Weights

The initial MEPS model assigns equal weights to the five core dimensions:

| Dimension | Weight |
|---|---:|
| Market Attractiveness | 20% |
| Digital Readiness | 20% |
| Financial Accessibility | 20% |
| Crypto Demand | 20% |
| Crypto Activity | 20% |
| Total | 100% |

Equal weighting is used as the baseline because there is currently no sufficiently defensible empirical basis for assigning substantially different weights.

Alternative weighting scenarios will be tested through sensitivity analysis.

---

## 7. Overall MEPS Score

The overall MEPS score is calculated as:

MEPS =
(Market Attractiveness × 0.20)
+ (Digital Readiness × 0.20)
+ (Financial Accessibility × 0.20)
+ (Crypto Demand × 0.20)
+ (Crypto Activity × 0.20)

The resulting score ranges from 0 to 100.

A higher score indicates stronger relative market priority under the selected indicators, weights, and assumptions.

---

## 8. Missing Values

Missing observations will not be automatically imputed.

For cross-country MEPS comparisons, the preferred approach is to use the latest common year with sufficiently complete comparable data across all four initial markets.

Where an indicator has missing observations:

- the raw missing value is preserved;
- no unsupported value is invented;
- the impact on the dimension score is documented;
- substantial missingness is treated as a confidence limitation.

Historical data remains available for trajectory analysis.

---

## 9. Comparison Period

The core MEPS ranking will use a common comparable observation period/year rather than mixing different years unnecessarily.

The selected comparison year will be determined after indicator-source validation.

Historical observations from 2015 onward will be retained where available to support trajectory analysis.

---

## 10. Trajectory Analysis

Growth Potential is not included as a sixth core MEPS dimension.

Instead, changes over time are analyzed separately.

Trajectory analysis may examine:

- growth in digital readiness;
- changes in financial accessibility;
- changes in crypto demand;
- changes in crypto activity;
- changes in broader market conditions.

This prevents the same underlying evidence from being counted both in a current-state dimension and in a separate Growth Potential score.

---

## 11. Sensitivity Analysis

The final MEPS ranking will be tested against reasonable alternative assumptions.

Sensitivity analysis will examine:

- alternative dimension weights;
- potentially different indicator weights where applicable;
- effects of removing or changing individual indicators;
- effects of missing-data treatment where relevant.

The purpose is to determine whether the market ranking is robust or highly dependent on particular assumptions.

A ranking that changes substantially under reasonable alternatives will be presented with lower confidence.

---

## 12. Interpretation

MEPS is a decision-support framework.

A high MEPS score means:

> The market demonstrates stronger relative expansion characteristics under the selected methodology.

It does not mean:

- guaranteed commercial success;
- guaranteed crypto adoption;
- guaranteed revenue;
- regulatory suitability;
- competitive superiority;
- operational feasibility.

MEPS should therefore be followed by market intelligence and country-level commercial, regulatory, competitive, and operational assessment.

---

## 13. Reproducibility

The scoring methodology will be implemented programmatically so that the ranking can be reproduced when source data is updated.

The pipeline will preserve:

- raw source data;
- transformation logic;
- indicator definitions;
- normalization methodology;
- weights;
- scoring outputs;
- validation results.

---

## 14. Methodology Status

Status: Draft — Milestone 2.4

The methodology will be locked after indicator-source validation and completion of the MEPS indicator framework.