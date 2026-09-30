# Method and implementation notes

## Analysis

- Duration filtering retains non-missing surfaces and positive minutes, rather than checking a whitelist of recognised surface labels.
- Summary counts in the report's Part 1 are all rows in each group even when a particular serve statistic is missing. Per-outcome complete-case counts are preferable when interpreting serve measures.
- `get_dupes(minutes)` identifies shared duration values. It is not a match-identity deduplication procedure.
- Kruskal–Wallis testing is inferential despite a sentence in the original conclusion saying inferential modelling was not incorporated. This repository describes the actual tests shown in Part 3.
- An omnibus test detects distributional differences under its assumptions. Interpreting it solely as a median comparison requires additional distribution-shape assumptions.
- Unequal sample sizes do not by themselves prove biased means. They affect precision and motivate caution, especially for Carpet.

## Original S3 implementation

The transcribed function preserves the report's behaviour rather than silently revising the coursework:

- `drop_na = TRUE` removes missing group/response values, but does not explicitly remove infinite values.
- With `drop_na = FALSE`, summary calls do not use `na.rm = TRUE`; missing values can propagate. The test's default missing-value handling may differ from the displayed summaries.
- Empty samples, all-identical responses, and malformed logical options are not comprehensively handled.
- Testing is attempted only when at least two distinct groups are present; no pairwise post-hoc tests are included.
- Jitter positions are random unless the caller sets a seed.
- `print()` and `summary()` invisibly return the original object; `plot()` returns a ggplot object.

This is an educational reusable function, not a production-hardened statistical package.
