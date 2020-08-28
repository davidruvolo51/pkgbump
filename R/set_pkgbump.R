#' Set Package Files to Manage
#'
#' Use this function to define the files that should be incremented. Use
#' the argument `patterns` to define custom search patterns. Files that are
#' supported by this package are .json, .R, and R package files (i.e.,
#' DESCRIPTION).
#'
#' @param files an array of full file paths
#' @param r_patterns a string containing search patterns for R files
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
    if (file.exists(".pkgbump.json")) {
        config <- jsonlite::read_json(".pkgbump.json")
        config$updated <- Sys.time()
        config$n <- length(files)
        config$files <- files
    } else {

        cli::cli_alert_success("Created config file '.pkgbump.json'")
        file.create(".pkgbump.json")

        # create json
        config <- list(
            name = "pkgbump.config",
            updated = Sys.time(),
            n = length(files),
            files = files
        )
    }

    # append to buildignore if present
    if (file.exists(".Rbuildignore")) {
        .append__rbuild(pattern = "^\\.pkgbump\\.json$")
    }


    # set patterns (either default or user specified)
    config$patterns <- list(
        R = "version = .\\d+.\\d+.\\d+.|version=.\\d+.\\d+.\\d+.",
        DESCRIPTION = "Version:"
    )
    if (!is.null(r_patterns)) {
        if (!is.character(r_patterns)) {
            cli::cli_alert_danger(
                "R patterns must be a string"
            )
        } else if (length(r_patterns) > 1) {
            cli::cli_alert_danger(
                "More than 1 R pattern entered. Input should be a string"
            )
        } else {
            config$patterns$R <- r_patterns
        }
    }

    # save and confirm
    jsonlite::write_json(
        x = config,
        path = ".pkgbump.json",
        pretty = TRUE,
        auto_unbox = TRUE
    )
    cli::cli_alert_success("Saved '.pkgbump.json'")
}
