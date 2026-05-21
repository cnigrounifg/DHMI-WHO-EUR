# Digital Health Maturity Index (DHMI) — WHO European Region

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Data: CC BY 4.0](https://img.shields.io/badge/Data-CC%20BY%204.0-blue.svg)](LICENSE)
[![R version](https://img.shields.io/badge/R-%E2%89%A54.3-blue)](https://cran.r-project.org/)
[![Zenodo DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.XXXXXXX-orange.svg)](https://doi.org/10.5281/zenodo.XXXXXXX)

Reproducibility package for the paper:

> Curiello, S., Iannuzzi, E., & Nigro, C. (2026). Benchmarking digital health governance in the WHO European Region: A composite maturity index for cross-country policy comparison. *Benchmarking: An International Journal* (under review).

---

## Overview

This repository contains the complete R pipeline for constructing, validating, and analysing the **Digital Health Maturity Index (DHMI)** — a composite benchmarking instrument that quantifies national digital health governance maturity across the **53 Member States of the WHO European Region**, drawing on 74 standardised policy indicators across 10 domains from the 2023 WHO Regional Office for Europe digital health survey. The pipeline implements:

- Equal-weight composite construction with OECD/JRC methodology (Nardo et al., 2008).
- A four-procedure robustness protocol: weight-perturbation sensitivity (1,000 simulations), PCA-derived alternative weighting, missing-data sensitivity, and convergent validity testing against DESI eHealth (2023) and the WHO UHC Service Coverage Index (2021).
- k-means cluster analysis (k = 3, validated by silhouette and Dunn-index).
- Spearman correlation analysis with Benjamini-Hochberg FDR correction across 903 indicator pairs.
- LASSO regression with 10-fold and leave-one-out cross-validation.
- Mann-Whitney U tests with FDR correction and effect-size quantification.

---

## Repository structure

```
DHMI-WHO-EUR/
├── README.md                          (this file)
├── README_legacy.md                   (legacy monolithic-pipeline README, to be merged in)
├── LICENSE                            (MIT for code; CC BY 4.0 for data)
├── CITATION.cff                       (machine-readable citation metadata)
├── CHANGELOG.md                       (version history)
├── .zenodo.json                       (Zenodo deposit metadata)
├── renv.lock                          (pinned R package versions)
│
├── data/
│   ├── raw/                           (WHO 2023 indicator data — see Data Access below)
│   ├── processed/                     (DHMI scores, cluster assignments, all intermediate CSVs)
│   └── external_validators/           (DESI 2023, WHO UHC 2023)
│
├── code/
│   ├── 00_setup.R                     (packages + global constants; sourced by all)
│   ├── 01_data_preparation.R          (recode WHO raw, restrict to Europe)
│   ├── 02_dhmi_construction.R         (domain scores, DHMI_equal, DHMI_scaled)
│   ├── 03_robustness_protocol.R       (weight perturbation, missing-data sensitivity)
│   ├── 04_cluster_analysis.R          (k-means, silhouette, cluster labels)
│   ├── 05_spearman_fdr.R              (Spearman matrix + BH-FDR correction)
│   ├── 06_lasso_regression.R          (LASSO with 10-fold + LOO-CV)
│   ├── 07_mann_whitney_fdr.R          (MW U tests + cross-method convergence)
│   ├── 08_external_validity.R         (DESI + WHO UHC convergent validity)
│   ├── 99_figures_tables.R            (regenerate all figures + Excel tables)
│   ├── run_all.R                      (master orchestrator)
│   └── DHMI_analysis_legacy.R         (original monolithic pipeline, retained as reference)
│
├── outputs/
│   ├── figures/                       (Figures 1–4 + Appendix A1, A2; PNG 300 dpi)
│   ├── tables/                        (Tables 1–4 + auxiliary tables; XLSX)
│   └── appendix/                      (Figures A1, A2)
│
├── companion_paper_bridge/
│   └── README_bridge.md               (documents the BIJ ↔ SRBS data bridge)
│
├── docs/
│   ├── faq.md                         (anticipated reviewer questions)
│   ├── methodology_notes.md           (extended methodology rationale)
│   └── indicator_coding_decisions.md  (per-indicator recoding decisions)
│
└── supplementary/
    ├── consensus_queries_log.md       (audit trail of literature review queries)
    └── action_planning.md             (audit copy of the editorial Action Planning)
```

---

## Quick start

```bash
# 1. Clone the repository
git clone <repo-url>
cd DHMI-WHO-EUR

# 2. Restore the pinned R environment
Rscript -e 'renv::restore()'

# 3. Populate data/raw/ with the WHO 2023 survey file (see Data Access below)

# 4. Reproduce every figure, table and statistic of the paper
Rscript code/run_all.R
```

The pipeline is split into **nine modular scripts plus `run_all.R`**, each documented with its inputs, outputs, and dependencies. Running `Rscript code/run_all.R` from the project root reproduces every figure, table and statistic of the BIJ paper from the raw WHO 2023 data in under 15 seconds. The legacy monolithic file `code/DHMI_analysis_legacy.R` is retained for reference.

---

## Data access

The raw WHO 2023 digital health survey data (`data/raw/DH Data (table).csv`) are redistributed under the licensing terms of the World Health Organization (CC BY 4.0). The file is included in the Zenodo deposit. External validators used in script 08 are:

- **DESI 2023** (`data/external_validators/desi_aehr-total-egov_score-desi_2023-facts.csv`) — European Commission Digital Decade DESI, Access to eHealth Records sub-index.
- **WHO UHC Service Coverage Index** (`data/external_validators/01_WHO_UHC.csv`) — WHO Global Health Observatory, SDG indicator 3.8.1, latest available year per country (2023).

---

## Citation

If you use this software or data product, please cite both the paper and the Zenodo deposit:

> Curiello, S., Iannuzzi, E., & Nigro, C. (2026). Benchmarking digital health governance in the WHO European Region: A composite maturity index for cross-country policy comparison. *Benchmarking: An International Journal* (under review).

> Curiello, S., Iannuzzi, E., & Nigro, C. (2026). *DHMI-WHO-EUR: Reproducibility package for the Digital Health Maturity Index* [Data set and code]. Zenodo. https://doi.org/10.5281/zenodo.XXXXXXX

A machine-readable citation is provided in `CITATION.cff`.

---

## Companion paper

The DHMI dataset is also used in a companion paper that re-operationalises selected indicators as latent constructs of a complex adaptive systems model:

> Curiello, S., Iannuzzi, E., & Nigro, C. (forthcoming). Digital health governance as a complex adaptive system: systemic interdependencies, institutional feedback mechanisms and health system performance in the WHO European Region. *Systems Research and Behavioural Science*.

The empirical bridge between the two papers is documented in `companion_paper_bridge/README_bridge.md`.

---

## Licensing

Code is released under the MIT License; author-produced data products under CC BY 4.0; raw WHO survey data are redistributed under the licensing terms of the World Health Organization. See `LICENSE` for the full triple-licence statement.

---

## Repository status

| Component | Status |
|---|---|
| Repository skeleton | ✅ |
| Dual licence (MIT + CC BY 4.0) | ✅ |
| Citation metadata (`CITATION.cff`, `.zenodo.json`) | ✅ |
| Companion-paper bridge (`README_bridge.md`) | ✅ |
| FAQ for anticipated reviewer questions (`docs/faq.md`) | ✅ |
| Audit trail (`supplementary/`) | ✅ |
| Legacy monolithic R pipeline | ✅ |
| Modular R scripts (00 setup + 01–08 + 99) | ✅ |
| `run_all.R` master script | ✅ |
| `renv.lock` for package pinning | ✅ |
| Raw data files in `data/raw/` | ✅ |
| Processed data in `data/processed/` | ✅ |
| External validators in `data/external_validators/` | ✅ |
| Output figures (`outputs/figures/`) | ✅ |
| Output tables (`outputs/tables/`) | ✅ |
| Extended methodology notes (`docs/methodology_notes.md`) | ⏳ TODO |
| Indicator coding decisions (`docs/indicator_coding_decisions.md`) | ⏳ TODO |
| Real Zenodo DOI (replace `XXXXXXX` placeholders) | ⏳ upon first deposit |
| Real author ORCIDs (replace placeholders in `CITATION.cff` and `.zenodo.json`) | ⏳ TODO |

---

## Contact

Department of Economics — University of Foggia (Italy)
- Simona Curiello — simona.curiello@unifg.it
- Enrica Iannuzzi — enrica.iannuzzi@unifg.it
- Claudio Nigro — claudio.nigro@unifg.it
