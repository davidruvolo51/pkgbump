#' Update Package Version Number
#'
#' Auto-increment package version number for across tracked package files.
#' This was originally intented to update version numbers in the DESCRIPTION,
#' package.json, and use_*.R files. Use the function `set_pkgbump` to define
#' which files should be mananaged by pkgbump.
#'
#' @param version version number to write
#'
#' @return Update package version number in tracked files
#'
#' @examples
#' \dontrun{
#'   pkgbump(version = "1.0.0")
#' }
#'
#' @export
pkgbump <- function(version) {

    f <- ".pkgbump.json"
    response <- file.exists(f)

    if (!response) {
        cli::cli_alert_danger(
            "Error: Unable to locate configuration file {.file {f}}."
        )
    }

    if (response) {
        d <- jsonlite::read_json(f)
        d$config$paths <- as.character(d$config$paths)
        for (i in seq_len(length(d$config$paths))) {

            # description file
            if (d$config$paths[i] == "DESCRIPTION") {
                .write__description(
                    path = d$config$paths[i],
                    version = version,
                    patterns = d$config$patterns$DESCRIPTION
                )
            }

            # R files (e.g., .R or .r)
            if (grepl(pattern = ".R", x = d$config$paths[i], fixed = TRUE)) {
                .write__r(
                    path = d$config$paths[i],
                    version = version,
                    patterns = d$config$patterns$R
                )
            }

            # .json files (e.g., "package.json")
            if (grepl(pattern = ".json", x = d$config$paths[i], fixed  = TRUE)) {
                .write__json(
                    path = d$config$paths[i],
                    version = version
                )
            }
        }
    }
}