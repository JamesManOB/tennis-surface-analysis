# Transcribed from James McClatchie's STAT40730 final report, pp. 21–24.
# Formatting and wrapped strings normalised; analytical logic preserved.
# This is not the original .R/.qmd file. See docs/PROVENANCE.md.

surface_effect = function(data, response, group = "surface",
                          drop_na = TRUE, run_test = TRUE) {
  if (!is.data.frame(data)) stop("data must be a data.frame or tibble.")
  if (!is.character(response) || length(response) != 1) {
    stop("response must be a single character string naming a numeric column.")
  }
  if (!is.character(group) || length(group) != 1) {
    stop("group must be a single character string naming a grouping column.")
  }
  if (!response %in% names(data)) stop("response column not found in data: ", response)
  if (!group %in% names(data)) stop("group column not found in data: ", group)
  if (!is.numeric(data[[response]])) stop("response column must be numeric: ", response)

  df = data |>
    dplyr::select(dplyr::all_of(c(group, response)))
  if (isTRUE(drop_na)) {
    df = df |>
      dplyr::filter(!is.na(.data[[group]]), !is.na(.data[[response]]))
  }
  summary_tbl = df |>
    dplyr::group_by(.data[[group]]) |>
    dplyr::summarise(
      n = dplyr::n(),
      mean = mean(.data[[response]]),
      median = median(.data[[response]]),
      sd = sd(.data[[response]]),
      min = min(.data[[response]]),
      max = max(.data[[response]]),
      .groups = "drop"
    ) |>
    dplyr::rename(group_value = 1)

  test_out = NULL
  if (isTRUE(run_test)) {
    if (dplyr::n_distinct(df[[group]]) >= 2) {
      test_out = stats::kruskal.test(df[[response]] ~ df[[group]])
    }
  }
  out = list(call = match.call(), response = response, group = group,
             data_used = df, summary_tbl = summary_tbl, test = test_out)
  class(out) = "surface_effect"
  out
}

print.surface_effect <- function(x, ...) {
  n_total <- nrow(x$data_used)
  n_groups <- dplyr::n_distinct(x$data_used[[x$group]])
  grp_vals <- sort(unique(as.character(x$data_used[[x$group]])))
  cat("surface_effect object\n")
  cat(" Response:", x$response, "\n")
  cat(" Grouping variable:", x$group, "\n")
  cat(" Observations used:", n_total, "\n")
  cat(" Number of groups:", n_groups, "\n")
  cat(" Groups:", paste(grp_vals, collapse = ", "), "\n")
  invisible(x)
}

summary.surface_effect <- function(object, ...) {
  cat("Summary for surface_effect\n")
  cat(" Response:", object$response, "\n")
  cat(" Grouping variable:", object$group, "\n\n")
  cat("Group-wise descriptive statistics:\n")
  print(object$summary_tbl)
  if (!is.null(object$test)) {
    cat("\nKruskal–Wallis test (non-parametric):\n")
    cat(" H0: the distribution of", object$response,
        "is the same across", object$group, "\n")
    cat(" statistic:", unname(object$test$statistic), "\n")
    cat(" df:", unname(object$test$parameter), "\n")
    cat(" p-value:", object$test$p.value, "\n")
  } else {
    cat("\nKruskal–Wallis test was not run (or insufficient groups).\n")
  }
  invisible(object)
}

plot.surface_effect <- function(x, ...) {
  df <- x$data_used
  ggplot2::ggplot(df, ggplot2::aes(x = .data[[x$group]], y = .data[[x$response]])) +
    ggplot2::geom_boxplot(outlier.alpha = 0.3) +
    ggplot2::geom_jitter(width = 0.15, alpha = 0.2) +
    ggplot2::labs(title = paste("Distribution of", x$response, "by", x$group),
                  x = x$group, y = x$response)
}
