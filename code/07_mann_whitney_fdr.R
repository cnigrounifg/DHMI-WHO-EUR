# =============================================================================
# 07_mann_whitney_fdr.R — Mann-Whitney U tests with FDR correction
# =============================================================================
#
# Purpose : For each of the 43 retained WHO indicators, compare adoption
#           scores between the High-Maturity (n = 12) and Low-Maturity
#           (n = 12) clusters via Mann-Whitney U tests. Apply Benjamini-
#           Hochberg FDR correction across the 43 tests and compute effect
#           sizes r = |Z|/sqrt(N).
#
#           Cross-method convergence with LASSO selection is computed at the
#           end of the script and persisted as a separate CSV.
#
# Inputs  : data/processed/indicators_recoded.csv
#           data/processed/retained_indicators.csv
#           data/processed/cluster_assignments.csv
#           data/processed/lasso_results.csv
#
# Outputs : data/processed/mw_results.csv
#               (full per-indicator MW table with FDR-corrected p and r)
#           data/processed/mw_sig_indicators.csv
#               (subset surviving p_FDR < 0.05)
#           data/processed/cross_method_convergence.csv
#               (LASSO ∩ MW(FDR) joint table — primary convergent indicators)
#
# Dependencies : 00_setup.R, 04_cluster_analysis.R, 05_spearman_fdr.R, 06_lasso_regression.R
# =============================================================================

source("code/00_setup.R")


# -----------------------------------------------------------------------------
# 7.1  Load inputs
# -----------------------------------------------------------------------------
df_europe              <- read_csv(file.path(PATH_PROCESSED, "indicators_recoded.csv"),
                                   show_col_types = FALSE)
keep_cols              <- read_csv(file.path(PATH_PROCESSED, "retained_indicators.csv"),
                                   show_col_types = FALSE)$Indicator
country_maturity_clean <- read_csv(file.path(PATH_PROCESSED, "cluster_assignments.csv"),
                                   show_col_types = FALSE)
lasso_df_annotated     <- read_csv(file.path(PATH_PROCESSED, "lasso_results.csv"),
                                   show_col_types = FALSE)


# -----------------------------------------------------------------------------
# 7.2  Prepare comparison dataset
# -----------------------------------------------------------------------------
mw_data <- df_europe %>%
  dplyr::select(COUNTRY_REGION, all_of(keep_cols)) %>%
  mutate(across(all_of(keep_cols), as.numeric)) %>%
  left_join(
    country_maturity_clean %>% dplyr::select(COUNTRY_REGION, Cluster_Label),
    by = "COUNTRY_REGION"
  ) %>%
  filter(Cluster_Label %in% c("High Maturity", "Low Maturity"))

n_high <- sum(mw_data$Cluster_Label == "High Maturity")
n_low  <- sum(mw_data$Cluster_Label == "Low Maturity")
message(sprintf("Mann-Whitney — High: %d | Low: %d", n_high, n_low))


# -----------------------------------------------------------------------------
# 7.3  Run Mann-Whitney U for each indicator
# -----------------------------------------------------------------------------
mw_results <- lapply(keep_cols, function(ind) {
  high <- mw_data[[ind]][mw_data$Cluster_Label == "High Maturity"]
  low  <- mw_data[[ind]][mw_data$Cluster_Label == "Low Maturity"]
  high <- high[!is.na(high)]
  low  <- low[!is.na(low)]
  if (length(high) < 3 || length(low) < 3) return(NULL)

  test   <- wilcox.test(high, low, exact = FALSE)
  z_stat <- qnorm(test$p.value / 2) * sign(mean(high) - mean(low))
  r_eff  <- abs(z_stat) / sqrt(length(high) + length(low))

  data.frame(
    Indicator  = ind,
    Mean_High  = round(mean(high), 2),
    Mean_Low   = round(mean(low),  2),
    Diff       = round(mean(high) - mean(low), 2),
    W_stat     = round(test$statistic, 1),
    p_value    = round(test$p.value, 4),
    r_effect   = round(r_eff, 3)
  )
}) %>% bind_rows()


# -----------------------------------------------------------------------------
# 7.4  FDR correction and significance stars
# -----------------------------------------------------------------------------
mw_results <- mw_results %>%
  mutate(
    p_fdr   = round(p.adjust(p_value, method = "BH"), 4),
    sig_fdr = case_when(
      p_fdr < 0.001 ~ "***",
      p_fdr < 0.01  ~ "**",
      p_fdr < 0.05  ~ "*",
      TRUE          ~ "ns"
    )
  ) %>%
  arrange(p_fdr)

sig_fdr_results <- mw_results %>% filter(sig_fdr != "ns") %>%
  mutate(
    Description = INDICATOR_LABELS[Indicator],
    Description = if_else(is.na(Description), Indicator, Description),
    Domain      = INDICATOR_DOMAIN_MAP[Description],
    Domain      = if_else(is.na(Domain), "Other", Domain)
  )

message(sprintf("Indicators significant after FDR correction: %d",
                nrow(sig_fdr_results)))


# -----------------------------------------------------------------------------
# 7.5  Cross-method convergence (LASSO ∩ MW-FDR)
# -----------------------------------------------------------------------------
lasso_selected <- lasso_df_annotated$Indicator
mw_selected    <- sig_fdr_results$Indicator
convergent     <- intersect(lasso_selected, mw_selected)

message(sprintf(
  "\nCross-method convergence:\n  LASSO: %d | Mann-Whitney (FDR): %d | Overlap: %d",
  length(lasso_selected), length(mw_selected), length(convergent)
))

convergence_df <- data.frame(
  Indicator   = unname(convergent),
  WHO_label   = unname(INDICATOR_LABELS[convergent]),
  Domain      = unname(INDICATOR_DOMAIN_MAP[INDICATOR_LABELS[convergent]]),
  LASSO_beta  = round(lasso_df_annotated$Coefficient[
    match(convergent, lasso_df_annotated$Indicator)], 3),
  MW_r_effect = round(mw_results$r_effect[
    match(convergent, mw_results$Indicator)], 3),
  MW_p_FDR    = round(mw_results$p_fdr[
    match(convergent, mw_results$Indicator)], 4),
  Convergent  = "Yes",
  stringsAsFactors = FALSE
)
print(convergence_df)


# -----------------------------------------------------------------------------
# 7.6  Write outputs
# -----------------------------------------------------------------------------
write_csv(mw_results,
          file.path(PATH_PROCESSED, "mw_results.csv"))
write_csv(sig_fdr_results,
          file.path(PATH_PROCESSED, "mw_sig_indicators.csv"))
write_csv(convergence_df,
          file.path(PATH_PROCESSED, "cross_method_convergence.csv"))

message("07_mann_whitney_fdr.R: wrote mw_results.csv, mw_sig_indicators.csv, cross_method_convergence.csv")
