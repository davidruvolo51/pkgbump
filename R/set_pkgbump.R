#' Set Package Files to Manage
#'
#' Use this function to define the files that should be incremented. Use
#' the argument `patterns` to define custom search patterns. Files that are
#' supported by this package are .json, .R, and R package files (i.e.,
#' DESCRIPTION).
#'
#' @param files an array of full file paths
#' @param patterns define your own search patterns
#'
#' @examples
#' \dontrun{
#'   set_pkgbump(files = c("package.json", "DESCRIPTION"))
#' }
#'
#' @export
set_pkgbump <- function(files, patterns = NULL) {

    file <- ".pkgbump.json"
    status <- file.exists(file)

    # if config does not exist
    if (!status) {
        cli::cli_alert_success(paste0("Creating '", file, "'"))
        file.create(file)

        # create json
        config <- list(
            name = "pkgbump.config",
            updated = Sys.time(),
            n = length(files),
            files = files
        )
    }

    # when config exists
    if (status) {
        config <- jsonlite::read_json(file)
        config$updated <- Sys.time()
        config$n <- length(files)
        config$files <- files
    }

    # append to buildignore if present
    if (file.exists(".Rbuildignore")) {
        r <- readLines(".Rbuildignore", warn = FALSE)
        if (length(r[r == "^\\.pkgbump\\.json$"]) == 0) {
            r <- c(r, "^\\.pkgbump\\.json$")
            write(
                x = r,
                file = ".Rbuildignore",
                sep = "\n"
            )
            cli::cli_alert_success(
                text = "Adding '.pkgbump.json' to '.Rbuildignore'"
            )
        }
    }


    # append patterns
    if (!is.null(patterns)) {
        stopifnot(
            "input for 'patterns' must have the names 'R' or 'DESCRIPTION'" =
            names(patterns) %in% c("R", "desc")
        )
        config$patterns <- patterns
    }

    # set defaults
    if (is.null(patterns)) {
        config$patterns <- list(
            R = "version = | version=",
            DESCRIPTION = "Version:"
        )
    }

    # save and confirm
    jsonlite::write_json(
        x = config,
        path = file,
        pretty = TRUE,
        auto_unbox = TRUE
    )
    cli::cli_alert_success(paste0("Saved '", file, "'"))
}
