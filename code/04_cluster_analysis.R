# =============================================================================
# 04_cluster_analysis.R — k-means clustering on the DHMI vector
# =============================================================================
#
# Purpose : Group the 53 Member States into three maturity clusters using
#           k-means (k = 3) on the one-dimensional DHMI_scaled vector. The k
#           value is selected via the elbow criterion; k = 2 and k = 4 are
#           reported as robustness checks (silhouette + Dunn index). Cluster
#           labels are assigned by ascending centroid value.
#
# Inputs  : data/processed/DHMI_scores_final.csv
#
# Outputs : data/processed/cluster_assignments.csv
#               (53 × {COUNTRY_REGION, DHMI_scaled, Cluster, Cluster_Label,
#                       Cluster_Companion_Label})
#           data/processed/cluster_quality_metrics.csv
#               (silhouette and Dunn for k = 2, 3, 4)
#
# Companion-paper bridge: in `companion_paper_bridge/README_bridge.md`, the
# three clusters are renamed for theoretical legibility:
#   High Maturity   → Comprehensive Adopters
#   Medium Maturity → Emerging Adopters
#   Low Maturity    → Fragmented Adopters
# Both labels are emitted in cluster_assignments.csv.
#
# Dependencies : 00_setup.R, 02_dhmi_construction.R
# =============================================================================

source("code/00_setup.R")


# -----------------------------------------------------------------------------
# 4.1  Load DHMI scores
# -----------------------------------------------------------------------------
country_maturity <- read_csv(file.path(PATH_PROCESSED, "DHMI_scores_final.csv"),
                             show_col_types = FALSE)

country_maturity_clean <- country_maturity %>%
  filter(!is.na(DHMI_scaled))


# -----------------------------------------------------------------------------
# 4.2  Run k-means at k = 2, 3, 4 for quality comparison
# -----------------------------------------------------------------------------
set.seed(123)

cluster_quality <- list()
for (k in c(2, 3, 4)) {
  km  <- kmeans(country_maturity_clean$DHMI_scaled, centers = k, nstart = 25)
  sil <- silhouette(km$cluster, dist(country_maturity_clean$DHMI_scaled))
  d   <- dist(country_maturity_clean$DHMI_scaled)
  # Dunn index: min(inter-cluster distance) / max(intra-cluster diameter)
  dunn <- tryCatch(
    cluster::clusGap(matrix(country_maturity_clean$DHMI_scaled, ncol = 1),
                     FUN = kmeans, K.max = 4, B = 50, nstart = 25),
    error = function(e) NULL
  )
  cluster_quality[[as.character(k)]] <- data.frame(
    k          = k,
    silhouette = round(mean(sil[, 3]), 4),
    # Approximate Dunn via inter/intra cluster ratio (simple implementation)
    dunn       = round({
      max_intra <- 0
      min_inter <- Inf
      for (i in unique(km$cluster)) {
        pts_i <- country_maturity_clean$DHMI_scaled[km$cluster == i]
        if (length(pts_i) > 1) max_intra <- max(max_intra,
                                                 max(dist(pts_i)))
        for (j in unique(km$cluster)) {
          if (i < j) {
            pts_j <- country_maturity_clean$DHMI_scaled[km$cluster == j]
            inter_d <- min(as.matrix(dist(c(pts_i, pts_j)))[1:length(pts_i),
                                                            (length(pts_i)+1):(length(pts_i)+length(pts_j))])
            min_inter <- min(min_inter, inter_d)
          }
        }
      }
      if (max_intra > 0) min_inter / max_intra else NA_real_
    }, 4)
  )
}
cluster_quality_df <- bind_rows(cluster_quality)
print(cluster_quality_df)


# -----------------------------------------------------------------------------
# 4.3  Adopt k = 3 as the primary solution
# -----------------------------------------------------------------------------
set.seed(123)
kmeans_result <- kmeans(country_maturity_clean$DHMI_scaled,
                        centers = 3, nstart = 25)

cluster_order <- order(kmeans_result$centers[, 1])
label_map <- setNames(
  c("Low Maturity", "Medium Maturity", "High Maturity"),
  cluster_order
)
companion_label_map <- setNames(
  c("Fragmented Adopters", "Emerging Adopters", "Comprehensive Adopters"),
  cluster_order
)

country_maturity_clean <- country_maturity_clean %>%
  mutate(
    Cluster                  = kmeans_result$cluster,
    Cluster_Label            = factor(
      label_map[as.character(Cluster)],
      levels = c("Low Maturity", "Medium Maturity", "High Maturity")
    ),
    Cluster_Companion_Label  = factor(
      companion_label_map[as.character(Cluster)],
      levels = c("Fragmented Adopters", "Emerging Adopters", "Comprehensive Adopters")
    )
  )

sil <- silhouette(kmeans_result$cluster, dist(country_maturity_clean$DHMI_scaled))
message(sprintf("k = 3 silhouette = %.3f", mean(sil[, 3])))

message("\nCluster distribution:")
print(table(country_maturity_clean$Cluster_Label))
print(
  country_maturity_clean %>%
    group_by(Cluster_Label) %>%
    summarise(n = n(), Mean_DHMI = round(mean(DHMI_scaled), 1),
              Min = round(min(DHMI_scaled), 1), Max = round(max(DHMI_scaled), 1))
)


# -----------------------------------------------------------------------------
# 4.4  Write outputs
# -----------------------------------------------------------------------------
write_csv(country_maturity_clean,
          file.path(PATH_PROCESSED, "cluster_assignments.csv"))
write_csv(cluster_quality_df,
          file.path(PATH_PROCESSED, "cluster_quality_metrics.csv"))

message("04_cluster_analysis.R: wrote cluster_assignments.csv and cluster_quality_metrics.csv")
