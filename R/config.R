#' Pkgbump Config
#'
#' Methods for validating and managing the configuration file
#'
#' @noRd
pbconfig <- structure(list(), version = "0.0.3", class = "config")

#' pkgbump config filename
#'
#' @noRd
pbconfig$filename <- "pkgbump.config.json"

#' New Pkgbump Config Template
#'
#' @param files array containing file paths to ignore
#'
#' @noRd
pbconfig$new_config <- function(files) {
    list(
        name = "pkgbump.config.json",
        version = attr(pbconfig, "version"),
        description = "pkgbump config file",
        timestamps = list(
            created = Sys.time(),
            updated = Sys.time()
        ),
        config = list(
            files = length(files),
            paths = files,
            patterns = list(
                R = "version = .\\d+.\\d+.\\d+.|version=.\\d+.\\d+.\\d+.",
                DESCRIPTION = "Version:"
            )
        ),
        dependencies = list(
            cli = "^2.1.0",
            jsonlite = "^1.7.1",
            stringr = "^1.4.0"
        ),
        license = "MIT",
        author = "@dcruvolo",
        bugs = list(
           url = "https://github.com/davidruvolo51/pkgbump/issues"
        )
    )
}


#' Add pkgbump config filename to Rbuildignore
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
            cli::cli_alert_danger(
                "Failed to update {.file .Rbuildignore: \n {e}"
            )
        }, warning = function(w) {
            cli::cli_alert_danger(
                "Failed to update {.file .Rbuildignore: \n {w}"
            )
        })
    }
    if (length(r[r == pattern]) > 0) {
        cli::cli_alert_info(
            "{.val {pattern}} is already present in {.file .Rbuildignore}"
        )
    }
}
