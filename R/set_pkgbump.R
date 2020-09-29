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

    # when config exists
    f <- ".pkgbump.json"
    if (file.exists(f)) {
        cli::cli_alert_success("Updated {.pkg pkgbump} configuration")
        c <- jsonlite::read_json(f)
        c$timestamps$updated <- Sys.time()
        c$config$files <- length(files)
        c$config$paths <- files
    } else {

        cli::cli_alert_success("Created {.file {f}}")
        file.create(f)

        # create json
        c <- list(
            name = "pkgbump",
            version = "0.0.2",
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

    # append to buildignore if present
    if (file.exists(".Rbuildignore")) {
        .append__rbuild(pattern = "^\\.pkgbump\\.json$")
    }


    # set patterns (either default or user specified)
    c$config$patterns <- list(
        R = "version = .\\d+.\\d+.\\d+.|version=.\\d+.\\d+.\\d+.",
        DESCRIPTION = "Version:"
    )
    if (!is.null(r_patterns)) {
        if (!is.character(r_patterns)) {
            cli::cli_alert_warning("Error: R patterns must be a string")
        } else if (length(r_patterns) > 1) {
            cli::cli_alert_warning(
                "Error: More than 1 R pattern entered. Input should be a string"
            )
        } else {
            c$patterns$R <- r_patterns
        }
    }

    # save and confirm
    jsonlite::write_json(
        x = c,
        path = f,
        pretty = TRUE,
        auto_unbox = TRUE
    )
    cli::cli_alert_success("Saved {.file {f}}")
}
