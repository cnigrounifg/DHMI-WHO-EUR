# Companion-paper bridge — BIJ ↔ Companion paper

This document describes the empirical bridge between the present reproducibility package, which supports the *Benchmarking: An International Journal* (BIJ) paper, and the parallel companion paper currently in preparation (target journal under evaluation).

## Two papers, one dataset, two epistemological frames

| Dimension | BIJ paper | Companion paper |
|---|---|---|
| Title | Benchmarking digital health governance in the WHO European Region: A composite maturity index for cross-country policy comparison | Digital health governance as a complex adaptive system: systemic interdependencies, institutional feedback mechanisms and health system performance in the WHO European Region |
| Authors | Curiello, Iannuzzi, Nigro | Curiello, Iannuzzi, Nigro |
| Target journal | *Benchmarking: An International Journal* (Emerald, Q1) | *Under evaluation* |
| Empirical base | WHO 2023 Regional Office for Europe digital health survey | Same dataset |
| Geographic scope | 53 WHO European Region Member States | Same |
| Year | 2022–2023 reference cycle | Same |
| Epistemological frame | Composite-indicator benchmarking (OECD/JRC methodology) | Complex adaptive systems lens / structural-inferential modelling of governance subsystems |
| Methodological core | Equal-weight composite, four-procedure robustness, k=3 cluster, FDR-corrected Spearman, LASSO, Mann-Whitney U | PLS-SEM with reflective latent constructs, moderated mediation, multi-group analysis |
| Inferential level | Descriptive-comparative | Explanatory-structural |
| Dependent variable | DHMI composite score; cluster membership | UHC effective coverage index; avoidable mortality rate |
| Mediator(s) | n/a (no mediation in BIJ) | Systemic governance capacity (second-order construct of three subsystems) |
| Hypotheses | None (descriptive RQ on operationalisation) | Six directional hypotheses (H1a–H3b) |

The two papers share the empirical dataset and the country sample but address methodologically and theoretically distinct research questions. Neither paper duplicates the substantive findings or analytical strategies of the other.

## Indicator-to-construct mapping

The companion paper re-operationalises a subset of the 74 BIJ indicators as **reflective latent constructs** of three co-evolving CAS subsystems. The mapping is reproduced verbatim from the extended abstract (filename `51_IGCKM_SRBS.docx`, retained from the IGCKM 2026 conference submission; Curiello, Iannuzzi & Nigro, forthcoming) and is the canonical bridge between the BIJ data and the companion structural model.

| Companion construct | BIJ WHO indicators | BIJ domain (Table 2 of the BIJ paper) | Construct interpretation |
|---|---|---|---|
| Codified regulatory governance | DH_13, DH_14, DH_15, DH_17 | Regulatory frameworks | Explicit, rule-based dimension of the governance system; the codified architecture of patient-data rights, EHR interoperability, telehealth lawfulness, and cross-border data flows. |
| Workforce absorptive capacity | DH_9, DH_10, DH_11 | Digital health literacy and capacity building | Behavioural-adaptive dimension; the system's ability to recognise, assimilate and apply externally available digital health knowledge in practice (after Cohen & Levinthal, 1990; Zahra & George, 2002). |
| Data-integration architecture | DH_46, DH_50, DH_67 | Telehealth programmes (DH_46), mHealth (DH_50), Big data analytics (DH_67) | Boundary-spanning subsystem; the integration of information flows across organisational and territorial boundaries through telehealth, mHealth, and overarching data strategy. |

These three constructs collectively form a second-order construct labelled **systemic governance capacity** in the companion model.

## Cluster-as-grouping-variable

The companion paper's multi-group analysis uses the three DHMI maturity clusters (High, Medium, Low) imported from the BIJ paper as a categorical grouping variable. In the companion paper they are renamed for theoretical legibility:

| BIJ cluster (this paper) | Companion paper cluster | Definition |
|---|---|---|
| High Maturity (n = 12, mean DHMI = 100.0) | Comprehensive Adopters | Full adoption across all ten governance domains |
| Medium Maturity (n = 28, mean DHMI = 62.4) | Emerging Adopters | Partial governance framework architecture alongside full implementation-level adoption |
| Low Maturity (n = 12, mean DHMI = 22.2) | Fragmented Adopters | Governance-hollowed profile: operational deployment without strategic institutional anchoring |

The cluster assignments themselves are produced by the script `code/04_cluster_analysis.R` (to be modularly refactored from `code/DHMI_analysis.R`) and exported to `data/processed/cluster_assignments.csv` together with the companion-paper renaming.

## Empirical triangulation between the two papers

The BIJ paper identifies a FDR-corrected cross-domain Spearman correlation between regulatory framework adoption and overarching national data strategy adoption — DH_13–DH_67, ρ = 0.671 (BIJ paper, Table 3). This empirical pattern serves as an anchor for the companion paper's H2b structural hypothesis (codified regulatory governance → effective data-integration architecture).

The BIJ paper's cross-method convergence on DH_1, DH_2 and DH_3 (the three national strategy indicators) parallels the companion paper's prediction that codified regulatory governance functions as one of three co-evolving subsystems whose effect on data-integration architecture is conditional on workforce absorptive capacity (H3b, the substitution / requisite-variety hypothesis derived from Ashby, 1956).

These cross-paper convergences constitute empirical triangulation: the descriptive-comparative findings of the BIJ paper and the structural-inferential model of the companion paper, while methodologically and epistemologically distinct, converge on a common substantive interpretation of national digital health governance in the WHO European Region.

## Citing the bridge

If you use the BIJ data products to test a CAS / systems-thinking hypothesis, please cite both papers:

> Curiello, S., Iannuzzi, E., & Nigro, C. (2026). Benchmarking digital health governance in the WHO European Region: A composite maturity index for cross-country policy comparison. *Benchmarking: An International Journal* (under review).

> Curiello, S., Iannuzzi, E., & Nigro, C. (in preparation). Digital health governance as a complex adaptive system: systemic interdependencies, institutional feedback mechanisms and health system performance in the WHO European Region. *Manuscript in preparation; target journal under evaluation*.

And the reproducibility package itself:

> Curiello, S., Iannuzzi, E., & Nigro, C. (2026). *DHMI-WHO-EUR: Reproducibility package for the Digital Health Maturity Index* [Data set and code]. Zenodo. https://doi.org/10.5281/zenodo.XXXXXXX
