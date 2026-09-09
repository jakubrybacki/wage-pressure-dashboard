# ==============================================================================
# DATA PREPARATION & LOCAL CACHE EXPORT FOR WAGE PRESSURE QUARTO DASHBOARD
# ==============================================================================

library(readxl)
library(dplyr)
library(tidyr)
library(readr)
library(jsonlite)
library(lubridate)

args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("--file=", args, value = TRUE)
script_dir <- if (length(file_arg) > 0) {
  dirname(normalizePath(sub("--file=", "", file_arg), winslash = "/"))
} else {
  file.path(getwd(), "Wage-spiral tracker", "quarto_dashboard")
}

# Paths
base_dir <- normalizePath(file.path(script_dir, ".."), winslash = "/")
excel_path <- file.path(base_dir, "output_wage_pressure_pca.xlsx")
target_dir <- script_dir

if (!file.exists(excel_path)) {
  stop("Excel file not found at: ", excel_path)
}

message("Loading data from: ", excel_path)

# 1. PCA Indices (Long)
df_indices <- read_excel(excel_path, sheet = "Indeksy_PCA_Dlugie") %>%
  mutate(
    date = as.Date(parse_date_time(date, orders = c("ymd", "ym", "Ymd", "Ym"))),
    pca_raw = as.numeric(round(pca_raw, 4)),
    wage_pressure_index = as.numeric(round(wage_pressure_index, 2)),
    wage_pressure_ma3m  = as.numeric(round(wage_pressure_ma3m, 2)),
    wage_pressure_ma12m = as.numeric(round(wage_pressure_ma12m, 2))
  ) %>%
  filter(!is.na(date)) %>%
  arrange(geo, date)

write_csv(df_indices, file.path(target_dir, "wage_spiral_pca_indices.csv"))
message("  -> Wrote wage_spiral_pca_indices.csv (", nrow(df_indices), " rows)")

# 2. Raw Harmonized / Deseasonalized Components (Long)
df_components <- read_excel(excel_path, sheet = "Dane_Surowe_Zharmonizowane") %>%
  rename(
    Date = Date,
    Country = Country,
    Geo = Geo,
    Term = Term,
    Interest = Interest
  ) %>%
  mutate(
    Date = as.Date(parse_date_time(Date, orders = c("ymd", "ym", "Ymd", "Ym"))),
    Interest = as.numeric(round(Interest, 2))
  ) %>%
  filter(!is.na(Date)) %>%
  arrange(Geo, Term, Date)

write_csv(df_components, file.path(target_dir, "wage_spiral_tracker_long.csv"))
message("  -> Wrote wage_spiral_tracker_long.csv (", nrow(df_components), " rows)")

# 3. PCA Loadings & Explained Variance
df_loadings <- read_excel(excel_path, sheet = "Wagi_Ladunki_PCA") %>%
  mutate(
    pca_loading = as.numeric(round(pca_loading, 4)),
    var_explained_pct = as.numeric(round(var_explained_pct, 2))
  )

write_csv(df_loadings, file.path(target_dir, "wage_spiral_pca_loadings.csv"))
message("  -> Wrote wage_spiral_pca_loadings.csv (", nrow(df_loadings), " rows)")

# 4. Generate precomputed country_latest_stats.json for rapid scorecards
geos <- c("PL", "DE", "ES", "NL", "FR", "IT")
geo_names <- c("Poland", "Germany", "Spain", "Netherlands", "France", "Italy")

stats_list <- list()

for (i in seq_along(geos)) {
  g <- geos[i]
  c_name <- geo_names[i]
  
  df_g <- df_indices %>% filter(geo == g) %>% arrange(date)
  n <- nrow(df_g)
  
  if (n > 0) {
    latest_row <- df_g[n, ]
    latest_date <- format(latest_row$date, "%b %Y")
    current_ma12 <- latest_row$wage_pressure_ma12m
    current_ma3  <- latest_row$wage_pressure_ma3m
    current_raw  <- latest_row$wage_pressure_index
    
    # 1-year YoY change in MA 12M
    prev_year_row <- if (n >= 13) df_g[n - 12, ] else df_g[1, ]
    yoy_change <- round(current_ma12 - prev_year_row$wage_pressure_ma12m, 1)
    
    # 3-year change in MA 12M
    prev_3y_row <- if (n >= 37) df_g[n - 36, ] else df_g[1, ]
    change_3y <- round(current_ma12 - prev_3y_row$wage_pressure_ma12m, 1)
    
    # Historical Peak & Min
    peak_val <- max(df_g$wage_pressure_ma12m, na.rm = TRUE)
    peak_date <- format(df_g$date[which.max(df_g$wage_pressure_ma12m)], "%b %Y")
    min_val <- min(df_g$wage_pressure_ma12m, na.rm = TRUE)
    
    # Loadings info
    df_load_g <- df_loadings %>% filter(geo == g)
    var_exp <- if (nrow(df_load_g) > 0) df_load_g$var_explained_pct[1] else 100.0
    
    # Status label based on current level and trend
    status_tag <- if (current_ma12 >= 85) {
      "Very High"
    } else if (current_ma12 >= 70) {
      "High"
    } else if (current_ma12 >= 50) {
      "Moderate"
    } else {
      "Subdued"
    }
    
    stats_list[[g]] <- list(
      geo = g,
      country = c_name,
      latest_period = latest_date,
      current_ma12 = current_ma12,
      current_ma3 = current_ma3,
      current_raw = current_raw,
      yoy_change = yoy_change,
      change_3y = change_3y,
      peak_value = peak_val,
      peak_period = peak_date,
      min_value = min_val,
      var_explained = var_exp,
      status = status_tag
    )
  }
}

write_json(stats_list, file.path(target_dir, "country_latest_stats.json"), pretty = TRUE, auto_unbox = TRUE)
message("  -> Wrote country_latest_stats.json (", length(stats_list), " countries)")
message("[DONE] Data preparation completed successfully.")
