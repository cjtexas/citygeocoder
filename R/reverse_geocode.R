#' reverse_geocode
#'
#' find the closest US city/populated place to any given longitude/latitude pair(s)
#'
#' @param lon numeric vector
#' @param lat numeric vector
#'
#' @export
#'
reverse_geocode <- function(lon=-101.68181, lat=34.61681) {

  stopifnot(is.numeric(lon) & is.numeric(lat))

  distances <- .pair_dist(cbind(lon, lat), as.matrix(citygeocoder::us_cities_dt[, c("lon", "lat")]))
  distances_mat <- as.matrix(distances, length(lon))
  closest <- apply(distances_mat, 1, which.min)

  # extract the distance to the nearest neighbor
  closest_distances <-
    sapply(seq_along(closest), function(i){
      distances_mat[i, closest[i]]
    })

  as.data.frame(
    cbind(
      citygeocoder::us_cities_dt[closest, ],
      distance = closest_distances
    )
  )

}
