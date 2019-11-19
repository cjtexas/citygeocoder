#' geocode
#'
#' find the longitude and latitude for cities/populated places in the US
#'
#' @param search_city character vector
#' @param search_state character vector
#'
#' @import data.table
#'
#' @export
#'
geocode <- function(search_city="Boerne", search_state="TX") {

  .result <-
    citygeocoder::us_cities_dt[paste(city, state) %in% paste(tolower(search_city), tolower(search_state))]

  # merge back with search vectors to preserve original order
  as.data.frame(
    data.table:::merge.data.table(
      data.table::data.table(
        city = tolower(search_city),
        state = tolower(search_state)
      ),
      .result,
      all.x = T,
      sort = F
    )[, c("lon", "lat")]
  )

}
