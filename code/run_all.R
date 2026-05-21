# =============================================================================
# run_all.R — Master orchestrator for the DHMI analysis pipeline
# =============================================================================
#
# Purpose : Execute the full DHMI analysis pipeline end-to-end and regenerate
#           every figure, table and statistic reported in the BIJ paper from
#           the raw WHO 2023 data with a single command.
#
# Usage   : From the project root,
#               Rscript code/run_all.R
#           or, interactively in R/RStudio:
#               source("code/run_all.R")
#
# Pipeline:
#   00_setup.R                  — load packages and constants  (sourced by each step)
#   01_data_preparation.R       — recode WHO raw data, restrict to Europe
#   02_dhmi_construction.R      — compute DHMI_equal and DHMI_scaled
#   03_robustness_protocol.R    — weight perturbation, missing-data sensitivity
#   04_cluster_analysis.R       — k-means clustering and cluster labelling
#   05_spearman_fdr.R           — pairwise correlations with BH-FDR correction
#   06_lasso_regression.R       — LASSO with 10-fold + LOO-CV
#   07_mann_whitney_fdr.R       — MW U tests with FDR + cross-method convergence
#   08_external_validity.R      — DESI and WHO UHC convergent validity
#   99_figures_tables.R         — regenerate all figures and Excel tables
#
# Note    : Each step is designed to be runnable in isolation. The pipeline is
#           idempotent — re-running over already-written CSVs simply overwrites
#           them with the same content (modulo any code changes).
#
# Reproducibility seeds:
#   - k-means          (04): set.seed(123)
#   - LASSO CV         (06): set.seed(42)
#   - Weight perturbation (03): set.seed(42)
# =============================================================================

# -----------------------------------------------------------------------------
# Auto-locate the project root (works from any working directory)
# -----------------------------------------------------------------------------
.locate_run_all <- function() {
  # (1) interactive source()
  this_file <- tryCatch(sys.frames()[[1]]$ofile, error = function(e) NULL)
  if (!is.null(this_file) && file.exists(this_file)) {
    return(normalizePath(this_file))
  }
  # (2) Rscript invocation
  args <- commandArgs(trailingOnly = FALSE)
  m <- grep("^--file=", args, value = TRUE)
  if (length(m) > 0) {
    return(normalizePath(sub("^--file=", "", m[1])))
  }
  # (3) fallback: search upwards for renv.lock
  d <- getwd()
  for (i in 1:5) {
    if (file.exists(file.path(d, "renv.lock"))) return(file.path(d, "code", "run_all.R"))
    parent <- dirname(d); if (parent == d) break; d <- parent
  }
  NA_character_
}

.this_file    <- .locate_run_all()
.project_root <- if (!is.na(.this_file)) dirname(dirname(.this_file)) else getwd()

if (normalizePath(getwd(), winslash = "/") !=
    normalizePath(.project_root, winslash = "/")) {
  message("Setting working directory to project root: ", .project_root)
  setwd(.project_root)
}

project_root <- getwd()
message("=== run_all.R — DHMI analysis pipeline ===")
message("Working directory: ", project_root)


# -----------------------------------------------------------------------------
# Pipeline steps (in order)
# -----------------------------------------------------------------------------
steps <- c(
  "code/01_data_preparation.R",
  "code/02_dhmi_construction.R",
  "code/03_robustness_protocol.R",
  "code/04_cluster_analysis.R",
  "code/05_spearman_fdr.R",
  "code/06_lasso_regression.R",
  "code/07_mann_whitney_fdr.R",
  "code/08_external_validity.R",
  "code/99_figures_tables.R"
)

start_time <- Sys.time()
for (step in steps) {
  message("\n--- Running ", step, " ---")
  # Each script runs in its own isolated environment so that variables
  # created in one step cannot pollute subsequent steps.
  source(step, echo = FALSE, local = new.env(parent = globalenv()))
}
end_time <- Sys.time()

message("\n=== Pipeline complete ===")
message("Elapsed: ",
        round(as.numeric(difftime(end_time, start_time, units = "secs")), 1),
        " seconds.")
message("Outputs:")
message("  data/processed/ — all intermediate CSVs")
message("  outputs/figures/ — all PNG figures (300 dpi)")
message("  outputs/tables/  — all XLSX summary tables")
