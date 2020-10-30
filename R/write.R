#' Write
#'
#' Methods for writing version numbers to file
#'
#' @noRd
pbwrite <- structure(list(), class = "pbwrite")


#' Write JSON
#'
#' Update version files
#'
#' @param path path to file
#' @param version string containing the new version number
#'
#' @noRd
pbwrite$json <- function(path, version) {
    status <- file.exists(path)

    if (!status) cli::cli_alert_danger("{.file {path}} does not exist")
    if (status) {
        json <- jsonlite::read_json(path)
        if (is.null(json$version)) {
            cli::cli_alert_info(
                "Added missing property {.val version} to {.file {path}}"
            )
        }

        json$version <- as.character(version)

        tryCatch({
            jsonlite::write_json(
                x = json,
                path = path,
                pretty = TRUE,
                auto_unbox = TRUE
            )
            cli::cli_alert_success("Updated {.file {path}}")
        }, error = function(e) {
            cli::cli_alert_danger("Failed to update {.file {path}}: {e}")
        }, warning = function(w) {
            cli::cli_alert_danger("Failed to update {.file {path}}: {w}")
        })
    }
}


#' Write Description
#'
#' Increment package version number in R's DESCRIPTION file
#'
#' @param path path to file
#' @param version string containing the new version number
#' @param patterns search patterns
#'
#' @noRd
pbwrite$description <- function(path, version, patterns) {
    status <- file.exists(path)
    if (!status) cli::cli_alert_danger("{.file {path}} does not exist")
    if (status) {
        desc <- readLines(path, warn = FALSE)
        desc[grepl(pattern = "Version:", x = desc)] <- paste0(
            "Version: ", version
        )

        tryCatch({
            writeLines(desc, path)
            cli::cli_alert_success("Updated {.file {path}}")
        }, error = function(e) {
            cli::cli_alert_danger("Failed to update {.file {path}}: {e}")
        }, warning = function(w) {
            cli::cli_alert_danger("Failed to update {.file {path}}: {w}")
        })
    }
}

#' Write R files
#'
#' This function will run only if use_* file is present. Use_* files are R
#' files that has a function that is a wrapper around htmlDependency (specific)
#' for Shiny package development. This function updates the argument
#' `version = ...` within that function.
#'
#' @param path location of file
#' @param version string containing the new version number
#' @param patterns search patterns
#'
#' @noRd
pbwrite$r <- function(path, version, patterns) {
    status <- file.exists(path)
    if (!status) cli::cli_alert_danger("{.file {path}} does not exist")
    if (status) {
        r <- readLines(path, warn = FALSE)
        r <- sapply(seq_len(length(r)), function(l) {
            stringr::str_replace_all(
                string = r[l],
                pattern = patterns,
                replacement = paste0("version = \"", version, "\"")
            )
        })

        tryCatch({
            writeLines(r, path)
            cli::cli_alert_success("Updated version number in {.file {path}}")
        }, error = function(e) {
            cli::cli_alert_danger("Failed to update {.file {path}}: {e}")
        }, warning = function(w) {
            cli::cli_alert_danger("Failed to update {.file {path}}: {w}")
        })
    }
}