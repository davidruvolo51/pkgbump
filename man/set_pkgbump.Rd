% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/set_pkgbump.R
\name{set_pkgbump}
\alias{set_pkgbump}
\title{Set Package Files to Manage}
\usage{
set_pkgbump(files, r_patterns = NULL)
}
\arguments{
\item{files}{an array of full file paths}

\item{r_patterns}{a string containing search patterns for R files (optional)}
}
\description{
Use this function to define the files that should be incremented. Use
the argument \code{patterns} to define custom search patterns. Files that are
supported by this package are .json, .R, and R package files (i.e.,
DESCRIPTION).
}
\examples{
\dontrun{
set_pkgbump(files = c("package.json", "DESCRIPTION"))
}

}
