# =============================================================================
# 01_data_preparation.R — Load WHO raw survey, recode, restrict to Europe
# =============================================================================
#
# Purpose : Read the raw WHO 2023 indicator dataset, recode categorical
#           responses to a numeric adoption scale (-4..3), pivot to wide
#           format, and restrict to the 53 Member States of the WHO European
#           Region. Also computes per-indicator and per-country missingness.
#
# Inputs  : data/raw/DH Data (table).csv   — original WHO 2023 long-format CSV
#
# Outputs : data/processed/indicators_recoded.csv   — 53 × ~74 wide matrix
#           data/processed/missingness_by_indicator.csv
#           data/processed/missingness_by_country.csv
#           data/processed/excluded_countries.csv   — countries with >= 20% missing
#
# Dependencies : 00_setup.R
# =============================================================================

source("code/00_setup.R")


# -----------------------------------------------------------------------------
# 1.1  Load raw WHO data
# -----------------------------------------------------------------------------
raw_path <- file.path(PATH_RAW, "DH Data (table).csv")
if (!file.exists(raw_path)) {
  stop(sprintf("Raw WHO data not found at %s. ",
               "Populate data/raw/ before running this script."), raw_path)
}

df_raw <- read_csv(raw_path, show_col_types = FALSE)


# -----------------------------------------------------------------------------
# 1.2  Recode and pivot to wide format
# -----------------------------------------------------------------------------
df_long <- df_raw %>%
  filter(`Measure code` %in% ALL_INDICATORS) %>%
  dplyr::select(COUNTRY_REGION, YEAR, `Measure code`, DH_FACT_ATT) %>%
  mutate(DH_FACT_ATT = recode_adoption(DH_FACT_ATT))

df_wide <- df_long %>%
  pivot_wider(names_from = `Measure code`, values_from = DH_FACT_ATT)


# -----------------------------------------------------------------------------
# 1.3  Restrict to WHO European Region (53 Member States)
# -----------------------------------------------------------------------------
df_europe <- df_wide %>%
  filter(COUNTRY_REGION %in% WHO_EUR_COUNTRIES)

message(sprintf("Loaded: %d countries × %d indicators",
                nrow(df_europe), length(ALL_INDICATORS)))


# -----------------------------------------------------------------------------
# 1.4  Missing-data diagnostics
# -----------------------------------------------------------------------------
indicator_missing <- df_europe %>%
  dplyr::select(starts_with("DH_")) %>%
  summarise(across(everything(), ~ mean(is.na(.)) * 100)) %>%
  pivot_longer(everything(),
               names_to  = "Indicator",
               values_to = "Missing_pct") %>%
  arrange(desc(Missing_pct))

country_missing <- df_europe %>%
  dplyr::select(COUNTRY_REGION, starts_with("DH_")) %>%
  rowwise() %>%
  mutate(Missing_pct = mean(is.na(c_across(starts_with("DH_")))) * 100) %>%
  ungroup() %>%
  dplyr::select(COUNTRY_REGION, Missing_pct) %>%
  arrange(desc(Missing_pct))

excluded_countries <- country_missing %>%
  filter(Missing_pct >= 20) %>%
  pull(COUNTRY_REGION)

message(sprintf("Indicators with any missing: %d / %d",
                sum(indicator_missing$Missing_pct > 0),
                nrow(indicator_missing)))
message(sprintf("Countries excluded (>= 20%% missing): %d — %s",
                length(excluded_countries),
                paste(excluded_countries, collapse = ", ")))


# -----------------------------------------------------------------------------
# 1.5  Write outputs
# -----------------------------------------------------------------------------
write_csv(df_europe,
          file.path(PATH_PROCESSED, "indicators_recoded.csv"))
write_csv(indicator_missing,
          file.path(PATH_PROCESSED, "missingness_by_indicator.csv"))
write_csv(country_missing,
          file.path(PATH_PROCESSED, "missingness_by_country.csv"))
write_csv(data.frame(COUNTRY_REGION = excluded_countries),
          file.path(PATH_PROCESSED, "excluded_countries.csv"))

message("01_data_preparation.R: wrote 4 CSV files to ", PATH_PROCESSED)
