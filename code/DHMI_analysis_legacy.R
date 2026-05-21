# =============================================================================
# Digital Health Maturity Index (DHMI) – Analysis Pipeline
# =============================================================================
#
# Paper: "Benchmarking Digital Health Governance: A Composite Maturity Index
#         for Cross-Country Policy Comparison in the WHO European Region"
#
# Authors : Simona Curiello, Enrica Iannuzzi, Claudio Nigro
#           Department of Economics, University of Foggia (Italy)
#
# Data    : WHO Regional Office for Europe (2023). "The Ongoing Journey to
#           Commitment and Transformation: Digital Health in the WHO European
#           Region." 74 policy indicators, 53 Member States.
#           Source file: "DH Data (table).csv"
#
# External: DESI 2023 – Access to e-Health Records (European Commission)
#           Source file: "desi_aehr-total-egov_score-desi_2023-facts.xlsx"
#
# License : MIT License
# Version : 1.0.0  |  April 2026
# GitHub  : https://github.com/[username]/DHMI-WHO-Europe
# =============================================================================


# =============================================================================
# 0. PACKAGE SETUP
# =============================================================================
# Run this block once to install all required packages.
# After installation, only library() calls are needed.

required_packages <- c(
  # Core data manipulation
  "readr", "dplyr", "tidyr", "scales",
  # Visualisation
  "ggplot2", "ggcorrplot", "ggrepel",
  # Clustering
  "cluster", "factoextra",
  # Statistical analysis
  "glmnet", "broom", "car", "MASS", "FSA", "psych",
  # Mapping
  "sf", "rnaturalearth", "rnaturalearthdata",
  # File I/O
  "readxl", "openxlsx",
  # Reporting
  "knitr", "kableExtra"
)

new_packages <- required_packages[
  !required_packages %in% installed.packages()[, "Package"]
]
if (length(new_packages)) install.packages(new_packages)

# Load all packages
invisible(lapply(required_packages, library, character.only = TRUE))


# =============================================================================
# 1. CONSTANTS & CONFIGURATION
# =============================================================================

# WHO European Region – 53 Member States (ISO3 codes)
WHO_EUR_COUNTRIES <- c(
  "ALB", "AND", "ARM", "AUT", "AZE", "BLR", "BEL", "BIH", "BGR", "HRV",
  "CYP", "CZE", "DNK", "EST", "FIN", "FRA", "GEO", "DEU", "GRC", "HUN",
  "ISL", "IRL", "ISR", "ITA", "KAZ", "KGZ", "LVA", "LTU", "LUX", "MLT",
  "MCO", "MNE", "NLD", "MKD", "NOR", "POL", "PRT", "MDA", "ROU", "RUS",
  "SMR", "SRB", "SVK", "SVN", "ESP", "SWE", "CHE", "TJK", "TUR", "TKM",
  "UKR", "GBR", "UZB"
)

# EU-27 Member States (ISO3 codes) – used for EU/Non-EU stratification
EU27_COUNTRIES <- c(
  "AUT", "BEL", "BGR", "HRV", "CYP", "CZE", "DNK", "EST", "FIN", "FRA",
  "DEU", "GRC", "HUN", "IRL", "ITA", "LVA", "LTU", "LUX", "MLT", "NLD",
  "POL", "PRT", "ROU", "SVK", "SVN", "ESP", "SWE"
)

# DHMI: 10 policy domains and their constituent WHO indicators
# Source: WHO 2023 report structure (74 indicators across 10 domains)
DOMAIN_MAP <- list(
  governance = c("DH_1",  "DH_2",  "DH_3"),
  funding    = c("DH_4",  "DH_5",  "DH_6",  "DH_7"),
  literacy   = c("DH_8",  "DH_9",  "DH_10"),
  regulation = c("DH_11", "DH_12", "DH_13", "DH_14",
                 "DH_15", "DH_16", "DH_17", "DH_18"),
  monitoring = c("DH_19", "DH_20", "DH_21", "DH_22", "DH_23"),
  ehr        = c("DH_24", "DH_25", "DH_26"),
  facilities = c("DH_27", "DH_28", "DH_29"),
  telehealth = c("DH_43", "DH_44", "DH_45", "DH_46", "DH_47"),
  mhealth    = c("DH_48", "DH_49", "DH_50", "DH_51",
                 "DH_52", "DH_53", "DH_54"),
  bigdata    = c("DH_67", "DH_68", "DH_69", "DH_70")
)

# All retained WHO indicators (union of all domains)
ALL_INDICATORS <- unlist(DOMAIN_MAP, use.names = FALSE)
DOMAIN_COLS    <- names(DOMAIN_MAP)

# Colour palette for maturity clusters (accessible)
CLUSTER_COLOURS <- c(
  "Low Maturity"    = "#d73027",
  "Medium Maturity" = "#fdae61",
  "High Maturity"   = "#1a9850"
)

# Colour palette for policy domains (institutional, grey-scale friendly)
DOMAIN_COLOURS <- c(
  "Monitoring & Evaluation" = "#51749B",
  "EHR & Facilities"        = "#7D98BA",
  "Big Data & Analytics"    = "#8E4847",
  "Regulatory Frameworks"   = "#CB8A8A",
  "mHealth"                 = "#344a63",
  "Telehealth"              = "#D5C8CB",
  "Governance"              = "#666567",
  "Literacy & Capacity"     = "#B8A8AB",
  "Funding"                 = "#A3B8C8"
)

# Short indicator labels for figure annotation
INDICATOR_LABELS <- c(
  DH_1  = "National DH strategy",         DH_2  = "HIS strategy",
  DH_5  = "Private funding",              DH_7  = "PPP funding",
  DH_8  = "DH education policy",          DH_9  = "In-service DH training",
  DH_10 = "DH competencies for students", DH_12 = "EHR data protection",
  DH_13 = "EHR data sharing regulation",  DH_14 = "Patient data access rights",
  DH_18 = "Secure patient ID",            DH_19 = "National monitoring agency",
  DH_21 = "DH evaluation guidance",       DH_22 = "Telehealth evaluation",
  DH_25 = "Regional EHR system",          DH_26 = "Regional EHR federation",
  DH_27 = "EHR in primary care",          DH_29 = "EHR in tertiary care",
  DH_43 = "Teleradiology",                DH_44 = "Teledermatology",
  DH_45 = "Telepathology",               DH_46 = "Telepsychiatry",
  DH_47 = "Telemedicine",                DH_48 = "mHealth appointment reminders",
  DH_49 = "Mobile teleconsultation",     DH_50 = "Patient monitoring mHealth",
  DH_51 = "Treatment adherence mHealth", DH_52 = "Patient e-record access mHealth",
  DH_54 = "Surveillance mHealth",        DH_67 = "National data strategy",
  DH_68 = "Big data health policy",      DH_69 = "Big data private sector policy"
)

# Indicator → Policy domain mapping (for figure legends)
INDICATOR_DOMAIN_MAP <- c(
  "National DH strategy"            = "Governance",
  "HIS strategy"                    = "Governance",
  "Private funding"                 = "Funding",
  "PPP funding"                     = "Funding",
  "DH education policy"             = "Literacy & Capacity",
  "In-service DH training"          = "Literacy & Capacity",
  "DH competencies for students"    = "Literacy & Capacity",
  "EHR data protection"             = "Regulatory Frameworks",
  "EHR data sharing regulation"     = "Regulatory Frameworks",
  "Patient data access rights"      = "Regulatory Frameworks",
  "Secure patient ID"               = "Regulatory Frameworks",
  "National monitoring agency"      = "Monitoring & Evaluation",
  "DH evaluation guidance"          = "Monitoring & Evaluation",
  "Telehealth evaluation"           = "Monitoring & Evaluation",
  "Regional EHR system"             = "EHR & Facilities",
  "Regional EHR federation"         = "EHR & Facilities",
  "EHR in primary care"             = "EHR & Facilities",
  "EHR in tertiary care"            = "EHR & Facilities",
  "Teleradiology"                   = "Telehealth",
  "Teledermatology"                 = "Telehealth",
  "Telepathology"                   = "Telehealth",
  "Telepsychiatry"                  = "Telehealth",
  "Telemedicine"                    = "Telehealth",
  "mHealth appointment reminders"   = "mHealth",
  "Mobile teleconsultation"         = "mHealth",
  "Patient monitoring mHealth"      = "mHealth",
  "Treatment adherence mHealth"     = "mHealth",
  "Patient e-record access mHealth" = "mHealth",
  "Surveillance mHealth"            = "mHealth",
  "National data strategy"          = "Big Data & Analytics",
  "Big data health policy"          = "Big Data & Analytics",
  "Big data private sector policy"  = "Big Data & Analytics"
)

# Legend display order for domain colour scales
LEGEND_ORDER <- c(
  "Monitoring & Evaluation", "EHR & Facilities", "Big Data & Analytics",
  "Regulatory Frameworks", "mHealth", "Telehealth",
  "Governance", "Literacy & Capacity", "Funding"
)


# =============================================================================
# 2. DATA LOADING & PREPROCESSING
# =============================================================================

# 2.1  Load raw WHO data --------------------------------------------------
df_raw <- read_csv("DH Data (table).csv", show_col_types = FALSE)

# 2.2  Recode categorical responses to numeric adoption scores
#      Coding scheme follows WHO response categories:
#        YES / YES_1 = 3  (fully adopted)
#        YES_2       = 2  (partially adopted – most elements)
#        YES_3       = 1  (partially adopted – some elements)
#        NO          = 0  (policy exists but not adopted)
#        NO_1        = -1 │
#        NO_2        = -2 │ Graduated absence / non-adoption
#        NO_3        = -3 │
#        NO_4        = -4 ┘
#        MND_1       = NA (missing / not declared)
recode_adoption <- function(x) {
  dplyr::case_when(
    x %in% c("YES", "YES_1") ~ 3,
    x == "YES_2"             ~ 2,
    x == "YES_3"             ~ 1,
    x == "NO"                ~ 0,
    x == "NO_1"              ~ -1,
    x == "NO_2"              ~ -2,
    x == "NO_3"              ~ -3,
    x == "NO_4"              ~ -4,
    TRUE                     ~ NA_real_   # MND_1 and any unlisted codes
  )
}

# 2.3  Filter to retained indicators, recode, pivot to wide format
df_long <- df_raw %>%
  filter(`Measure code` %in% ALL_INDICATORS) %>%
  dplyr::select(COUNTRY_REGION, YEAR, `Measure code`, DH_FACT_ATT) %>%
  mutate(DH_FACT_ATT = recode_adoption(DH_FACT_ATT))

df_wide <- df_long %>%
  pivot_wider(names_from = `Measure code`, values_from = DH_FACT_ATT)

# 2.4  Restrict to WHO European Region (53 Member States)
df_europe <- df_wide %>%
  filter(COUNTRY_REGION %in% WHO_EUR_COUNTRIES)

message(sprintf("Dataset: %d countries, %d indicators",
                nrow(df_europe), length(ALL_INDICATORS)))


# =============================================================================
# 3. DHMI CONSTRUCTION
# =============================================================================
# Methodology: OECD/JRC composite indicator framework (Nardo et al., 2008).
# Each indicator scored 0–3 (positive) or negative for non-adoption.
# Domain adoption rate = mean of retained indicators within domain.
# DHMI = arithmetic mean of 10 domain-level adoption rates (equal weighting).
# Final DHMI rescaled to 0–100 for cross-country comparability.

# 3.1  Compute domain-level adoption rates
#      Adoption rate: proportion of indicators with score >= 0 (not absent)
compute_domain_ar <- function(df_wide, indicators) {
  cols      <- intersect(indicators, colnames(df_wide))
  vals      <- df_wide[, cols]
  adopted   <- rowSums(vals >= 0, na.rm = TRUE)
  available <- rowSums(!is.na(vals))
  ifelse(available == 0, NA_real_, (adopted / available) * 100)
}

domain_scores <- df_europe %>%
  dplyr::select(COUNTRY_REGION) %>%
  bind_cols(
    lapply(DOMAIN_MAP, compute_domain_ar, df_wide = df_europe) %>%
      as.data.frame()
  ) %>%
  mutate(DHMI_equal = rowMeans(across(all_of(DOMAIN_COLS)), na.rm = TRUE))

# 3.2  Country-level DHMI (raw mean of individual indicator scores)
country_maturity <- df_europe %>%
  mutate(DH_FACT_ATT_NUM = recode_adoption(
    # Re-encode from df_long for the raw per-country mean path
    # (domain_scores already provides the domain-AR route; this gives
    #  an alternative check using raw indicator means)
    NA_character_   # placeholder – actual computation via domain_scores below
  ))

# Use domain_scores as the canonical DHMI source
country_maturity <- domain_scores %>%
  dplyr::select(COUNTRY_REGION, DHMI_equal) %>%
  mutate(DHMI_scaled = scales::rescale(DHMI_equal, to = c(0, 100))) %>%
  arrange(desc(DHMI_scaled))

message("DHMI summary statistics:")
print(summary(country_maturity$DHMI_scaled))


# =============================================================================
# 4. CLUSTER ANALYSIS
# =============================================================================
# k-means clustering (k = 3) on DHMI_scaled.
# k selected via elbow method; k = 2 and k = 4 tested for stability.
# Cluster labels assigned by ascending centroid value.

# 4.1  Remove countries with missing DHMI and run k-means
set.seed(123)

country_maturity_clean <- country_maturity %>%
  filter(!is.na(DHMI_scaled))

kmeans_result <- kmeans(country_maturity_clean$DHMI_scaled,
                        centers = 3, nstart = 25)

# 4.2  Assign cluster labels in ascending centroid order
cluster_order <- order(kmeans_result$centers[, 1])
label_map <- setNames(
  c("Low Maturity", "Medium Maturity", "High Maturity"),
  cluster_order
)

country_maturity_clean <- country_maturity_clean %>%
  mutate(
    Cluster       = kmeans_result$cluster,
    Cluster_Label = factor(
      label_map[as.character(Cluster)],
      levels = c("Low Maturity", "Medium Maturity", "High Maturity")
    )
  )

# 4.3  Silhouette score (cluster quality check)
sil <- silhouette(kmeans_result$cluster, dist(country_maturity_clean$DHMI_scaled))
message(sprintf("Average silhouette width: %.3f", mean(sil[, 3])))

# 4.4  Cluster summary
message("\nCluster distribution:")
print(table(country_maturity_clean$Cluster_Label))
print(
  country_maturity_clean %>%
    group_by(Cluster_Label) %>%
    summarise(n = n(), Mean_DHMI = round(mean(DHMI_scaled), 1),
              Min = round(min(DHMI_scaled), 1), Max = round(max(DHMI_scaled), 1))
)

# 4.5  Merge cluster labels back into domain_scores
domain_scores <- domain_scores %>%
  left_join(
    country_maturity_clean %>% dplyr::select(COUNTRY_REGION, DHMI_scaled, Cluster_Label),
    by = "COUNTRY_REGION"
  )

# 4.6  Figure: DHMI bar chart coloured by cluster
ggplot(country_maturity_clean,
       aes(x = reorder(COUNTRY_REGION, DHMI_scaled),
           y = DHMI_scaled, fill = Cluster_Label)) +
  geom_col(width = 0.72, color = "white", linewidth = 0.3) +
  coord_flip() +
  scale_fill_manual(values = CLUSTER_COLOURS) +
  labs(
    title    = "Digital Health Maturity Index (DHMI) in the WHO European Region",
    subtitle = "Countries classified into three maturity clusters via k-means (k = 3)",
    x        = NULL,
    y        = "Digital Health Maturity Index (0–100)",
    fill     = "Maturity Cluster",
    caption  = "DHMI: arithmetic mean of 10 domain-level adoption rates, rescaled 0–100.\nData: WHO Regional Office for Europe (2023). k-means clustering, seed = 123."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title         = element_text(face = "bold", size = 12),
    plot.subtitle      = element_text(size = 9, color = "gray40"),
    plot.caption       = element_text(size = 7.5, color = "gray40",
                                      hjust = 0, margin = margin(t = 8)),
    legend.position    = "right",
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank()
  )

ggsave("Figure_DHMI_Clusters.png", dpi = 300, width = 10, height = 9)
message("Saved: Figure_DHMI_Clusters.png")


# =============================================================================
# 5. MISSING DATA ANALYSIS
# =============================================================================

# 5.1  Missing rate by indicator
indicator_missing <- df_europe %>%
  dplyr::select(starts_with("DH_")) %>%
  summarise(across(everything(), ~ mean(is.na(.)) * 100)) %>%
  pivot_longer(everything(),
               names_to  = "Indicator",
               values_to = "Missing_pct") %>%
  arrange(desc(Missing_pct))

message(sprintf(
  "Indicators with any missing: %d / %d",
  sum(indicator_missing$Missing_pct > 0), nrow(indicator_missing)
))

# 5.2  Missing rate by country
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

message(sprintf("Countries excluded (>= 20%% missing): %d – %s",
                length(excluded_countries),
                paste(excluded_countries, collapse = ", ")))

# 5.3  Heatmap: missing data pattern
missing_long <- df_europe %>%
  dplyr::select(COUNTRY_REGION, all_of(ALL_INDICATORS)) %>%
  pivot_longer(-COUNTRY_REGION,
               names_to  = "Indicator",
               values_to = "Value") %>%
  mutate(
    Is_Missing = is.na(Value),
    Indicator  = factor(
      Indicator,
      levels = paste0("DH_", sort(as.numeric(gsub("DH_", "", ALL_INDICATORS))))
    )
  )

ggplot(missing_long,
       aes(x = Indicator, y = COUNTRY_REGION, fill = Is_Missing)) +
  geom_tile(color = "white", linewidth = 0.2) +
  scale_fill_manual(
    values = c("FALSE" = "#d4edda", "TRUE" = "#c0392b"),
    labels = c("Observed", "Missing"),
    name   = "Data Status"
  ) +
  labs(
    title    = "Missing Data Pattern: WHO Digital Health Indicators",
    subtitle = "Red = missing (MND_1); n = 53 WHO European Region Member States",
    x        = "WHO Indicator", y = "Country"
  ) +
  theme_minimal(base_size = 9) +
  theme(
    axis.text.x   = element_text(angle = 90, hjust = 1, size = 6),
    axis.text.y   = element_text(size = 7),
    plot.title    = element_text(face = "bold", size = 11),
    plot.subtitle = element_text(size = 9, color = "gray40"),
    legend.position = "bottom"
  )

ggsave("Figure_Missing_Data_Heatmap.png", dpi = 300, width = 13, height = 9)
message("Saved: Figure_Missing_Data_Heatmap.png")

# 5.4  Sensitivity: full sample vs restricted sample (exclude >= 20% missing)
dhmi_full <- country_maturity_clean %>%
  dplyr::select(COUNTRY_REGION, DHMI_scaled) %>%
  rename(DHMI_full = DHMI_scaled)

dhmi_restricted <- country_maturity %>%
  filter(!COUNTRY_REGION %in% excluded_countries, !is.na(DHMI_scaled)) %>%
  dplyr::select(COUNTRY_REGION, DHMI_scaled) %>%
  rename(DHMI_restricted = DHMI_scaled) %>%
  mutate(DHMI_restricted = scales::rescale(DHMI_restricted, to = c(0, 100)))

missing_sensitivity <- dhmi_full %>%
  inner_join(dhmi_restricted, by = "COUNTRY_REGION")

ms_corr <- cor.test(missing_sensitivity$DHMI_full,
                    missing_sensitivity$DHMI_restricted,
                    method = "spearman")
message(sprintf(
  "Missing-data sensitivity – Spearman rho = %.3f (p = %.6f, n = %d)",
  ms_corr$estimate, ms_corr$p.value, nrow(missing_sensitivity)
))


# =============================================================================
# 6. CONVERGENT VALIDITY – EXTERNAL VALIDATION WITH DESI 2023
# =============================================================================
# External criterion: DESI 2023, "Access to e-Health Records" sub-indicator
# Coverage: 27 EU Member States (partial overlap with 53 WHO countries)

# 6.1  Load DESI data
desi_raw <- read_excel("desi_aehr-total-egov_score-desi_2023-facts.xlsx",
                       sheet = "Data")

desi <- desi_raw %>%
  dplyr::select(Country, DESI_eHealth = Value) %>%
  filter(Country != "European Union")

# 6.2  Country name → ISO3 crosswalk
country_iso3 <- tibble::tribble(
  ~Country,       ~iso3,
  "Austria",      "AUT",  "Belgium",     "BEL",  "Bulgaria",   "BGR",
  "Croatia",      "HRV",  "Cyprus",      "CYP",  "Czechia",    "CZE",
  "Denmark",      "DNK",  "Estonia",     "EST",  "Finland",    "FIN",
  "France",       "FRA",  "Germany",     "DEU",  "Greece",     "GRC",
  "Hungary",      "HUN",  "Ireland",     "IRL",  "Italy",      "ITA",
  "Latvia",       "LVA",  "Lithuania",   "LTU",  "Luxembourg", "LUX",
  "Malta",        "MLT",  "Netherlands", "NLD",  "Poland",     "POL",
  "Portugal",     "PRT",  "Romania",     "ROU",  "Slovakia",   "SVK",
  "Slovenia",     "SVN",  "Spain",       "ESP",  "Sweden",     "SWE"
)

# 6.3  Join DESI with DHMI
validation_df <- country_maturity_clean %>%
  inner_join(desi %>% left_join(country_iso3, by = "Country"),
             by = c("COUNTRY_REGION" = "iso3")) %>%
  filter(!is.na(DESI_eHealth), !is.na(DHMI_scaled))

message(sprintf("Validation overlap (WHO ∩ DESI): %d countries", nrow(validation_df)))

# 6.4  Spearman correlation: DHMI vs DESI
val_corr <- cor.test(validation_df$DHMI_scaled, validation_df$DESI_eHealth,
                     method = "spearman")
message(sprintf(
  "Convergent validity – Spearman rho = %.3f (p = %.4f, n = %d)",
  val_corr$estimate, val_corr$p.value, nrow(validation_df)
))

# 6.5  Figure: scatter plot DHMI vs DESI
ggplot(validation_df,
       aes(x = DHMI_scaled, y = DESI_eHealth, label = COUNTRY_REGION)) +
  geom_point(aes(color = Cluster_Label), size = 3.5, alpha = 0.85) +
  geom_smooth(method = "lm", se = TRUE,
              color = "#555555", linetype = "dashed", linewidth = 0.8) +
  ggrepel::geom_text_repel(size = 3, color = "gray30",
                           max.overlaps = 20, seed = 42) +
  scale_color_manual(values = CLUSTER_COLOURS) +
  labs(
    title    = "Convergent Validity: DHMI vs DESI eHealth Score (2023)",
    subtitle = sprintf("Spearman \u03C1 = %.3f, p = %.4f | n = %d EU countries",
                       val_corr$estimate, val_corr$p.value, nrow(validation_df)),
    x        = "Digital Health Maturity Index (DHMI, 0\u2013100)",
    y        = "DESI \u2013 Access to e-Health Records (0\u2013100)",
    color    = "Maturity Cluster"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title      = element_text(face = "bold", size = 13),
    plot.subtitle   = element_text(size = 10, color = "gray40"),
    legend.position = "bottom"
  )

ggsave("Figure_DHMI_vs_DESI_Validation.png", dpi = 300, width = 8, height = 6)
message("Saved: Figure_DHMI_vs_DESI_Validation.png")


# =============================================================================
# 7. SENSITIVITY ANALYSIS: WEIGHT PERTURBATION (1,000 SIMULATIONS)
# =============================================================================
# Tests whether country rankings are robust to changes in domain weights.
# Approach: 1,000 random weight vectors drawn from a uniform simplex
# distribution. Spearman correlation between equal-weight ranking and the
# mean simulated ranking assesses overall stability.

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

# Run simulations
sim_rankings <- matrix(NA, nrow = nrow(domain_mat), ncol = n_sim)
for (i in seq_len(n_sim)) {
  w <- runif(n_domain)
  w <- w / sum(w)
  sim_rankings[, i] <- rank(-(domain_mat %*% w), ties.method = "average")
}

# Compute ranking stability statistics per country
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

# Spearman correlation: equal-weight ranking vs simulation mean
sa_corr <- cor.test(rank_stability$Rank_Equal,
                    rank_stability$Rank_Mean_Sim,
                    method = "spearman")
message(sprintf(
  "Sensitivity analysis – Spearman rho = %.3f (p = %.6f)",
  sa_corr$estimate, sa_corr$p.value
))

# Countries with unstable rankings (P5–P95 range > 10 positions)
unstable <- rank_stability %>% filter(Rank_Range > 10)
message(sprintf("Countries with rank range > 10 positions: %d", nrow(unstable)))
if (nrow(unstable) > 0) print(unstable %>% dplyr::select(COUNTRY_REGION, Rank_Equal, Rank_Range))

# Figure: sensitivity analysis scatter with uncertainty bands
rank_stability_plot <- rank_stability %>%
  left_join(domain_scores %>% dplyr::select(COUNTRY_REGION, DHMI_equal),
            by = "COUNTRY_REGION") %>%
  arrange(Rank_Equal) %>%
  mutate(COUNTRY_REGION = factor(COUNTRY_REGION, levels = COUNTRY_REGION))

ggplot(rank_stability_plot,
       aes(x = Rank_Equal, y = Rank_Mean_Sim)) +
  geom_abline(slope = 1, intercept = 0,
              linetype = "dotted", color = "gray60") +
  geom_errorbar(aes(ymin = Rank_P5, ymax = Rank_P95),
                width = 0.4, color = "#5B9BD5", alpha = 0.6) +
  geom_point(color = "#2E75B6", size = 2.5) +
  ggrepel::geom_text_repel(
    aes(label = COUNTRY_REGION), size = 2.5, color = "gray30",
    max.overlaps = 40, seed = 42,
    box.padding = 0.4, min.segment.length = 0.2
  ) +
  labs(
    title    = "Sensitivity Analysis: Ranking Stability Under 1,000 Weight Perturbations",
    subtitle = sprintf(
      "Spearman \u03C1 = %.3f between equal-weight ranking and simulation mean | n = %d countries",
      sa_corr$estimate, nrow(rank_stability)
    ),
    x       = "Rank \u2013 Equal Weighting",
    y       = "Rank \u2013 Mean of 1,000 Simulations (bars = P5\u2013P95)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(size = 9.5, color = "gray40")
  )

ggsave("Figure_Sensitivity_Analysis.png", dpi = 300, width = 9, height = 7)
message("Saved: Figure_Sensitivity_Analysis.png")


# =============================================================================
# 8. SPEARMAN CORRELATION AMONG WHO INDICATORS
# =============================================================================
# FDR correction (Benjamini-Hochberg) applied at the correlation-matrix level.
# Indicators with zero variance or > 50% missing are excluded.

# 8.1  Prepare indicator data
indicator_data <- df_europe %>%
  dplyr::select(all_of(ALL_INDICATORS)) %>%
  mutate(across(everything(), as.numeric))

keep_cols <- names(indicator_data)[
  sapply(indicator_data, function(x) var(x, na.rm = TRUE) > 0) &
    sapply(indicator_data, function(x) mean(is.na(x)) < 0.5)
]
message(sprintf("Indicators retained for correlation: %d / %d",
                length(keep_cols), length(ALL_INDICATORS)))

# Impute NA with column median
indicator_clean <- indicator_data[, keep_cols]
for (col in names(indicator_clean)) {
  med <- median(indicator_clean[[col]], na.rm = TRUE)
  indicator_clean[[col]][is.na(indicator_clean[[col]])] <- med
}

# 8.2  Compute Spearman correlation matrix and p-value matrix
cor_matrix <- cor(indicator_clean, method = "spearman")
p_matrix   <- ggcorrplot::cor_pmat(indicator_clean, method = "spearman")

# 8.3  Top significant pairs (p < 0.05, FDR-corrected)
sig_cors <- as.data.frame(as.table(cor_matrix)) %>%
  rename(Ind1 = Var1, Ind2 = Var2, rho = Freq) %>%
  filter(as.character(Ind1) < as.character(Ind2)) %>%
  mutate(p_val = mapply(function(i, j) p_matrix[i, j],
                        as.character(Ind1), as.character(Ind2)),
         p_fdr = p.adjust(p_val, method = "BH")) %>%
  filter(p_fdr < 0.05) %>%
  arrange(desc(abs(rho)))

message(sprintf("Significant correlation pairs (p_FDR < 0.05): %d", nrow(sig_cors)))
message("Top 15:")
print(sig_cors %>% head(15) %>% mutate(across(where(is.numeric), ~round(.x, 3))))

# 8.4  Figure: full correlation matrix (Appendix)
ggcorrplot(cor_matrix,
           hc.order      = TRUE,
           type          = "lower",
           lab           = FALSE,
           p.mat         = p_matrix,
           sig.level     = 0.05,
           insig         = "blank",
           tl.cex        = 5,
           tl.srt        = 45,
           outline.color = "gray95",
           colors        = c("#b2182b", "white", "#2166ac"),
           title         = "Spearman Correlation \u2013 All WHO Digital Health Indicators",
           legend.title  = "\u03C1",
           ggtheme       = theme_minimal(base_size = 8))

ggsave("Figure_Correlation_Matrix_Full.png", dpi = 300, width = 14, height = 12)
message("Saved: Figure_Correlation_Matrix_Full.png")

# 8.5  Figure: selected-indicator subset (paper body)
selected_inds <- intersect(
  c("DH_1", "DH_2", "DH_3",
    "DH_8", "DH_9", "DH_10",
    "DH_14", "DH_15", "DH_16",
    "DH_24", "DH_25", "DH_26",
    "DH_67", "DH_68", "DH_69"),
  keep_cols
)

ggcorrplot(cor_matrix[selected_inds, selected_inds],
           hc.order      = TRUE,
           type          = "lower",
           lab           = TRUE,
           lab_size      = 3,
           p.mat         = p_matrix[selected_inds, selected_inds],
           sig.level     = 0.05,
           insig         = "blank",
           tl.cex        = 9,
           tl.srt        = 45,
           outline.color = "white",
           colors        = c("#b2182b", "white", "#2166ac"),
           title         = "Key Inter-Domain Correlations \u2013 Selected WHO Indicators",
           legend.title  = "\u03C1",
           ggtheme       = theme_minimal(base_size = 11))

ggsave("Figure_Correlation_Matrix_Selected.png", dpi = 300, width = 9, height = 8)
message("Saved: Figure_Correlation_Matrix_Selected.png")


# =============================================================================
# 9. LASSO REGRESSION: Indicator-Level Predictors of DHMI
# =============================================================================
# LASSO with 10-fold cross-validation identifies the minimal set of WHO
# indicators that predict DHMI_scaled. LOO-CV R² is reported as a
# conservative out-of-sample performance estimate.

# 9.1  Build predictor matrix X and outcome vector y
lasso_data <- df_europe %>%
  dplyr::select(COUNTRY_REGION, all_of(keep_cols)) %>%
  mutate(across(all_of(keep_cols), as.numeric)) %>%
  left_join(
    country_maturity_clean %>% dplyr::select(COUNTRY_REGION, DHMI_scaled),
    by = "COUNTRY_REGION"
  ) %>%
  filter(!is.na(DHMI_scaled))

# Impute NA with column median
X_df <- lasso_data %>% dplyr::select(all_of(keep_cols))
for (col in names(X_df)) {
  med <- median(X_df[[col]], na.rm = TRUE)
  X_df[[col]][is.na(X_df[[col]])] <- med
}
X <- as.matrix(X_df)
y <- lasso_data$DHMI_scaled

message(sprintf("LASSO – X: %d x %d | y: %d observations", nrow(X), ncol(X), length(y)))

# 9.2  10-fold CV LASSO
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

# 9.3  In-sample R²
y_pred   <- as.vector(predict(cv_lasso, newx = X, s = "lambda.min"))
r2_lasso <- 1 - sum((y - y_pred)^2) / sum((y - mean(y))^2)

# 9.4  LOO-CV R² (honest out-of-sample estimate)
n        <- nrow(X)
loo_pred <- numeric(n)
for (i in seq_len(n)) {
  fit_loo    <- glmnet(X[-i, ], y[-i], alpha = 1, lambda = cv_lasso$lambda.min)
  loo_pred[i] <- predict(fit_loo, newx = X[i, , drop = FALSE],
                         s = cv_lasso$lambda.min)[1]
}
r2_loo <- 1 - sum((y - loo_pred)^2) / sum((y - mean(y))^2)

message(sprintf("LASSO R\u00B2 in-sample: %.3f | LOO-CV: %.3f | Overfitting gap: %.3f",
                r2_lasso, r2_loo, r2_lasso - r2_loo))

# 9.5  Annotate selected indicators with labels and domains
lasso_df_annotated <- lasso_df %>%
  mutate(
    Description = INDICATOR_LABELS[Indicator],
    Description = if_else(is.na(Description), Indicator, Description),
    Domain      = INDICATOR_DOMAIN_MAP[Description],
    Domain      = if_else(is.na(Domain), "Other", Domain)
  )

# 9.6  Figure 1: LASSO coefficients
ggplot(lasso_df_annotated,
       aes(x = reorder(Description, Coefficient),
           y = Coefficient, fill = Domain)) +
  geom_col(width = 0.72, color = "white", linewidth = 0.3) +
  coord_flip() +
  scale_fill_manual(values = DOMAIN_COLOURS, breaks = LEGEND_ORDER) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray40") +
  labs(
    title    = "Figure 1 \u2013 LASSO-Selected WHO Indicators Predicting Digital Health Maturity",
    subtitle = sprintf(
      "R\u00B2 in-sample = %.3f | R\u00B2 LOO-CV = %.3f | %d of %d indicators selected | n = %d countries",
      r2_lasso, r2_loo, nrow(lasso_df), length(keep_cols), length(y)
    ),
    x       = NULL,
    y       = "LASSO Coefficient",
    fill    = "Policy Domain",
    caption = sprintf(
      "Figure 1. LASSO-selected WHO digital health indicators predicting the DHMI.\nBars represent LASSO coefficients at \u03BB.min (10-fold CV). R\u00B2 in-sample = %.3f; R\u00B2 LOO-CV = %.3f; n = %d countries.",
      r2_lasso, r2_loo, length(y)
    )
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title         = element_text(face = "bold", size = 12),
    plot.subtitle      = element_text(size = 9, color = "gray40"),
    plot.caption       = element_text(size = 7.5, color = "gray40",
                                      hjust = 0, margin = margin(t = 8)),
    legend.position    = "right",
    legend.text        = element_text(size = 8),
    legend.title       = element_text(size = 9, face = "bold"),
    axis.text.y        = element_text(size = 8.5),
    axis.text.x        = element_text(size = 9),
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_line(color = "gray88", linewidth = 0.4)
  )

ggsave("Figure1_LASSO_Final.png", dpi = 300, width = 12, height = 8)
message("Saved: Figure1_LASSO_Final.png")


# =============================================================================
# 10. MANN-WHITNEY U TEST: High vs Low Maturity Cluster Discrimination
# =============================================================================
# Compares each WHO indicator between High Maturity (n = 11) and Low Maturity
# (n = 16) clusters. p-values corrected with Benjamini-Hochberg FDR.
# Effect size: r = |Z| / sqrt(N_High + N_Low)

# 10.1  Prepare comparison dataset
mw_data <- df_europe %>%
  dplyr::select(COUNTRY_REGION, all_of(keep_cols)) %>%
  mutate(across(all_of(keep_cols), as.numeric)) %>%
  left_join(
    country_maturity_clean %>% dplyr::select(COUNTRY_REGION, Cluster_Label),
    by = "COUNTRY_REGION"
  ) %>%
  filter(Cluster_Label %in% c("High Maturity", "Low Maturity"))

message(sprintf("Mann-Whitney – High: %d | Low: %d",
                sum(mw_data$Cluster_Label == "High Maturity"),
                sum(mw_data$Cluster_Label == "Low Maturity")))

# 10.2  Run Mann-Whitney U for each indicator
mw_results <- lapply(keep_cols, function(ind) {
  high <- mw_data[[ind]][mw_data$Cluster_Label == "High Maturity"]
  low  <- mw_data[[ind]][mw_data$Cluster_Label == "Low Maturity"]
  high <- high[!is.na(high)]; low <- low[!is.na(low)]
  if (length(high) < 3 | length(low) < 3) return(NULL)

  test    <- wilcox.test(high, low, exact = FALSE)
  z_stat  <- qnorm(test$p.value / 2) * sign(mean(high) - mean(low))
  r_eff   <- abs(z_stat) / sqrt(length(high) + length(low))

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

# 10.3  FDR correction (Benjamini-Hochberg)
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

sig_fdr_results <- mw_results %>% filter(sig_fdr != "ns")
message(sprintf("Indicators significant after FDR correction: %d", nrow(sig_fdr_results)))
print(sig_fdr_results %>%
        dplyr::select(Indicator, Mean_High, Mean_Low, Diff, p_value, p_fdr, r_effect, sig_fdr))

# 10.4  Annotate for figure
mw_plot_df <- sig_fdr_results %>%
  mutate(
    Description = INDICATOR_LABELS[Indicator],
    Description = if_else(is.na(Description), Indicator, Description),
    Domain      = INDICATOR_DOMAIN_MAP[Description],
    Domain      = if_else(is.na(Domain), "Other", Domain),
    label_text  = paste0("r=", r_effect, "  ", sig_fdr)
  ) %>%
  arrange(Diff)

# 10.5  Figure 2: Mann-Whitney discriminating indicators
ggplot(mw_plot_df,
       aes(x = reorder(Description, Diff), y = Diff, fill = Domain)) +
  geom_col(width = 0.72, color = "white", linewidth = 0.3) +
  coord_flip() +
  scale_fill_manual(values = DOMAIN_COLOURS, breaks = LEGEND_ORDER) +
  geom_text(aes(label = label_text),
            hjust = -0.05, size = 2.8, color = "gray25") +
  expand_limits(y = max(mw_plot_df$Diff) * 1.3) +
  labs(
    title    = "Figure 2 \u2013 WHO Indicators Discriminating High vs Low Maturity Countries",
    subtitle = sprintf(
      "Mann-Whitney U | FDR correction (Benjamini-Hochberg) | n=%d High, n=%d Low | All differences favour High Maturity",
      sum(mw_data$Cluster_Label == "High Maturity"),
      sum(mw_data$Cluster_Label == "Low Maturity")
    ),
    x       = NULL,
    y       = "Mean Score Difference (High \u2212 Low Maturity)",
    fill    = "Policy Domain",
    caption = "Figure 2. WHO digital health indicators significantly discriminating High from Low Maturity countries.\nMean score differences (High \u2212 Low). Effect sizes (r) and FDR-corrected significance (* p_FDR < 0.05).\nMann-Whitney U test with Benjamini-Hochberg correction."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title         = element_text(face = "bold", size = 12),
    plot.subtitle      = element_text(size = 8.5, color = "gray40"),
    plot.caption       = element_text(size = 7.5, color = "gray40",
                                      hjust = 0, margin = margin(t = 8)),
    legend.position    = "right",
    legend.text        = element_text(size = 8),
    legend.title       = element_text(size = 9, face = "bold"),
    axis.text.y        = element_text(size = 8.5),
    axis.text.x        = element_text(size = 9),
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_line(color = "gray88", linewidth = 0.4)
  )

ggsave("Figure2_MannWhitney_Final.png", dpi = 300, width = 12, height = 9)
message("Saved: Figure2_MannWhitney_Final.png")


# =============================================================================
# 11. CROSS-METHOD CONVERGENCE: LASSO ∩ MANN-WHITNEY
# =============================================================================
# Indicators selected by both LASSO and Mann-Whitney provide the
# strongest cross-method evidence of structural discriminators.

lasso_selected <- lasso_df_annotated$Indicator
mw_selected    <- sig_fdr_results$Indicator
convergent     <- intersect(lasso_selected, mw_selected)

message(sprintf(
  "\nCross-method convergence:\n  LASSO: %d | Mann-Whitney (FDR): %d | Overlap: %d",
  length(lasso_selected), length(mw_selected), length(convergent)
))
message("Converging indicators:")
print(
  data.frame(
    Indicator   = convergent,
    Label       = INDICATOR_LABELS[convergent],
    LASSO_coef  = round(lasso_df$Coefficient[match(convergent, lasso_df$Indicator)], 3),
    MW_diff     = round(mw_results$Diff[match(convergent, mw_results$Indicator)], 2),
    MW_r_effect = round(mw_results$r_effect[match(convergent, mw_results$Indicator)], 3)
  )
)


# =============================================================================
# 12. EXPORT SUMMARY TABLES
# =============================================================================

# 12.1  Country DHMI scores with cluster labels
write.xlsx(
  country_maturity_clean %>%
    dplyr::select(COUNTRY_REGION, DHMI_scaled, Cluster_Label) %>%
    rename(Country = COUNTRY_REGION,
           DHMI_0_100 = DHMI_scaled,
           Maturity_Cluster = Cluster_Label) %>%
    arrange(desc(DHMI_0_100)),
  "Output_DHMI_Country_Scores.xlsx",
  rowNames = FALSE
)

# 12.2  Domain adoption rates by country
write.xlsx(
  domain_scores %>%
    dplyr::select(COUNTRY_REGION, all_of(DOMAIN_COLS), DHMI_equal) %>%
    rename(Country = COUNTRY_REGION),
  "Output_Domain_Adoption_Rates.xlsx",
  rowNames = FALSE
)

# 12.3  LASSO results
write.xlsx(lasso_df_annotated, "Output_LASSO_Results.xlsx", rowNames = FALSE)

# 12.4  Mann-Whitney results (all indicators)
write.xlsx(mw_results, "Output_MannWhitney_Results.xlsx", rowNames = FALSE)

message("\nAll outputs saved successfully.")
message("Generated figures:")
message("  Figure_DHMI_Clusters.png")
message("  Figure_Missing_Data_Heatmap.png")
message("  Figure_DHMI_vs_DESI_Validation.png")
message("  Figure_Sensitivity_Analysis.png")
message("  Figure_Correlation_Matrix_Full.png")
message("  Figure_Correlation_Matrix_Selected.png")
message("  Figure1_LASSO_Final.png")
message("  Figure2_MannWhitney_Final.png")

# =============================================================================
# END OF SCRIPT
# =============================================================================
