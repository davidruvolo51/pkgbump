#' Named Attributes Only
#'
#' For optional arguments defined via `...`, return only named arguments.
#'
#' @param ... optional arguments
#'
#' @noRd
.named_attribs_only <- function(...) {
    list(...)[names(list(...)) != ""]
}


#' Validate File Path
#'
#' Confirm that the file exists
#'
#' @param path a file path to validate
#'
#' @noRd
.validate__file <- function(path) {
    if (!file.exists(path)) {
        msg <- paste0("File '", path, "' does not exist")
        cli::cli_alert_danger(msg)
    }
}

#' Write json files
#'
#' @param path file path to package.json file
#' @param version version number to write
#'
#' @noRd
.write__json <- function(path, version) {
    .validate__file(path)

    # read and warn if version property is missing
    json <- jsonlite::read_json(path)
    if (is.null(json$version)) {
        cli::cli_alert_warning("Adding missing property 'version'")
    }

    json$version <- as.character(version)

    # save and confirm
    jsonlite::write_json(
        x = json,
        path = path,
        pretty = TRUE,
        auto_unbox = TRUE
    )
    cli::cli_alert_success("Updated version number in 'package.json'")

}

#' Update DESCRIPTION file
#'
#' Increment package version number in DESCRIPTION file
#'
#' @param path path to file
#' @param version version number to save
#' @param patterns search patterns
#'
#' @noRd
.write__description <- function(path, version, patterns) {
    .validate__file(path)

    desc <- readLines(path, warn = FALSE)
    desc[grepl(pattern = patterns, x = desc)] <- paste0("Version: ", version)

    # save and confirm
    writeLines(desc, path)
    cli::cli_alert_success("Updated version number in 'DESCRIPTION'")
}

#' Update R files
#'
#' This function will run only if use_* file is present. Use_* files are R
#' files that has a function that is a wrapper around htmlDependency (specific)
#' for Shiny package development. This function updates the argument
#' `version = ...` within that function.
#'
#' @param path location of file
#' @param version version number to write
#' @param leftpad amount of spacing to add
#' @param patterns search patterns
#'
#' @noRd
.write__r <- function(path, version, leftpad = 8, patterns) {
    .validate__file(path)

    r <- readLines(path, warn = FALSE)
    r[grepl(pattern = patterns, x = r)] <- paste0(
        paste0(rep(" ", leftpad), collapse = ""),
        "version = \"", version, "\","
    )

    # save and confirm
    writeLines(r, path)
    cli::cli_alert_success(
        paste0("Updated version number in '", path, "'")
    )
}