#' pkgbump test file
#'
#' Use this file to test pattern matching in R files.
#'


#' Test as function argument
#'
#' @param version version number as a string
#'
#' @noRd
some_function <- function(version) {
    stopifnot(is.character(version))
    print(version)
}

some_function(version = "0.0.13")


#' Test inside GOLEM app_server
#'
#' @param version ...
#'
#' @noRd
app_server <- function(input, output, session) {
    d <- analytics$new(version = "0.0.13")
    observe({
        print(version = "0.0.13")
    })
}
