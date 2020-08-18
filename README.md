<!-- badges: start -->
![R-CMD-check](https://github.com/davidruvolo51/pkgbump/workflows/R-CMD-check/badge.svg?branch=prod)
<!-- badges: end -->

# pkgbump

A quick and dirty way to update a package's version number during package development.

## Install

Install this package using `devtools`.

```r
devtools::install_github("davidruvolo51/pkgbump")
```

## Use

To use `pkgbump`, use `set_pkgbump` to track files that should be managed by this package. This will create a configuration file `.pkgbump.json` in your local project directory. The function `pkgbump` will update the version number in each of these files.

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

I would recommend creating a package management script in the `dev` directory (see the `dev` directory of this project for an example) and writing the `pkgbump` configuration in that file.