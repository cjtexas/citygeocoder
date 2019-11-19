
.onLoad <- function(libpath, pkgname) {
  data("us_cities_dt", package = "citygeocoder", envir = parent.env(environment()))
}
