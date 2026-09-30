# Provenance and verification

| File | Origin |
|---|---|
| `reports/STAT40730_Final_Project_JamesMcClatchie.pdf` | Original supplied 29-page final report; copied unchanged |
| `R/surface_effect.R` | Manual transcription of printed code on pages 21–24; whitespace, comments and wrapped message strings normalised; analytical logic retained |
| `examples/run_surface_comparison.R` | New repository companion, not original assessed code |
| README and documentation | New portfolio documentation grounded in the final report |

The original `.qmd`, standalone `.R` files and `atp_matches_qual_chall_2022.csv` were not located in the connected Drive accounts during repository preparation. They have not been invented or represented as recovered files.

The example follows the report's surface/duration filtering and derived totals. The original ace-rate assignment is not printed in the supplied report, so the example explicitly implements total aces divided by total service points with a non-positive-denominator guard. A plotting seed of 42 stabilises jitter; it is a new presentation choice, not an original analysis seed.

Reported counts and statistics come from the PDF. No new statistical results were generated. R was unavailable in the preparation environment, so the transcribed code and runner have not been executed or independently validated against the original data. No package lockfile or passing-test claim is supplied.

When the original files become available, retain this provenance history, compare the source against the transcription, confirm data provenance/reuse terms and rerun before claiming exact reproducibility.
