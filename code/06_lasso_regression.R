# =============================================================================
# 06_lasso_regression.R — LASSO regression with 10-fold + LOO-CV
# =============================================================================
#
# Purpose : Fit a LASSO regression of the DHMI on the 43 retained WHO
#           indicators (n = 52 scoreable Member States). λ tuned via 10-fold
#           cross-validation. Out-of-sample predictive accuracy reported via
#           leave-one-out cross-validation (LOO-CV).
#
# Inputs  : data/processed/indicators_recoded.csv
#           data/processed/retained_indicators.csv
#           data/processed/cluster_assignments.csv  (for DHMI_scaled outcome)
#
# Outputs : data/processed/lasso_results.csv
#               (LASSO coefficients at λ.min for selected indicators,
#                annotated with Description and Domain)
#           data/processed/lasso_performance.csv
#               (R² in-sample, R² LOO-CV, MAE, overfitting gap)
#           data/processed/lasso_loo_predictions.csv
#               (per-country leave-one-out predictions vs observed DHMI)
#
# Methodological caveat: LASSO is positioned as a descriptive indicator-
# selection tool, not as an inferential ranking device. Coefficient signs
# should be interpreted with caution under the zero-variance domain structure
# of the WHO 2023 cycle (see Van Calster et al. 2020; Pavlou et al. 2024).
#
# Dependencies : 00_setup.R, 01_data_preparation.R, 04_cluster_analysis.R,
#                05_spearman_fdr.R (for retained_indicators.csv)
# =============================================================================

source("code/00_setup.R")


# -----------------------------------------------------------------------------
# 6.1  Load inputs
# -----------------------------------------------------------------------------
df_europe <- read_csv(file.path(PATH_PROCESSED, "indicators_recoded.csv"),
                      show_col_types = FALSE)
keep_cols <- read_csv(file.path(PATH_PROCESSED, "retained_indicators.csv"),
                      show_col_types = FALSE)$Indicator
country_maturity_clean <- read_csv(file.path(PATH_PROCESSED, "cluster_assignments.csv"),
                                   show_col_types = FALSE)


# -----------------------------------------------------------------------------
# 6.2  Build predictor matrix X and outcome vector y
# -----------------------------------------------------------------------------
lasso_data <- df_europe %>%
  dplyr::select(COUNTRY_REGION, all_of(keep_cols)) %>%
  mutate(across(all_of(keep_cols), as.numeric)) %>%
  left_join(
    country_maturity_clean %>% dplyr::select(COUNTRY_REGION, DHMI_scaled),
    by = "COUNTRY_REGION"
  ) %>%
  filter(!is.na(DHMI_scaled))

X_df <- lasso_data %>% dplyr::select(all_of(keep_cols))
for (col in names(X_df)) {
  med <- median(X_df[[col]], na.rm = TRUE)
  X_df[[col]][is.na(X_df[[col]])] <- med
}
X <- as.matrix(X_df)
y <- lasso_data$DHMI_scaled

message(sprintf("LASSO — X: %d × %d | y: %d observations",
                nrow(X), ncol(X), length(y)))


# -----------------------------------------------------------------------------
# 6.3  10-fold cross-validated LASSO
# -----------------------------------------------------------------------------
set.seed(42)
cv_lasso <- cv.glmnet(X, y, alpha = 1, nfolds = 10)

lasso_coef <- coef(cv_lasso, s = "lambda.min")
lasso_df   <- data.frame(
  Indicator   = rownames(lasso_coef),
  Coefficient = round(as.vector(lasso_coef), 4)
) %>%
  filter(Coefficient != 0, Indicator != "(Intercept)") %>%
  arrange(desc(abs(Coefficient)))

message(sprintf("Indicators selected by LASSO: %d", nrow(lasso_df)))


# -----------------------------------------------------------------------------
# 6.4  In-sample R²
# -----------------------------------------------------------------------------
y_pred   <- as.vector(predict(cv_lasso, newx = X, s = "lambda.min"))
r2_lasso <- 1 - sum((y - y_pred)^2) / sum((y - mean(y))^2)


# -----------------------------------------------------------------------------
# 6.5  Leave-one-out cross-validation R²
# -----------------------------------------------------------------------------
n        <- nrow(X)
loo_pred <- numeric(n)
for (i in seq_len(n)) {
  fit_loo     <- glmnet(X[-i, ], y[-i], alpha = 1,
                        lambda = cv_lasso$lambda.min)
  loo_pred[i] <- predict(fit_loo, newx = X[i, , drop = FALSE],
                         s = cv_lasso$lambda.min)[1]
}
r2_loo <- 1 - sum((y - loo_pred)^2) / sum((y - mean(y))^2)
mae    <- mean(abs(y - loo_pred))

message(sprintf("LASSO R² in-sample: %.3f | LOO-CV: %.3f | MAE: %.2f | Overfitting gap: %.3f",
                r2_lasso, r2_loo, mae, r2_lasso - r2_loo))


# -----------------------------------------------------------------------------
# 6.6  Annotate selected indicators with labels and domains
# -----------------------------------------------------------------------------
lasso_df_annotated <- lasso_df %>%
  mutate(
    Description = INDICATOR_LABELS[Indicator],
    Description = if_else(is.na(Description), Indicator, Description),
    Domain      = INDICATOR_DOMAIN_MAP[Description],
    Domain      = if_else(is.na(Domain), "Other", Domain)
  )


# -----------------------------------------------------------------------------
# 6.7  Write outputs
# -----------------------------------------------------------------------------
write_csv(lasso_df_annotated,
          file.path(PATH_PROCESSED, "lasso_results.csv"))
write_csv(data.frame(
  R2_in_sample    = round(r2_lasso, 4),
  R2_LOO_CV       = round(r2_loo,   4),
  MAE_LOO_CV      = round(mae,      4),
  overfitting_gap = round(r2_lasso - r2_loo, 4),
  lambda_min      = round(cv_lasso$lambda.min, 4),
  n_obs           = length(y),
  n_predictors    = ncol(X),
  n_selected      = nrow(lasso_df)
), file.path(PATH_PROCESSED, "lasso_performance.csv"))

write_csv(data.frame(
  COUNTRY_REGION = lasso_data$COUNTRY_REGION,
  DHMI_observed  = round(y,        2),
  DHMI_predicted = round(loo_pred, 2),
  residual_LOO   = round(y - loo_pred, 2)
), file.path(PATH_PROCESSED, "lasso_loo_predictions.csv"))

message("06_lasso_regression.R: wrote lasso_results.csv, lasso_performance.csv, lasso_loo_predictions.csv")
