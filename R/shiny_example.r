#' shiny_example
#'
#' Launch example shiny app for citygeocode package
#'
shiny_example <- function() {
  appDir <- system.file("shiny-examples", package = "citygeocoder")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `citygeocoder`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
