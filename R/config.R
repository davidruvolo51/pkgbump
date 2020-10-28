#' Pkgbump Config
#'
#' Methods for validating and managing the configuration file
#'
#' @noRd
pbconfig <- structure(list(), class = "config")


#' New Pkgbump Config Template
#'
#' @param version string containing the pkgbump package's version number
#' @param files array containing file paths to ignore
#'
#' @noRd
pbconfig$new_config <- function(version, files) {
    list(
        name = "pkgbump",
        version = version,
        description = "config file for version number management",
        timestamps = list(
            created = Sys.time(),
            updated = Sys.time()
        ),
        config = list(
            files = length(files),
            paths = files
        )
    )
}


#' Add to Rbuildignore
#'
#' Add pkgbump filename to .Rbuildignore file
#'
#' @param pattern pattern to ignore
#'
#' @noRd
pbconfig$ignore_config <- function(pattern = "^\\.pkgbump\\.json$") {
    r <- readLines(".Rbuildignore", warn = FALSE)
    if (length(r[r == pattern]) == 0) {
        r <- c(r, pattern)
        tryCatch({
            write(x = r, file = ".Rbuildignore", sep = "\n")
            cli::cli_alert_success(
                "Added {.val {pattern}} to {.file .Rbuildignore}"
            )
        }, error = function(e) {
            cli::cli_alert_danger("Failed to update {.file .Rbuildignore: {e}")
        }, warning = function(w) {
            cli::cli_alert_danger("Failed to update {.file .Rbuildignore: {w}")
        })
    }
    if (length(r[r == pattern]) > 0) {
        cli::cli_alert_info(
            "{.val {pattern}} is already present in {.file .Rbuildignore}"
        )
    }
}