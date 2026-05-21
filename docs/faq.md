# Frequently asked questions — anticipated reviewer queries

This document gathers five anticipated reviewer questions about the DHMI methodology together with concise, paper-grounded answers. The intent is to make the most predictable lines of objection legible *before* peer review and to provide reviewers with a single reference point. Each answer cross-references the relevant section of the BIJ paper.

---

## Q1. Why equal weighting? Don't unequal weights produce a more informative composite?

The DHMI adopts equal weighting across its ten WHO policy domains for three substantive reasons set out in §3 of the BIJ paper. (i) **Interpretability**: equal weighting produces a DHMI score directly readable as the mean adoption rate across all policy domains, which is a transparent property that policy users can audit by inspection. (ii) **Avoidance of arbitrary domain-level differentiation**: in the absence of a theoretical or empirical basis for assigning relative importance to (say) governance frameworks versus mHealth services, unequal weighting would introduce a hidden value judgement disguised as a methodological choice. (iii) **Alignment with the WHO survey instrument's holistic framing**, in which the ten domains are treated as collectively constitutive of national digital health governance rather than as ranked components.

Equal weighting is **not assumed to be optimal**; it is tested against a PCA-derived alternative weighting scheme and a 1,000-simulation weight-perturbation sensitivity analysis. The rank correlations between the equal-weight DHMI and the alternative schemes (PCA: ρ = 0.933; weight-perturbation mean: ρ = 0.928) demonstrate that country rankings are structurally robust to the weighting assumption (BIJ paper, §4 Robustness protocol results).

A benefit-of-the-doubt (BoD/DEA) weighting was additionally attempted but is inapplicable in this setting due to the collapse of the efficiency frontier under eight constant-valued output dimensions. The BIJ paper discusses this non-result in §3 and reviews recent BoD extensions (Fusco, 2022; Walheer, 2024; Su et al., 2022; Bánhidi et al., 2023) that could in principle address frontier-collapse issues in future cycles.

## Q2. Why apply LASSO with n = 52? Isn't the predictor-to-observation ratio too large for reliable inference?

The BIJ paper uses LASSO **as a descriptive indicator-selection tool, not as an inferential ranking device**. The distinction is articulated in §3 immediately after the LASSO regression paragraph: coefficient magnitudes and signs are reported for transparency but are *not* interpreted as point estimates of indicator-level causal effects. The reported in-sample R² = 0.672, LOO-CV R² = 0.492 and MAE = 15.62 DHMI points are presented as honest diagnostics of model performance, not as evidence of inferential precision.

Two methodological caveats are made explicit. The simulation study of Van Calster et al. (2020) documents that the calibration slope of LASSO-derived prediction models exhibits substantial variability under small sample sizes, and that standard 10-fold cross-validation tuning of λ does not guarantee improved predictive performance over unpenalised regression. Pavlou et al. (2024) propose a modified cross-validation and bootstrap-tuning procedure that mitigates over-shrinkage in small-N settings.

The paper deliberately retains the canonical λ.min tuning to preserve comparability with the established small-N LASSO literature; the modified-CV refinement is registered as a future direction. The robustness of the LASSO finding ultimately rests on **cross-method convergence with Mann-Whitney U discrimination** (BIJ paper, Table 4): three indicators (DH_1, DH_2, DH_3) survive both LASSO selection and FDR-corrected Mann-Whitney discrimination, providing methodologically independent evidence for the same conclusion.

## Q3. Why not analyse the data through a complex adaptive systems / structural lens directly? The cross-domain correlations suggest a richer story than a composite index can capture.

The BIJ paper is deliberately bounded to the construction, validation, and descriptive-comparative application of the DHMI. The CAS-style analysis is the subject of a parallel **companion paper** (Curiello, Iannuzzi & Nigro, in preparation; target journal under evaluation), which:

- re-operationalises a subset of the 74 WHO indicators as reflective latent constructs of three co-evolving governance subsystems (codified regulatory governance, workforce absorptive capacity, data-integration architecture);
- tests six moderated-mediation hypotheses (H1a–H3b) via PLS-SEM (Hair et al., 2019; Sarstedt et al., 2022);
- uses the three DHMI maturity clusters as a categorical grouping variable in multi-group analysis.

The two papers share the empirical dataset and the country sample but address methodologically and theoretically distinct research questions. The companion paper targets a different journal (under evaluation) and a different epistemological frame (structural-inferential modelling of governance subsystems under a complex adaptive systems lens). The mapping between the two papers is documented in `companion_paper_bridge/README_bridge.md` of this repository.

## Q4. Eight of ten domains show zero cross-country variance. Doesn't this mean the DHMI is effectively a one-domain instrument?

In the current 2023 WHO survey cycle, the DHMI composite variance is concentrated in two domains — governance frameworks and digital health literacy — with the remaining eight domains saturating at maximum adoption across the Region. This pattern is acknowledged in the BIJ paper as a **structural ceiling effect** (Liu et al., 2020), not as a methodological artefact of the DHMI.

Two consequences follow. First, in the current cycle the DHMI does function empirically as an approximate governance framework adoption index — and this is **the finding**, not a defect: it reveals that the binding constraint on cross-country digital health maturity in the WHO European Region is the formalisation of the strategic governance architecture, not the operational deployment of digital tools. Second, the design of future WHO survey instruments should incorporate more granular sub-indicators for operational domains currently showing ceiling effects in order to restore discriminant power to the full ten-domain composite (BIJ paper, §6 fourth limitation).

The paper additionally registers Item Response Theory (van der Linde et al., 2025) as a promising direction for future iterations of the DHMI once longitudinal WHO survey data permit IRT estimation. IRT can produce a continuous latent score with higher *rankability* — the proportion of inter-unit variance not attributable to chance — in the presence of ceiling effects.

## Q5. The DHMI and the companion paper both rely on the same WHO 2023 dataset. Why is this not duplicate publication?

The two papers share the empirical dataset and the country sample. They differ in **epistemological frame, methodological core, unit of inference, and target journal**, and they pursue **methodologically and theoretically distinct research questions**:

- The BIJ paper addresses *how* WHO-standardised survey data can be operationalised into a replicable composite maturity index for cross-country benchmarking. Its unit of inference is the country and the empirical artefact is a one-dimensional composite score with associated cluster typology.
- The companion paper addresses *through which systemic mechanisms* macro-institutional quality translates into health system performance via three co-evolving governance subsystems modelled as a complex adaptive system. Its unit of inference is the structural-model path coefficient and its empirical artefact is a moderated-mediation PLS-SEM estimate.

The relationship between the two papers is documented transparently in the Acknowledgements section of the BIJ paper, in §1 and §6 of the BIJ paper (which cite the companion explicitly), and in `companion_paper_bridge/README_bridge.md` of this repository. Neither paper duplicates the substantive findings or analytical strategies of the other; the empirical bridge between them is principled and pre-declared.
