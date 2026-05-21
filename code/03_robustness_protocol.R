# =============================================================================
# 03_robustness_protocol.R — Weight perturbation and missing-data sensitivity
# =============================================================================
#
# Purpose : Implement procedures (i), (ii) and (iii) of the four-procedure
#           robustness protocol described in §3 of the BIJ paper:
#           (i)  Weight-perturbation sensitivity analysis — 1,000 DHMI rankings
#                under randomly drawn weight vectors from a uniform simplex.
#           (ii) PCA-derived alternative aggregation — placeholder TODO below.
#           (iii) Missing-data sensitivity — DHMI re-estimated on the
#                 restricted sample (countries with <20% item-level missingness).
#
#           Procedure (iv) — convergent validity testing — is implemented in
#           08_external_validity.R.
#
# Inputs  : data/processed/DHMI_scores_final.csv
#           data/processed/domain_scores.csv
#           data/processed/excluded_countries.csv
#
# Outputs : data/processed/rank_stability.csv
#               (per-country mean simulated rank + P5/P95 + Range)
#           data/processed/robustness_summary.csv
#               (single-row CSV with Spearman ρ for each robustness procedure)
#           data/processed/missing_sensitivity.csv
#               (paired DHMI_full vs DHMI_restricted scores for the n=43 sample)
#
# Dependencies : 00_setup.R, 01_data_preparation.R, 02_dhmi_construction.R
# =============================================================================

source("code/00_setup.R")


# -----------------------------------------------------------------------------
# 3.1  Load inputs
# -----------------------------------------------------------------------------
country_maturity   <- read_csv(file.path(PATH_PROCESSED, "DHMI_scores_final.csv"),
                               show_col_types = FALSE)
domain_scores      <- read_csv(file.path(PATH_PROCESSED, "domain_scores.csv"),
                               show_col_types = FALSE)
excluded_countries <- read_csv(file.path(PATH_PROCESSED, "excluded_countries.csv"),
                               show_col_types = FALSE)$COUNTRY_REGION


# -----------------------------------------------------------------------------
# 3.2  Procedure (i) — Weight perturbation (1,000 simulations)
# -----------------------------------------------------------------------------
set.seed(42)
n_sim    <- 1000
n_domain <- length(DOMAIN_COLS)

# Prepare domain matrix; impute NA with column median
domain_mat <- domain_scores %>%
  dplyr::select(all_of(DOMAIN_COLS)) %>%
  as.matrix()

for (col in seq_len(ncol(domain_mat))) {
  med <- median(domain_mat[, col], na.rm = TRUE)
  domain_mat[is.na(domain_mat[, col]), col] <- med
}

sim_rankings <- matrix(NA, nrow = nrow(domain_mat), ncol = n_sim)
for (i in seq_len(n_sim)) {
  w <- runif(n_domain)
  w <- w / sum(w)
  sim_rankings[, i] <- rank(-(domain_mat %*% w), ties.method = "average")
}

rank_stability <- data.frame(
  COUNTRY_REGION = domain_scores$COUNTRY_REGION,
  Rank_Equal     = rank(-domain_scores$DHMI_equal, ties.method = "average"),
  Rank_Mean_Sim  = rowMeans(sim_rankings),
  Rank_SD_Sim    = apply(sim_rankings, 1, sd),
  Rank_P5        = apply(sim_rankings, 1, quantile, 0.05),
  Rank_P95       = apply(sim_rankings, 1, quantile, 0.95)
) %>%
  mutate(Rank_Range = Rank_P95 - Rank_P5) %>%
  arrange(Rank_Equal)

sa_corr <- cor.test(rank_stability$Rank_Equal,
                    rank_stability$Rank_Mean_Sim,
                    method = "spearman")
message(sprintf("Procedure (i) — Weight perturbation: Spearman ρ = %.3f (p = %.6f)",
                sa_corr$estimate, sa_corr$p.value))

unstable <- rank_stability %>% filter(Rank_Range > 10)
message(sprintf("Countries with P5–P95 rank range > 10 positions: %d", nrow(unstable)))


# -----------------------------------------------------------------------------
# 3.3  Procedure (iii) — Missing-data sensitivity (full vs restricted sample)
# -----------------------------------------------------------------------------
dhmi_full <- country_maturity %>%
  dplyr::select(COUNTRY_REGION, DHMI_scaled) %>%
  rename(DHMI_full = DHMI_scaled)

dhmi_restricted <- country_maturity %>%
  filter(!COUNTRY_REGION %in% excluded_countries, !is.na(DHMI_scaled)) %>%
  dplyr::select(COUNTRY_REGION, DHMI_scaled) %>%
  mutate(DHMI_restricted = scales::rescale(DHMI_scaled, to = c(0, 100))) %>%
  dplyr::select(-DHMI_scaled)

missing_sensitivity <- dhmi_full %>%
  inner_join(dhmi_restricted, by = "COUNTRY_REGION")

ms_corr <- cor.test(missing_sensitivity$DHMI_full,
                    missing_sensitivity$DHMI_restricted,
                    method = "spearman")
message(sprintf("Procedure (iii) — Missing-data sensitivity: Spearman ρ = %.3f (p = %.6f, n = %d)",
                ms_corr$estimate, ms_corr$p.value, nrow(missing_sensitivity)))


# -----------------------------------------------------------------------------
# 3.4  Procedure (ii) — PCA-derived alternative weighting  [TODO co-author]
# -----------------------------------------------------------------------------
# The BIJ paper reports a PCA-weighted DHMI with Spearman ρ = 0.933 against the
# equal-weighted baseline. The implementation skeleton is sketched in §2.5 of
# 02_dhmi_construction.R. When implemented, write the value to
# robustness_summary.csv in the placeholder slot below.
pca_corr_placeholder <- NA_real_


# -----------------------------------------------------------------------------
# 3.5  Write outputs
# -----------------------------------------------------------------------------
write_csv(rank_stability,
          file.path(PATH_PROCESSED, "rank_stability.csv"))
write_csv(missing_sensitivity,
          file.path(PATH_PROCESSED, "missing_sensitivity.csv"))

robustness_summary <- data.frame(
  procedure = c("(i) weight_perturbation_1000sim",
                "(ii) pca_weighted_ranking",
                "(iii) missing_data_sensitivity"),
  spearman_rho = c(round(sa_corr$estimate, 3),
                   pca_corr_placeholder,
                   round(ms_corr$estimate, 3)),
  p_value      = c(round(sa_corr$p.value, 6),
                   NA_real_,
                   round(ms_corr$p.value, 6)),
  n            = c(nrow(rank_stability),
                   NA_integer_,
                   nrow(missing_sensitivity)),
  notes        = c("Mean simulated rank vs equal-weight rank.",
                   "TODO co-author: implement PCA-derived weighting (see 02_dhmi_construction.R TODO).",
                   "Restricted sample of countries with <20% item-level missingness.")
)

write_csv(robustness_summary,
          file.path(PATH_PROCESSED, "robustness_summary.csv"))

message("03_robustness_protocol.R: wrote rank_stability.csv, missing_sensitivity.csv, robustness_summary.csv")
