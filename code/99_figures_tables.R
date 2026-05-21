# =============================================================================
# 99_figures_tables.R — Regenerate all paper figures and summary tables
# =============================================================================
#
# Purpose : From the CSV outputs of scripts 01–08, regenerate every figure
#           and summary Excel table reported in the BIJ paper. This is the
#           single script that needs to be re-run if a figure style or
#           caption is updated.
#
# Inputs  : All CSVs in data/processed/
#           data/external_validators/ (for DESI/UHC figures, if available)
#
# Outputs : outputs/figures/ — Figures 1, 2, 3, 4 + Appendix A1, A2 (PNG, 300 dpi)
#           outputs/tables/  — Tables 1, 2, 3, 4 (XLSX)
#
# Dependencies : 00_setup.R, plus every script 01–08
# =============================================================================

source("code/00_setup.R")


# -----------------------------------------------------------------------------
# 99.1  Load all processed CSVs
# -----------------------------------------------------------------------------
domain_scores          <- read_csv(file.path(PATH_PROCESSED, "domain_scores.csv"),
                                   show_col_types = FALSE)
country_maturity_clean <- read_csv(file.path(PATH_PROCESSED, "cluster_assignments.csv"),
                                   show_col_types = FALSE)
rank_stability         <- read_csv(file.path(PATH_PROCESSED, "rank_stability.csv"),
                                   show_col_types = FALSE)
spearman_sig_pairs     <- read_csv(file.path(PATH_PROCESSED, "spearman_sig_pairs.csv"),
                                   show_col_types = FALSE)
lasso_df_annotated     <- read_csv(file.path(PATH_PROCESSED, "lasso_results.csv"),
                                   show_col_types = FALSE)
lasso_performance      <- read_csv(file.path(PATH_PROCESSED, "lasso_performance.csv"),
                                   show_col_types = FALSE)
mw_results             <- read_csv(file.path(PATH_PROCESSED, "mw_results.csv"),
                                   show_col_types = FALSE)
mw_sig                 <- read_csv(file.path(PATH_PROCESSED, "mw_sig_indicators.csv"),
                                   show_col_types = FALSE)
convergence_df         <- read_csv(file.path(PATH_PROCESSED, "cross_method_convergence.csv"),
                                   show_col_types = FALSE)

# Optional external validation data
desi_path <- file.path(PATH_PROCESSED, "external_validity_DESI.csv")
desi_df   <- if (file.exists(desi_path)) read_csv(desi_path, show_col_types = FALSE) else NULL


# -----------------------------------------------------------------------------
# 99.2  Figure 1 — DHMI bar chart (cluster-coloured)
# -----------------------------------------------------------------------------
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
ggsave(file.path(PATH_FIGURES, "Figure_1_DHMI_Clusters.png"),
       dpi = 300, width = 10, height = 9)


# -----------------------------------------------------------------------------
# 99.3  Figure 2 — LASSO coefficients
# -----------------------------------------------------------------------------
ggplot(lasso_df_annotated,
       aes(x = reorder(Description, Coefficient),
           y = Coefficient, fill = Domain)) +
  geom_col(width = 0.72, color = "white", linewidth = 0.3) +
  coord_flip() +
  scale_fill_manual(values = DOMAIN_COLOURS, breaks = LEGEND_ORDER) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray40") +
  labs(
    title    = "Figure 2 – LASSO-Selected WHO Indicators Predicting the DHMI",
    subtitle = sprintf(
      "R² in-sample = %.3f | R² LOO-CV = %.3f | %d of %d indicators selected",
      lasso_performance$R2_in_sample,
      lasso_performance$R2_LOO_CV,
      lasso_performance$n_selected,
      lasso_performance$n_predictors
    ),
    x       = NULL,
    y       = "LASSO Coefficient",
    fill    = "Policy Domain"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title      = element_text(face = "bold", size = 12),
    plot.subtitle   = element_text(size = 9, color = "gray40"),
    legend.position = "right"
  )
ggsave(file.path(PATH_FIGURES, "Figure_2_LASSO_Final.png"),
       dpi = 300, width = 12, height = 8)


# -----------------------------------------------------------------------------
# 99.4  Figure 3 — Mann-Whitney discriminators
# -----------------------------------------------------------------------------
mw_plot_df <- mw_sig %>%
  arrange(Diff) %>%
  mutate(label_text = paste0("r=", r_effect, "  ", sig_fdr))

if (nrow(mw_plot_df) > 0) {
  ggplot(mw_plot_df,
         aes(x = reorder(Description, Diff), y = Diff, fill = Domain)) +
    geom_col(width = 0.72, color = "white", linewidth = 0.3) +
    coord_flip() +
    scale_fill_manual(values = DOMAIN_COLOURS, breaks = LEGEND_ORDER) +
    geom_text(aes(label = label_text),
              hjust = -0.05, size = 2.8, color = "gray25") +
    expand_limits(y = max(mw_plot_df$Diff) * 1.3) +
    labs(
      title    = "Figure 3 – WHO Indicators Discriminating High vs Low Maturity",
      subtitle = "Mann-Whitney U with Benjamini-Hochberg FDR correction",
      x       = NULL,
      y       = "Mean Score Difference (High − Low Maturity)",
      fill    = "Policy Domain"
    ) +
    theme_minimal(base_size = 11) +
    theme(
      plot.title      = element_text(face = "bold", size = 12),
      plot.subtitle   = element_text(size = 9, color = "gray40"),
      legend.position = "right"
    )
  ggsave(file.path(PATH_FIGURES, "Figure_3_MannWhitney_Final.png"),
         dpi = 300, width = 12, height = 9)
}


# -----------------------------------------------------------------------------
# 99.5  Figure 4 — Weight-perturbation sensitivity analysis
# -----------------------------------------------------------------------------
rank_stability_plot <- rank_stability %>%
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
    title    = "Figure 4 – Ranking Stability under 1,000 Weight Perturbations",
    subtitle = "Bars: P5–P95 across simulations",
    x       = "Rank – Equal Weighting",
    y       = "Rank – Mean of 1,000 Simulations"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(size = 9.5, color = "gray40")
  )
ggsave(file.path(PATH_FIGURES, "Figure_4_Sensitivity_Analysis.png"),
       dpi = 300, width = 9, height = 7)


# -----------------------------------------------------------------------------
# 99.6  Figure A1 — Full Spearman correlation matrix (Appendix)
#           (regenerated from the processed correlation matrix CSV)
# -----------------------------------------------------------------------------
cor_path <- file.path(PATH_PROCESSED, "spearman_correlation_matrix.csv")
if (file.exists(cor_path)) {
  cor_matrix <- as.matrix(read.csv(cor_path, row.names = 1, check.names = FALSE))
  p_matrix   <- as.matrix(read.csv(
    file.path(PATH_PROCESSED, "spearman_pvalue_matrix.csv"),
    row.names = 1, check.names = FALSE))

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
             title         = "Figure A1 – Spearman Correlation Matrix (43 retained indicators)",
             legend.title  = "ρ",
             ggtheme       = theme_minimal(base_size = 8))
  ggsave(file.path(PATH_FIGURES, "Figure_A1_Correlation_Matrix.png"),
         dpi = 300, width = 14, height = 12)
}


# -----------------------------------------------------------------------------
# 99.7  Figure A2 — Missing data heatmap (regenerated)
# -----------------------------------------------------------------------------
df_europe <- read_csv(file.path(PATH_PROCESSED, "indicators_recoded.csv"),
                      show_col_types = FALSE)

missing_long <- df_europe %>%
  dplyr::select(COUNTRY_REGION, all_of(ALL_INDICATORS)) %>%
  pivot_longer(-COUNTRY_REGION, names_to = "Indicator", values_to = "Value") %>%
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
    title    = "Figure A2 – Missing Data Pattern (WHO 2023 indicators)",
    x        = "WHO Indicator", y = "Country"
  ) +
  theme_minimal(base_size = 9) +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, size = 6),
    axis.text.y = element_text(size = 7),
    legend.position = "bottom"
  )
ggsave(file.path(PATH_FIGURES, "Figure_A2_Missing_Data_Heatmap.png"),
       dpi = 300, width = 13, height = 9)


# -----------------------------------------------------------------------------
# 99.8  Excel summary tables (4 main + auxiliary)
# -----------------------------------------------------------------------------
# Table 1: Country DHMI scores with cluster labels
write.xlsx(
  country_maturity_clean %>%
    dplyr::select(COUNTRY_REGION, DHMI_scaled, Cluster_Label,
                  Cluster_Companion_Label) %>%
    arrange(desc(DHMI_scaled)),
  file.path(PATH_TABLES, "Table_DHMI_Country_Scores.xlsx"),
  rowNames = FALSE
)

# Table 2: Domain adoption rates by country
write.xlsx(
  domain_scores %>% dplyr::select(COUNTRY_REGION, all_of(DOMAIN_COLS), DHMI_equal),
  file.path(PATH_TABLES, "Table_Domain_Adoption_Rates.xlsx"),
  rowNames = FALSE
)

# Table 3: Spearman significant pairs
write.xlsx(spearman_sig_pairs,
           file.path(PATH_TABLES, "Table_Spearman_FDR_Pairs.xlsx"),
           rowNames = FALSE)

# Table 4: Cross-method convergence (LASSO ∩ MW)
write.xlsx(convergence_df,
           file.path(PATH_TABLES, "Table_Cross_Method_Convergence.xlsx"),
           rowNames = FALSE)

# Auxiliary: full LASSO + MW tables
write.xlsx(lasso_df_annotated,
           file.path(PATH_TABLES, "Aux_LASSO_All_Selected.xlsx"),
           rowNames = FALSE)
write.xlsx(mw_results,
           file.path(PATH_TABLES, "Aux_MannWhitney_All_Indicators.xlsx"),
           rowNames = FALSE)


message("99_figures_tables.R: all figures and tables regenerated.")
message("Figures written to: ", PATH_FIGURES)
message("Tables written to:  ", PATH_TABLES)
