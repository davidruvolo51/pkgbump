<!-- badges: start --->
![version](https://img.shields.io/github/package-json/v/davidruvolo51/pkgbump/prod)
[![R build status](https://github.com/davidruvolo51/pkgbump/workflows/R-CMD-check/badge.svg)](https://github.com/davidruvolo51/pkgbump/actions)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end --->

# pkgbump

A quick and dirty way to update a package's version number across internal files.

## Install

At the moment, `pkgbump` is not available CRAN. Instead, you can install the latest release using the `devtools` or `remotes` packages.

```r
remotes::install_github("davidruvolo51/pkgbump@*release")
```

## Use

To use `pkgbump`, use `set_pkgbump` to track files that you would like to managed. This will create a configuration file `.pkgbump.json` in your local project directory. The function `pkgbump` will update the version number in each of these files.

```r
# init configuration file
pkgbump::set_pkgbump(
    files = c(
        "DESCRIPTION",
        "package.json"
    )
)

# set version number
pkgbump::pkgbump(version = "0.0.1")
```

At the moment, this package supports R's `DESCRIPTION` file, `.json` files, and `.R` files. `.json` files are updated using the `jsonlite` package and adding or updating the property `version`. Updating the `DESCRIPTION` file works by finding and updating the entire `Version:` line.

R files are a bit trickier as all instances of `version` could appear in a variety of formats. The default patterns for R files will find and replace all instances `version = "0.0.0"`. You can add your own R search patterns using the `r_patterns` argument in `set_pkgbump`. Please be are that R patterns are passed on to `stringr::str_replace_all()`.

```r
pkgbump::set_pkgbump(
    files = c(
        "R/my_file.R"
    ),
    r_patterns = "..."
)
```

I would recommend creating a package management script in the `dev` directory (see the `dev` directory of this project for an example) and writing the `pkgbump` configuration in that file.

## To Do

- [ ] Detect outdated config files and rebuild
- [ ] Refactor `write` function
- [ ] Refactor `set_pkgbump` function
- [ ] Refactor config file contents and fix timestamps
