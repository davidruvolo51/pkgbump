#'////////////////////////////////////////////////////////////////////////////
#' FILE: dev.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-08-17
#' MODIFIED: 2020-10-29
#' PURPOSE: package management
#' STATUS: ongoing
#' PACKAGES: usethis; devtools; pkgbump
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

# init
#' usethis::use_description()
#' usethis::use_namespace()
#' usethis::use_github_action_check_standard()

# ignore
usethis::use_build_ignore(
    files = c(
        "pkgbump.code-workspace",
        "dev",
        "pkgbump.config.json",
        "package.json"
    )
)

# pkgs
usethis::use_package("cli", min_version = TRUE)
usethis::use_package("jsonlite", min_version = TRUE)
usethis::use_package("stringr", min_version = TRUE)

# prep
devtools::check_man()
devtools::check()

# use pkgbump to manage pkg's version numbers
detach("package:pkgbump")
rm(list = ls())
system("rm -f pkgbump.config.json")
devtools::load_all()

set_pkgbump(
    files = c(
        "DESCRIPTION",     # manage DESCRIPTION file
        "package.json",    # useful for shields.io
        "dev/test_file.R", # this file is for testing purposes only
        "R/set_pkgbump.R", # update version in config json
        "R/config.R"#,       # internal version management for config file
        # "pkgbump.config.json"
    )
)

# set version number
pkgbump(version = "0.0.3")