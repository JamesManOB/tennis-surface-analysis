# Repository companion added after the assessed project; not original coursework.
# Run from the repository root after placing the original CSV in data/.
# See docs/PROVENANCE.md for reconstruction and validation limits.
library(dplyr)
library(ggplot2)
source("R/surface_effect.R")

input <- "data/atp_matches_qual_chall_2022.csv"
if (!file.exists(input)) {
  stop("Missing original input CSV. See data/README.md before running this example.")
}
matches_raw <- readr::read_csv(input, show_col_types = FALSE)
required <- c("surface", "minutes", "w_ace", "l_ace", "w_df", "l_df", "w_svpt", "l_svpt")
if (!all(required %in% names(matches_raw))) stop("Input does not contain the required columns.")

# Cleaning and totals follow the final report. The guarded division is an
# explicit companion choice because its original source chunk is not visible.
matches <- matches_raw |>
  filter(!is.na(surface), minutes > 0) |>
  mutate(total_aces = w_ace + l_ace,
         total_df = w_df + l_df,
         total_svpt = w_svpt + l_svpt,
         aces_per_svpt = if_else(total_svpt > 0, total_aces / total_svpt, NA_real_))

se_minutes <- surface_effect(matches, "minutes")
se_ace_rate <- surface_effect(matches, "aces_per_svpt")
print(se_minutes)
summary(se_minutes)
print(se_ace_rate)
summary(se_ace_rate)
set.seed(42) # Stabilises visual jitter only; not an original analysis seed.
print(plot(se_minutes))
print(plot(se_ace_rate))
