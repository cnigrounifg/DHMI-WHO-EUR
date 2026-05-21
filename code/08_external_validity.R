# =============================================================================
# 08_external_validity.R — Convergent validity testing against DESI and UHC
# =============================================================================
#
# Purpose : Procedure (iv) of the four-procedure robustness protocol. Spearman
#           rank correlations of the DHMI against two external validators:
#           - DESI 2023 'Access to e-Health Records' sub-index (citizen-side
#             service utilisation; EU-27 only)
#           - WHO UHC Service Coverage Index (latest available year, expected
#             2023; health system performance capacity; covers the full 53
#             WHO European Region MS).
#
#           The directional contrast between the two validators is itself
#           analytically informative: DHMI is theoretically governance-side
#           and should correlate positively with UHC capacity and only weakly
#           (or not at all) with DESI utilisation.
#
# Inputs  : data/external_validators/desi_aehr-total-egov_score-desi_2023-facts.csv
#               (EC Digital Decade DESI 2023; CSV with columns: period, country,
#                indicator, breakdown, unit, value, flags, reference_period, remarks)
#           data/external_validators/01_WHO_UHC.csv
#               (WHO Global Health Observatory full export of indicator
#                UHC Service Coverage Index, SDG 3.8.1; standard GHO schema)
#           data/processed/cluster_assignments.csv
#
# Outputs : data/processed/external_validity_DESI.csv
#               (n = 27 EU joined dataset: DHMI vs DESI eHealth + cluster)
#           data/processed/external_validity_UHC.csv
#               (n = 53 joined dataset: DHMI vs UHC index + cluster)
#           data/processed/external_validity_summary.csv
#               (Spearman ρ + p + n for each validator)
#
# Data notes
#   - DESI file is CSV (not the originally expected XLSX). Country codes are
#     ISO2 with the EU convention "EL" for Greece. A crosswalk to ISO3 is
#     applied below.
#   - WHO UHC data are filtered to the latest available year per country
#     (IsLatestYear == TRUE) and to ParentLocationCode == "EUR". As of the
#     present extract the latest data year is 2023 (not 2021 as referenced in
#     §3.4 of the BIJ paper). Co-authors should decide whether to (a) update
#     the BIJ paper figures using the 2023 data, or (b) substitute the
#     2021-vintage dataset before submission.
#
# Dependencies : 00_setup.R, 04_cluster_analysis.R
# =============================================================================

source("code/00_setup.R")


# -----------------------------------------------------------------------------
# 8.1  Load DHMI scores with cluster labels
# -----------------------------------------------------------------------------
country_maturity_clean <- read_csv(
  file.path(PATH_PROCESSED, "cluster_assignments.csv"),
  show_col_types = FALSE
)


# -----------------------------------------------------------------------------
# 8.2  External validator A — DESI 2023 eHealth Records (CSV)
# -----------------------------------------------------------------------------
desi_path <- file.path(PATH_EXTERNAL,
                      "desi_aehr-total-egov_score-desi_2023-facts.csv")

val_corr_desi <- NULL
validation_df <- NULL

if (file.exists(desi_path)) {
  desi_raw <- read_csv(desi_path, show_col_types = FALSE)

  # Filter to the Access-to-eHealth-Records indicator in the 2023 reporting
  # year, for the total (no breakdown) e-government score.
  desi <- desi_raw %>%
    filter(period      == "desi_2023",
           indicator   == "desi_aehr",
           breakdown   == "total",
           unit        == "egov_score",
           country     != "EU") %>%
    dplyr::select(country, DESI_eHealth = value) %>%
    mutate(DESI_eHealth = as.numeric(DESI_eHealth))

  # ISO2 → ISO3 crosswalk for EU-27.
  # Note: 'EL' is the EU-statistical 2-letter code for Greece (ISO2 'GR').
  country_iso3 <- tibble::tribble(
    ~iso2, ~iso3,
    "AT", "AUT",  "BE", "BEL",  "BG", "BGR",  "HR", "HRV",  "CY", "CYP",
    "CZ", "CZE",  "DK", "DNK",  "EE", "EST",  "FI", "FIN",  "FR", "FRA",
    "DE", "DEU",  "EL", "GRC",  "GR", "GRC",  "HU", "HUN",  "IE", "IRL",
    "IT", "ITA",  "LV", "LVA",  "LT", "LTU",  "LU", "LUX",  "MT", "MLT",
    "NL", "NLD",  "PL", "POL",  "PT", "PRT",  "RO", "ROU",  "SK", "SVK",
    "SI", "SVN",  "ES", "ESP",  "SE", "SWE"
  )

  validation_df <- country_maturity_clean %>%
    inner_join(desi %>% left_join(country_iso3, by = c("country" = "iso2")),
               by = c("COUNTRY_REGION" = "iso3")) %>%
    filter(!is.na(DESI_eHealth), !is.na(DHMI_scaled))

  message(sprintf("Validation overlap (WHO ∩ DESI): %d countries",
                  nrow(validation_df)))

  val_corr_desi <- cor.test(validation_df$DHMI_scaled,
                            validation_df$DESI_eHealth,
                            method = "spearman")
  message(sprintf(
    "Convergent validity vs DESI — Spearman ρ = %.3f (p = %.4f, n = %d)",
    val_corr_desi$estimate, val_corr_desi$p.value, nrow(validation_df)
  ))

  write_csv(validation_df,
            file.path(PATH_PROCESSED, "external_validity_DESI.csv"))
} else {
  message(sprintf("DESI file not found at %s — skipping.", desi_path))
}


# -----------------------------------------------------------------------------
# 8.3  External validator B — WHO UHC Service Coverage Index (WHO GHO export)
# -----------------------------------------------------------------------------
# The file follows the standard WHO Global Health Observatory CSV schema with
# 34+ columns. The fields used are:
#   - ParentLocationCode   ("EUR" for WHO European Region)
#   - SpatialDimValueCode  (ISO3 country code)
#   - IsLatestYear         (TRUE/FALSE; we keep only the latest year per country)
#   - FactValueNumeric     (the UHC index, 0–100 scale)
#   - Period               (the year of the observation)
uhc_path <- file.path(PATH_EXTERNAL, "01_WHO_UHC.csv")
val_corr_uhc <- NULL
validation_uhc <- NULL

if (file.exists(uhc_path)) {
  uhc_raw <- read_csv(uhc_path, show_col_types = FALSE)

  uhc <- uhc_raw %>%
    filter(ParentLocationCode == "EUR",
           IsLatestYear       == TRUE,
           !is.na(FactValueNumeric)) %>%
    dplyr::select(COUNTRY_REGION = SpatialDimValueCode,
                  UHC_index      = FactValueNumeric,
                  UHC_data_year  = Period) %>%
    mutate(UHC_index = as.numeric(UHC_index))

  # In case a country has multiple "latest" rows (rare WHO GHO artefact), keep
  # the maximum-year row.
  uhc <- uhc %>%
    group_by(COUNTRY_REGION) %>%
    slice_max(UHC_data_year, n = 1, with_ties = FALSE) %>%
    ungroup()

  message(sprintf("WHO UHC EUR countries with latest data: %d (data year span: %d–%d)",
                  nrow(uhc), min(uhc$UHC_data_year), max(uhc$UHC_data_year)))

  validation_uhc <- country_maturity_clean %>%
    inner_join(uhc, by = "COUNTRY_REGION") %>%
    filter(!is.na(UHC_index), !is.na(DHMI_scaled))

  val_corr_uhc <- cor.test(validation_uhc$DHMI_scaled,
                           validation_uhc$UHC_index,
                           method = "spearman")
  message(sprintf(
    "Convergent validity vs WHO UHC — Spearman ρ = %.3f (p = %.4f, n = %d)",
    val_corr_uhc$estimate, val_corr_uhc$p.value, nrow(validation_uhc)
  ))

  write_csv(validation_uhc,
            file.path(PATH_PROCESSED, "external_validity_UHC.csv"))
} else {
  message(sprintf("WHO UHC file not found at %s.", uhc_path))
}


# -----------------------------------------------------------------------------
# 8.4  Summary CSV
# -----------------------------------------------------------------------------
summary_rows <- list()
if (!is.null(val_corr_desi)) {
  summary_rows[[length(summary_rows) + 1]] <- data.frame(
    validator    = "DESI_eHealth_2023",
    spearman_rho = round(val_corr_desi$estimate, 3),
    p_value      = round(val_corr_desi$p.value,  4),
    n            = nrow(validation_df),
    notes        = "Citizen-side utilisation; EU-27 only; reference period 2022."
  )
}
if (!is.null(val_corr_uhc)) {
  summary_rows[[length(summary_rows) + 1]] <- data.frame(
    validator    = sprintf("WHO_UHC_%d",
                           max(validation_uhc$UHC_data_year, na.rm = TRUE)),
    spearman_rho = round(val_corr_uhc$estimate, 3),
    p_value      = round(val_corr_uhc$p.value,  4),
    n            = nrow(validation_uhc),
    notes        = "Health system performance capacity; full WHO European Region; latest available year per country."
  )
}

if (length(summary_rows) > 0) {
  write_csv(bind_rows(summary_rows),
            file.path(PATH_PROCESSED, "external_validity_summary.csv"))
  message("08_external_validity.R: wrote external_validity_summary.csv")
} else {
  message("08_external_validity.R: no external validators available; nothing written.")
}
