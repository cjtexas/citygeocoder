
<!-- README.md is generated from README.Rmd. Please edit that file -->

# citygeocoder

<!-- badges: start -->

<!-- badges: end -->

I wanted a simple but fast, city-level geocoder for the US…

## Installation

You can install the development version from
[GitHub](https://github.com/cjtexas/citygeocoder) with:

``` r
# install.packages("remotes")
remotes::install_github("cjtexas/citygeocoder")
```

## Examples

1.  Geocode

<!-- end list -->

``` r
library(citygeocoder)

citygeocoder::geocode("Austin", "TX")
#>         lon      lat
#> 1 -97.74306 30.26715
```

2.  Reverse Geocode

<!-- end list -->

``` r
library(citygeocoder)

citygeocoder::reverse_geocode(lon = -98.7654321, lat = 34.56789)
#>        city state       lon      lat  distance
#> 1 Indiahoma    OK -98.77524 34.62374 0.0567061
```

3.  Batch Mode\!

<!-- end list -->

``` r
df1 <-
  read.table(
    text =
    "City       | State
    Scranton    | PA
    Oakland     | CA
    New York    | NY
    Columbus    | IN",
    header = T,
    sep = "|",
    stringsAsFactors = FALSE,
    strip.white = TRUE
  )

citygeocoder::geocode(df1$City, df1$State)
#>          lon      lat
#> 1  -75.66241 41.40897
#> 2 -122.27080 37.80437
#> 3  -73.98143 40.76149
#> 4  -85.92138 39.20144

df2 <-
  read.table(
    text =
      "Lon    | Lat
    -95.55555 | 37.77777  
    -96.66666 | 36.66666
    -97.77777 | 35.55555  
    -98.88888 | 34.44444
    -99.99999 | 33.33333",
    header = T,
    sep = "|",
    stringsAsFactors = FALSE,
    strip.white = TRUE
  )

reverse_geocode(df2$Lon, df2$Lat)
#>        city state       lon      lat   distance
#> 1  Petrolia    KS -95.47165 37.74588 0.08975872
#> 2   Burbank    OK -96.75576 36.69899 0.09478294
#> 3     Yukon    OK -97.75043 35.50294 0.05929319
#> 4 Hollister    OK -98.89469 34.34625 0.09835747
#> 5 Rochester    TX -99.85593 33.31593 0.14511042
```

4.  I also included an example Shiny App that demonstrates the Package
    functions - NOTE: Requires Additional Packages (leaflet, shiny,
    shinydashboard)

`citygeocoder:::shiny_example()`
