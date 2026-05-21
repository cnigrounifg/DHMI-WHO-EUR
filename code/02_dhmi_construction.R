# =============================================================================
# 02_dhmi_construction.R — Compute domain adoption rates and the DHMI
# =============================================================================
#
# Purpose : From the recoded indicator matrix, compute per-country domain
#           adoption rates (proportion of indicators in each domain that
#           are non-absent), the equal-weighted DHMI, and a 0–100 rescaled
#           version for cross-country comparability.
#
# Inputs  : data/processed/indicators_recoded.csv
#
# Outputs : data/processed/domain_scores.csv
#               (53 × 10 domain adoption rates + DHMI_equal + DHMI_scaled)
#           data/processed/DHMI_scores_final.csv
#               (53 × {COUNTRY_REGION, DHMI_equal, DHMI_scaled}, sorted desc)
#
# Methodology: OECD/JRC composite-indicator framework (Nardo et al., 2008).
#   Adoption rate per domain = (# indicators >= 0) / (# non-missing indicators) * 100
#   DHMI_equal  = arithmetic mean of the 10 domain-level adoption rates
#   DHMI_scaled = DHMI_equal rescaled to the 0–100 range for communication
#
# Dependencies : 00_setup.R
# =============================================================================

source("code/00_setup.R")


# -----------------------------------------------------------------------------
# 2.1  Load preprocessed indicator data
# -----------------------------------------------------------------------------
df_europe <- read_csv(file.path(PATH_PROCESSED, "indicators_recoded.csv"),
                      show_col_types = FALSE)


# -----------------------------------------------------------------------------
# 2.2  Domain-level adoption rate (proportion of indicators with score >= 0)
# -----------------------------------------------------------------------------
compute_domain_ar <- function(df_wide, indicators) {
  cols      <- intersect(indicators, colnames(df_wide))
  vals      <- df_wide[, cols]
  adopted   <- rowSums(vals >= 0, na.rm = TRUE)
  available <- rowSums(!is.na(vals))
  ifelse(available == 0, NA_real_, (adopted / available) * 100)
}


# -----------------------------------------------------------------------------
# 2.3  Compute domain scores and the DHMI
# -----------------------------------------------------------------------------
domain_scores <- df_europe %>%
  dplyr::select(COUNTRY_REGION) %>%
  bind_cols(
    lapply(DOMAIN_MAP, compute_domain_ar, df_wide = df_europe) %>%
      as.data.frame()
  ) %>%
  mutate(DHMI_equal = rowMeans(across(all_of(DOMAIN_COLS)), na.rm = TRUE))


# -----------------------------------------------------------------------------
# 2.4  Rescale DHMI_equal to 0–100 and order by descending maturity
# -----------------------------------------------------------------------------
country_maturity <- domain_scores %>%
  dplyr::select(COUNTRY_REGION, DHMI_equal) %>%
  mutate(DHMI_scaled = scales::rescale(DHMI_equal, to = c(0, 100))) %>%
  arrange(desc(DHMI_scaled))

domain_scores <- domain_scores %>%
  left_join(country_maturity %>% dplyr::select(COUNTRY_REGION, DHMI_scaled),
            by = "COUNTRY_REGION")

message("DHMI summary statistics:")
print(summary(country_maturity$DHMI_scaled))


# -----------------------------------------------------------------------------
# 2.5  Write outputs
# -----------------------------------------------------------------------------
write_csv(domain_scores,
          file.path(PATH_PROCESSED, "domain_scores.csv"))
write_csv(country_maturity,
          file.path(PATH_PROCESSED, "DHMI_scores_final.csv"))

message("02_dhmi_construction.R: wrote domain_scores.csv and DHMI_scores_final.csv")


# -----------------------------------------------------------------------------
# TODO co-author — PCA-derived alternative weighting
# -----------------------------------------------------------------------------
# §3 of the BIJ paper tests equal weighting against a PCA-derived alternative
# (governance-domain weight = 50%, literacy weight = 0%, eight constant domains
# share 50% equally). The robustness Spearman ρ = 0.933 between the two
# rankings should be reproduced here. Implementation skeleton:
#
#   varying_cols <- DOMAIN_COLS[sapply(domain_scores[DOMAIN_COLS],
#                                      function(x) var(x, na.rm = TRUE) > 0)]
#   pca <- prcomp(scale(domain_scores[, varying_cols]))
#   loadings_pc1 <- abs(pca$rotation[, 1])^2
#   pca_weights <- loadings_pc1 / sum(loadings_pc1) * 0.5
#   pca_weights[setdiff(DOMAIN_COLS, varying_cols)] <-
#       0.5 / length(setdiff(DOMAIN_COLS, varying_cols))
#   DHMI_pca <- as.matrix(domain_scores[, DOMAIN_COLS]) %*%
#               pca_weights[DOMAIN_COLS]
#
# Save to data/processed/DHMI_scores_pca.csv.
