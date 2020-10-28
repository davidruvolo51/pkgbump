#' Append Rbuildignore
#'
#' Add pattern to .Rbuildignore file
#'
#' @param pattern pattern to ignore
#'
#' @noRd
.append__rbuild <- function(pattern) {
    r <- readLines(".Rbuildignore", warn = FALSE)
    if (length(r[r == pattern]) == 0) {
        r <- c(r, pattern)
        write(
            x = r,
            file = ".Rbuildignore",
            sep = "\n"
        )
        cli::cli_alert_success(
            "Added {.val {pattern}} to {.file .Rbuildignore}"
        )
    }
}
