
.onLoad <- function(libpath, pkgname) {
  utils::data("us_cities_dt", package = "citygeocoder", envir = parent.env(environment()))
}
