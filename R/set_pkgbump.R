#' Set Package Files to Manage
#'
#' Use this function to define the files that should be incremented. Use
#' the argument `patterns` to define custom search patterns. Files that are
#' supported by this package are .json, .R, and R package files (i.e.,
#' DESCRIPTION).
#'
#' @param files an array of full file paths
#' @param r_patterns a string containing search patterns for R files (optional)
#'
#'
#' @examples
#' \dontrun{
#'   set_pkgbump(files = c("package.json", "DESCRIPTION"))
#' }
#'
#' @export
set_pkgbump <- function(files, r_patterns = NULL) {
    f <- pbconfig$filename
    status <- file.exists(f)

    if (status) {
        c <- jsonlite::read_json(f)
        cli::cli_alert_success("Updated {.pkg pkgbump} configuration")
        c$timestamps$updated <- Sys.time()
        c$config$files <- length(files)
        c$config$paths <- files
    }

    if (!status) {
        cli::cli_alert_success("Created {.file {f}}")
        file.create(f)
        c <- pbconfig$new_config(files = files)
    }

    # append to buildignore if present
    if (file.exists(".Rbuildignore")) {
        pbconfig$ignore_config()
    }


    # append R patterns if applicable
    if (!is.null(r_patterns)) {
        if (!is.character(r_patterns)) {
            cli::cli_alert_danger("{.arg patterns} must be a string")
        } else if (length(r_patterns) > 1) {
            cli::cli_alert_danger("{.arg patterns} must be a string")
        } else {
            c$patterns$R <- r_patterns
        }
    }

    # save and confirm
    tryCatch({
        jsonlite::write_json(
            x = c,
            path = f,
            pretty = TRUE,
            auto_unbox = TRUE
        )
        cli::cli_alert_success("Saved {.file {f}}")
    }, error = function(e) {
        cli::cli_alert_danger("Failed to update {.file {f}}: {e}")
    }, warning = function(w) {
        cli::cli_alert_danger("Failed to update {.file {f}}: {w}")
    })
}
