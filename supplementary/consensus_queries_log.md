# Consensus literature-review query log — DHMI editorial revision

This document records the systematic Consensus queries that motivated the editorial revision of the BIJ paper (Phase 1 + Phase 2 of `Changelog_v2.md`). It establishes the audit trail required to defend any reference added during revision against reviewer questions about provenance.

## Query design

Eight broad-coverage queries were executed against the Consensus academic search engine (https://consensus.app), which indexes over 200 million peer-reviewed articles drawn from Semantic Scholar, PubMed, Scopus, and ArXiv. Queries were executed on **13 May 2026** and limited to publications from 2022 onwards (with two foundational exceptions for Liu et al., 2020 and Cherchye et al., 2007). Approximately 150 paper abstracts were screened.

## Eight thematic queries

The eight thematic clusters of the literature review correspond directly to the gaps identified in `00_Action_Planning.md` §2–§6:

1. **EU regulatory readiness instruments (EHDS, AI Act, GDPR)** — supplying Maaß et al. (2025), Kessissoglou et al. (2024), Iorio et al. (2025), Kalodanis et al. (2025), Cervera de la Cruz et al. (2025), Marelli et al. (2023).
2. **Recent BoD/DEA extensions for composite indicator construction** — supplying Fusco (2022), Walheer (2024), Su et al. (2022), Bánhidi et al. (2023), Libório et al. (2024); Cherchye et al. (2007) retained as the foundational reference.
3. **Ceiling effects in cross-sectional measurement** — supplying Liu, Wang & West (2020) on truncated-normal t-tests/ANOVA for ceiling-affected data.
4. **Item Response Theory for composite indicators** — supplying van der Linde et al. (2025) on rankability and data-driven versus expert-driven composite indicators.
5. **Self-report bias in policy and digital-health surveys** — supplying Parry, Davidson & Sewall et al. (2021) meta-analysis of logged-versus-self-reported digital media use; Lira, Vergara & Beilock et al. (2022) on reference bias; Bhatia, Mossialos & Patel (2022) on self-report validity in policy surveys; Cresswell et al. (2024) already cited in the original bozza is expanded.
6. **LASSO performance under small N** — supplying Van Calster, van Smeden et al. (2020) simulation study of regression shrinkage methods; Pavlou et al. (2024) on modified cross-validation and bootstrap tuning; Zhou & Bauer (2024) on 1SE rule for psychological data; Bainter et al. (2023) on Bayesian SSVS as a robust alternative to LASSO.
7. **WHO 2023 data — competing operationalisations on the same dataset** — Consensus returned zero competing operationalisations of the 74-indicator WHO 2023 dataset on the 53 Member States of the WHO European Region, confirming the originality claim of the DHMI.
8. **Companion paper anchor literature (CAS, absorptive capacity, PLS-SEM)** — Hair, Risher, Sarstedt & Ringle (2019); Sarstedt, Hair & Ringle (2022); Holland (1992); Ashby (1956); Cohen & Levinthal (1990); Zahra & George (2002); Simon (1991); Levinthal & March (1993). Retrieved primarily to enable the BIJ companion-paper framing in §1 and §6.

## Coverage summary

| Theme | Papers screened | Papers selected for integration | Selection rationale |
|---|---|---|---|
| EHDS/AI Act readiness | ~30 | 4 (Maaß 2025, Kessissoglou 2024, Iorio 2025, Kalodanis 2025) | Most-cited and most-directly comparable to DHMI |
| BoD extensions | ~20 | 5 (Cherchye 2007, Fusco 2022, Walheer 2024, Su 2022, Bánhidi 2023) | Each extension addresses a distinct frontier-collapse / rank-reversal issue |
| Ceiling effects | ~15 | 1 (Liu 2020, 140 citations) | Canonical methodological reference |
| IRT | ~15 | 1 (van der Linde 2025) | Directly applicable to composite indicators in between-unit settings |
| Self-report bias | ~25 | 2 added (Lira 2022, Parry 2021); 1 expanded (Cresswell 2024) | Parry meta-analysis = 536 citations; Lira = direct policy applicability |
| LASSO small-N | ~20 | 2 (Van Calster 2020, Pavlou 2024); 1 deferred to future (Bainter 2023 SSVS) | Most direct evidence on calibration variability and modified tuning |
| WHO 2023 dataset competing ops | ~10 | 0 | Confirms originality claim |
| CAS / PLS-SEM theoretical anchors | ~15 | 4 inserted in BIJ via companion citation (Hair 2019, Sarstedt 2022, Holland 1992, Ashby 1956) | Required for §1 and §6 companion-paper framing |

## Reproducing the review

Co-authors and future researchers wishing to reproduce or extend this literature review can re-execute the same thematic queries through the Consensus interface or via the Anthropic-hosted Consensus MCP connector. Two principles apply:

1. The eight queries above are **thematic clusters**, not literal search strings. Co-authors should formulate the underlying intent in their own words and screen the top 20 results of each query.
2. Any reference added in subsequent revision rounds should be added to this log together with the corresponding screening rationale, preserving the audit trail.

---

*This document is the audit-trail supplement to `Changelog_v2.md` of the BIJ paper. Together with `supplementary/action_planning.md`, it documents the systematic literature review that informed each editorial revision.*
