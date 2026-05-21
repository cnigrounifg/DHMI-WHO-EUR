# =============================================================================
# 00_setup.R — Package loading and global constants
# =============================================================================
#
# Purpose : Provide the shared environment (packages + constants) for the
#           DHMI analysis pipeline. Every analytical script sources this file
#           as its first instruction.
#
# Usage   : source("code/00_setup.R")   # invoked from the project root
#
# Outputs : Loads packages and defines the following objects in the global
#           environment:
#             WHO_EUR_COUNTRIES, EU27_COUNTRIES,
#             DOMAIN_MAP, ALL_INDICATORS, DOMAIN_COLS,
#             CLUSTER_COLOURS, DOMAIN_COLOURS,
#             INDICATOR_LABELS, INDICATOR_DOMAIN_MAP, LEGEND_ORDER,
#             recode_adoption().
# =============================================================================


# -----------------------------------------------------------------------------
# Package set-up
# -----------------------------------------------------------------------------
required_packages <- c(
  # Core data manipulation
  "readr", "dplyr", "tidyr", "scales",
  # Visualisation
  "ggplot2", "ggcorrplot", "ggrepel",
  # Clustering
  "cluster", "factoextra",
  # Statistical analysis
  "glmnet", "broom", "car", "MASS", "FSA", "psych",
  # Mapping (used in optional regional figures)
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

invisible(lapply(required_packages, library, character.only = TRUE))


# -----------------------------------------------------------------------------
# Country reference sets
# -----------------------------------------------------------------------------
# WHO European Region — 53 Member States (ISO3 codes)
WHO_EUR_COUNTRIES <- c(
  "ALB", "AND", "ARM", "AUT", "AZE", "BLR", "BEL", "BIH", "BGR", "HRV",
  "CYP", "CZE", "DNK", "EST", "FIN", "FRA", "GEO", "DEU", "GRC", "HUN",
  "ISL", "IRL", "ISR", "ITA", "KAZ", "KGZ", "LVA", "LTU", "LUX", "MLT",
  "MCO", "MNE", "NLD", "MKD", "NOR", "POL", "PRT", "MDA", "ROU", "RUS",
  "SMR", "SRB", "SVK", "SVN", "ESP", "SWE", "CHE", "TJK", "TUR", "TKM",
  "UKR", "GBR", "UZB"
)

# EU-27 Member States (ISO3 codes) — used for EU/Non-EU stratification
EU27_COUNTRIES <- c(
  "AUT", "BEL", "BGR", "HRV", "CYP", "CZE", "DNK", "EST", "FIN", "FRA",
  "DEU", "GRC", "HUN", "IRL", "ITA", "LVA", "LTU", "LUX", "MLT", "NLD",
  "POL", "PRT", "ROU", "SVK", "SVN", "ESP", "SWE"
)


# -----------------------------------------------------------------------------
# DHMI domain structure
# -----------------------------------------------------------------------------
# 10 policy domains and their constituent WHO indicators
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

ALL_INDICATORS <- unlist(DOMAIN_MAP, use.names = FALSE)
DOMAIN_COLS    <- names(DOMAIN_MAP)


# -----------------------------------------------------------------------------
# Recoding function — WHO categorical → numeric adoption score
# -----------------------------------------------------------------------------
# Coding scheme follows WHO response categories:
#   YES / YES_1 = 3   (fully adopted)
#   YES_2       = 2   (partially adopted — most elements)
#   YES_3       = 1   (partially adopted — some elements)
#   NO          = 0   (policy exists but not adopted)
#   NO_1..NO_4  = -1..-4  (graduated absence / non-adoption)
#   MND_1       = NA  (missing / not declared)
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
    TRUE                     ~ NA_real_
  )
}


# -----------------------------------------------------------------------------
# Visual styles
# -----------------------------------------------------------------------------
CLUSTER_COLOURS <- c(
  "Low Maturity"    = "#d73027",
  "Medium Maturity" = "#fdae61",
  "High Maturity"   = "#1a9850"
)

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


# -----------------------------------------------------------------------------
# Indicator labels and domain assignments (for figure annotation)
# -----------------------------------------------------------------------------
INDICATOR_LABELS <- c(
  DH_1  = "National DH strategy",           DH_2  = "HIS strategy",
  DH_3  = "DH action plan",                 DH_4  = "DH coordination body",
  DH_5  = "Private funding",                DH_6  = "Public funding",
  DH_7  = "PPP funding",                    DH_8  = "DH education policy",
  DH_9  = "In-service DH training",         DH_10 = "DH competencies for students",
  DH_11 = "Data privacy legislation",       DH_12 = "EHR data protection",
  DH_13 = "EHR data sharing regulation",    DH_14 = "Patient data access rights",
  DH_15 = "Individual EHR data correction right",
  DH_16 = "EHR data portability right",     DH_17 = "Right to opt out of EHR",
  DH_18 = "Secure patient ID",              DH_19 = "National monitoring agency",
  DH_20 = "DH indicator framework",         DH_21 = "DH evaluation guidance",
  DH_22 = "Telehealth evaluation",          DH_23 = "DH progress reporting",
  DH_24 = "National EHR system",            DH_25 = "Regional EHR system",
  DH_26 = "Regional EHR federation",        DH_27 = "EHR in primary care",
  DH_28 = "EHR in secondary care",          DH_29 = "EHR in tertiary care",
  DH_43 = "Teleradiology",                  DH_44 = "Teledermatology",
  DH_45 = "Telepathology",                  DH_46 = "Telepsychiatry",
  DH_47 = "Telemedicine",                   DH_48 = "mHealth appointment reminders",
  DH_49 = "Mobile teleconsultation",        DH_50 = "Patient monitoring mHealth",
  DH_51 = "Treatment adherence mHealth",    DH_52 = "Patient e-record access mHealth",
  DH_53 = "Health promotion mHealth",       DH_54 = "Surveillance mHealth",
  DH_67 = "National data strategy",         DH_68 = "Big data health policy",
  DH_69 = "Big data private sector policy", DH_70 = "AI in health policy"
)

# NOTE: each label appears exactly once — no duplicates
INDICATOR_DOMAIN_MAP <- c(
  "National DH strategy"                 = "Governance",
  "HIS strategy"                         = "Governance",
  "DH action plan"                       = "Governance",
  "DH coordination body"                 = "Governance",
  "Private funding"                      = "Funding",
  "Public funding"                       = "Funding",
  "PPP funding"                          = "Funding",
  "DH education policy"                  = "Literacy & Capacity",
  "In-service DH training"               = "Literacy & Capacity",
  "DH competencies for students"         = "Literacy & Capacity",
  "Data privacy legislation"             = "Regulatory Frameworks",
  "EHR data protection"                  = "Regulatory Frameworks",
  "EHR data sharing regulation"          = "Regulatory Frameworks",
  "Patient data access rights"           = "Regulatory Frameworks",
  "Individual EHR data correction right" = "Regulatory Frameworks",
  "EHR data portability right"           = "Regulatory Frameworks",
  "Right to opt out of EHR"              = "Regulatory Frameworks",
  "Secure patient ID"                    = "Regulatory Frameworks",
  "National monitoring agency"           = "Monitoring & Evaluation",
  "DH indicator framework"               = "Monitoring & Evaluation",
  "DH evaluation guidance"               = "Monitoring & Evaluation",
  "Telehealth evaluation"                = "Monitoring & Evaluation",
  "DH progress reporting"                = "Monitoring & Evaluation",
  "National EHR system"                  = "EHR & Facilities",
  "Regional EHR system"                  = "EHR & Facilities",
  "Regional EHR federation"              = "EHR & Facilities",
  "EHR in primary care"                  = "EHR & Facilities",
  "EHR in secondary care"                = "EHR & Facilities",
  "EHR in tertiary care"                 = "EHR & Facilities",
  "Teleradiology"                        = "Telehealth",
  "Teledermatology"                      = "Telehealth",
  "Telepathology"                        = "Telehealth",
  "Telepsychiatry"                       = "Telehealth",
  "Telemedicine"                         = "Telehealth",
  "mHealth appointment reminders"        = "mHealth",
  "Mobile teleconsultation"              = "mHealth",
  "Patient monitoring mHealth"           = "mHealth",
  "Treatment adherence mHealth"          = "mHealth",
  "Patient e-record access mHealth"      = "mHealth",
  "Health promotion mHealth"             = "mHealth",
  "Surveillance mHealth"                 = "mHealth",
  "National data strategy"               = "Big Data & Analytics",
  "Big data health policy"               = "Big Data & Analytics",
  "Big data private sector policy"       = "Big Data & Analytics",
  "AI in health policy"                  = "Big Data & Analytics"
)

LEGEND_ORDER <- c(
  "Monitoring & Evaluation", "EHR & Facilities", "Big Data & Analytics",
  "Regulatory Frameworks", "mHealth", "Telehealth",
  "Governance", "Literacy & Capacity", "Funding"
)


# -----------------------------------------------------------------------------
# Project-wide paths (relative to project root; use here::here() if needed)
# -----------------------------------------------------------------------------
PATH_RAW       <- "data/raw"
PATH_PROCESSED <- "data/processed"
PATH_EXTERNAL  <- "data/external_validators"
PATH_FIGURES   <- "outputs/figures"
PATH_TABLES    <- "outputs/tables"

# Ensure output directories exist
for (p in c(PATH_PROCESSED, PATH_FIGURES, PATH_TABLES)) {
  if (!dir.exists(p)) dir.create(p, recursive = TRUE, showWarnings = FALSE)
}

message("00_setup.R loaded: ", length(WHO_EUR_COUNTRIES), " WHO European Region countries, ",
        length(ALL_INDICATORS), " indicators across ", length(DOMAIN_MAP), " domains.")
