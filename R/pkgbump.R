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
    .validate__file(".pkgbump.json")

    # set default files
    d <- jsonlite::read_json(".pkgbump.json")
    d$files <- as.character(d$files)
    for (i in seq_len(length(d$files))) {

        # description file
        if (d$files[i] == "DESCRIPTION") {
            .write__description(
                path = d$files[i],
                version = version,
                patterns = d$patterns$DESCRIPTION
            )
        }

        # R files (e.g., .R or .r)
        if (grepl(pattern = ".R", x = d$files[i], fixed = TRUE)) {
            .write__r(
                path = d$files[i],
                version = version,
                patterns = d$patterns$R
            )
        }

        # .json files (e.g., "package.json")
        if (grepl(pattern = ".json", x = d$files[i], fixed  = TRUE)) {
            .write__json(
                path = d$files[i],
                version = version
            )
        }

    }

}