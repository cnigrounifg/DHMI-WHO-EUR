# =============================================================================
# 05_spearman_fdr.R — Spearman correlation with Benjamini-Hochberg FDR
# =============================================================================
#
# Purpose : Compute pairwise Spearman correlations among the 43 retained WHO
#           digital health indicators (zero-variance and >50%-missing
#           indicators excluded). Apply Benjamini-Hochberg FDR correction
#           across the 903 unique pairs and report the surviving pairs.
#
# Inputs  : data/processed/indicators_recoded.csv
#
# Outputs : data/processed/spearman_correlation_matrix.csv   — full matrix
#           data/processed/spearman_pvalue_matrix.csv         — full p-matrix
#           data/processed/spearman_sig_pairs.csv             — FDR survivors
#
# Dependencies : 00_setup.R, 01_data_preparation.R
# =============================================================================

source("code/00_setup.R")


# -----------------------------------------------------------------------------
# 5.1  Load indicator data and prepare clean matrix
# -----------------------------------------------------------------------------
df_europe <- read_csv(file.path(PATH_PROCESSED, "indicators_recoded.csv"),
                      show_col_types = FALSE)

indicator_data <- df_europe %>%
  dplyr::select(all_of(ALL_INDICATORS)) %>%
  mutate(across(everything(), as.numeric))

keep_cols <- names(indicator_data)[
  sapply(indicator_data, function(x) var(x, na.rm = TRUE) > 0) &
    sapply(indicator_data, function(x) mean(is.na(x)) < 0.5)
]
message(sprintf("Indicators retained for correlation: %d / %d",
                length(keep_cols), length(ALL_INDICATORS)))

indicator_clean <- indicator_data[, keep_cols]
for (col in names(indicator_clean)) {
  med <- median(indicator_clean[[col]], na.rm = TRUE)
  indicator_clean[[col]][is.na(indicator_clean[[col]])] <- med
}

# Persist the retained-indicator list for downstream scripts (LASSO, MW)
write_csv(data.frame(Indicator = keep_cols),
          file.path(PATH_PROCESSED, "retained_indicators.csv"))


# -----------------------------------------------------------------------------
# 5.2  Compute correlation and p-value matrices
# -----------------------------------------------------------------------------
cor_matrix <- cor(indicator_clean, method = "spearman")
p_matrix   <- ggcorrplot::cor_pmat(indicator_clean, method = "spearman")


# -----------------------------------------------------------------------------
# 5.3  Long form, FDR correction, filter
# -----------------------------------------------------------------------------
sig_cors <- as.data.frame(as.table(cor_matrix)) %>%
  rename(Ind1 = Var1, Ind2 = Var2, rho = Freq) %>%
  filter(as.character(Ind1) < as.character(Ind2)) %>%
  mutate(p_val = mapply(function(i, j) p_matrix[i, j],
                        as.character(Ind1), as.character(Ind2)),
         p_fdr = p.adjust(p_val, method = "BH")) %>%
  filter(p_fdr < 0.05) %>%
  arrange(desc(abs(rho)))

message(sprintf("Significant correlation pairs (p_FDR < 0.05): %d", nrow(sig_cors)))
message("Top 15 (by |ρ|):")
print(sig_cors %>% head(15) %>%
        mutate(across(where(is.numeric), ~round(.x, 3))))


# -----------------------------------------------------------------------------
# 5.4  Write outputs
# -----------------------------------------------------------------------------
write.csv(round(cor_matrix, 4),
          file.path(PATH_PROCESSED, "spearman_correlation_matrix.csv"))
write.csv(round(p_matrix, 4),
          file.path(PATH_PROCESSED, "spearman_pvalue_matrix.csv"))
write_csv(sig_cors,
          file.path(PATH_PROCESSED, "spearman_sig_pairs.csv"))

message("05_spearman_fdr.R: wrote correlation matrix, p-value matrix, and sig_pairs CSV")
