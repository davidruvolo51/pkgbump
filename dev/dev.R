#'////////////////////////////////////////////////////////////////////////////
#' FILE: dev.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-08-17
#' MODIFIED: 2020-08-26
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
        ".pkgbump.json"
    )
)

# pkgs
usethis::use_package("cli")
usethis::use_package("jsonlite")
usethis::use_package("stringr")

# prep
devtools::check_man()
devtools::check()

# use pkgbump to manage pkg's version numbers
detach("package:pkgbump")
devtools::load_all()

set_pkgbump(
    files = c(
        "DESCRIPTION",     # manage DESCRIPTION file
        "package.json",    # useful for shields.io
        "dev/test_file.R"  # this file is for testing purposes only
    )
)

# set version number
pkgbump(version = "0.0.13")