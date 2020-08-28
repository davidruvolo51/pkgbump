#' Append Rbuildignore
#'
#' Add pattern to .Rbuildignore file
#'
#' @param pattern pattern to ignore
#'
#' @noRd
.append__rbuild <- function(pattern) {
    r <- readLines(".Rbuildignore", warn = FALSE)
    if (length(r[r == pattern]) == 0) {
        r <- c(r, pattern)
        write(
            x = r,
            file = ".Rbuildignore",
            sep = "\n"
        )
        cli::cli_alert_success(
            paste0("Added '", pattern, "' to '.Rbuildignore'")
        )
    }
}

#' Write json files
#'
#' @param path file path to package.json file
#' @param version version number to write
#'
#' @noRd
.write__json <- function(path, version) {
    if (file.exists(path)) {
        json <- jsonlite::read_json(path)
        if (is.null(json$version)) {
            cli::cli_alert_info(
                paste0(
                    "Added missing property 'version' to '",
                    path, "'"
                )
            )
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

    } else {
        cli::cli_alert_danger(
            paste0("File '", path, "'", "does not exist.")
        )
    }

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
    if (file.exists(path)) {
        desc <- readLines(path, warn = FALSE)
        desc[grepl(pattern = patterns, x = desc)] <- paste0(
            "Version: ", version
        )

        # save and confirm
        writeLines(desc, path)
        cli::cli_alert_success("Updated version number in 'DESCRIPTION'")
    } else {
        cli::cli_alert_danger(
            paste0("File '", path, "'", "does not exist.")
        )
    }
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
#' @param patterns search patterns
#'
#' @noRd
.write__r <- function(path, version, patterns) {
    if (file.exists(path)) {
        r <- readLines(path, warn = FALSE)
        r <- sapply(seq_len(length(r)), function(l) {
            stringr::str_replace_all(
                string = r[l],
                pattern = patterns,
                replacement = paste0("version = \"", version, "\"")
            )
        })

        # save and confirm
        writeLines(r, path)
        cli::cli_alert_success(
            paste0("Updated version number in '", path, "'")
        )
    } else {
        cli::cli_alert_danger(
            paste0("File '", path, "'", "does not exist.")
        )
    }
}