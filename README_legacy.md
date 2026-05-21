# Digital Health Maturity Index (DHMI) – WHO European Region

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![R version](https://img.shields.io/badge/R-%3E%3D4.3-blue)](https://cran.r-project.org/)
[![Data: WHO 2023](https://img.shields.io/badge/Data-WHO%202023-green)](https://www.who.int/europe/publications/i/item/WHO-EURO-2023-8150-48388-71429)

Replication code and analysis pipeline for:

> Curiello S., Iannuzzi E., Nigro C. (2026). *"Benchmarking Digital Health
> Governance: A Composite Maturity Index for Cross-Country Policy Comparison
> in the WHO European Region."* **Benchmarking: An International Journal**
> (Emerald, Q1). *Under review.*

---

## Overview

This repository contains the complete R pipeline for constructing, validating,
and analysing the **Digital Health Maturity Index (DHMI)** — a composite
benchmarking instrument that quantifies national digital health governance
maturity across the **53 Member States of the WHO European Region**.

The DHMI is built on 74 standardised WHO policy indicators spanning 10 domains,
following the **OECD/JRC composite indicator methodology** (Nardo et al., 2008).

---

## Repository Structure

```
DHMI-WHO-Europe/
│
├── DHMI_analysis.R                   # Main analysis script (this file)
│
├── data/                             # Input data (not included – see below)
│   ├── DH Data (table).csv
│   └── desi_aehr-total-egov_score-desi_2023-facts.xlsx
│
├── outputs/                          # Generated on script execution
│   ├── Output_DHMI_Country_Scores.xlsx
│   ├── Output_Domain_Adoption_Rates.xlsx
│   ├── Output_LASSO_Results.xlsx
│   └── Output_MannWhitney_Results.xlsx
│
├── figures/                          # Generated on script execution
│   ├── Figure_DHMI_Clusters.png
│   ├── Figure_Missing_Data_Heatmap.png
│   ├── Figure_DHMI_vs_DESI_Validation.png
│   ├── Figure_Sensitivity_Analysis.png
│   ├── Figure_Correlation_Matrix_Full.png
│   ├── Figure_Correlation_Matrix_Selected.png
│   ├── Figure1_LASSO_Final.png
│   └── Figure2_MannWhitney_Final.png
│
├── README.md
└── LICENSE
```

---

## Data Sources

| Dataset | Source | Access |
|---|---|---|
| WHO Digital Health Survey (2023) | WHO Regional Office for Europe | [Link](https://www.who.int/europe/publications/i/item/WHO-EURO-2023-8150-48388-71429) |
| DESI 2023 – e-Health Records | European Commission | [Link](https://digital-strategy.ec.europa.eu/en/policies/desi) |

> **Note:** The raw WHO data file (`DH Data (table).csv`) must be obtained
> directly from the WHO Regional Office for Europe. It is not redistributed
> in this repository due to licence constraints.

---

## Methods

### DHMI Construction

The DHMI follows the **OECD/JRC composite indicator framework** (Nardo et al.,
2008; Saltelli et al., 2004):

1. **Indicator selection**: 44 of 74 WHO policy indicators retained across
   10 thematic domains, after quality screening (variance > 0, missingness < 50%).
2. **Scoring**: WHO categorical responses recoded to a −4 to +3 scale.
3. **Domain adoption rates**: proportion of indicators with non-negative scores
   per domain per country (0–100%).
4. **Aggregation**: arithmetic mean of 10 domain-level adoption rates
   (equal weighting, justified and tested via sensitivity analysis).
5. **Rescaling**: final DHMI rescaled to 0–100 for cross-country comparability.

### Analytical Pipeline

| Step | Method | Output |
|---|---|---|
| Clustering | k-means (k = 3, elbow criterion) | 3-cluster typology |
| External validation | Spearman ρ vs DESI 2023 | Convergent validity |
| Sensitivity analysis | 1,000 weight-perturbation simulations | Rank stability |
| Missing data | Country/indicator missingness; restricted-sample re-run | Robustness check |
| Correlation analysis | Spearman with FDR correction (Benjamini-Hochberg) | Indicator interdependencies |
| LASSO regression | 10-fold CV; LOO-CV R² | Key predictors of DHMI |
| Cluster discrimination | Mann-Whitney U with FDR correction | High vs Low maturity indicators |

---

## Reproducibility

All analyses use fixed random seeds (`set.seed(123)` for clustering,
`set.seed(42)` for all other stochastic procedures).

**R version**: ≥ 4.3.0  
**Key packages**: `glmnet`, `ggcorrplot`, `ggrepel`, `factoextra`, `sf`,
`rnaturalearth`, `FSA`, `openxlsx`

To install all dependencies, run the **Section 0** block at the top of
`DHMI_analysis.R`. All other sections can then be run sequentially.

---

## Results Summary

| Cluster | N Countries | DHMI Range | Representative Countries |
|---|---|---|---|
| High Maturity | 11 | 70–100 | Nordic, Western European |
| Medium Maturity | 25 | 35–69 | Central, Southern European |
| Low Maturity | 16 | 0–34 | Southeastern, Post-Soviet |

**Convergent validity**: Spearman ρ = 0.xx vs DESI 2023 (p < 0.001, n = 27 EU countries)  
**Sensitivity**: weight-perturbation ρ = 0.928 (1,000 simulations, uniform simplex)  
**LASSO**: 27 of 43 indicators selected; R² in-sample = 0.847; R² LOO-CV = 0.452  
**Mann-Whitney**: 21 indicators significantly discriminating High from Low Maturity (FDR corrected)  
**Cross-method convergence**: 7 indicators significant in both LASSO and Mann-Whitney

---

## Citation

If you use this code or the DHMI instrument, please cite:

```bibtex
@article{Curiello2026DHMI,
  author  = {Curiello, Simona and Iannuzzi, Enrica and Nigro, Claudio},
  title   = {Benchmarking Digital Health Governance: A Composite Maturity
             Index for Cross-Country Policy Comparison in the {WHO} European Region},
  journal = {Benchmarking: An International Journal},
  year    = {2026},
  note    = {Under review}
}
```

---

## References

- Nardo, M., Saisana, M., Saltelli, A., Tarantola, S., Hoffman, A., &
  Giovannini, E. (2008). *Handbook on constructing composite indicators*.
  OECD Publishing. https://doi.org/10.1787/9789264043466-en
- Saltelli, A., Tarantola, S., Campolongo, F., & Ratto, M. (2004).
  *Sensitivity analysis in practice*. Wiley.
- Kuc-Czarnecka, M., Lo Piano, S., & Saltelli, A. (2020). Quantitative
  storytelling in the making of a composite indicator. *Social Indicators
  Research*, 149, 775–802.
- WHO Regional Office for Europe (2023). *The ongoing journey to commitment
  and transformation: Digital health in the WHO European Region*. WHO.

---

## License

This code is released under the [MIT License](LICENSE).  
The WHO data are subject to the WHO terms of use.

---

## Contact

**Simona Curiello** – Research Fellow, Department of Medical and Surgical
Sciences, University of Foggia  
**Enrica Iannuzzi** – Associate Professor of Management, University of Foggia  
**Claudio Nigro** – Full Professor of Management, University of Foggia

For questions about this repository: please open a GitHub Issue.
