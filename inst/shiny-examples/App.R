library(citygeocoder)
library(leaflet)
library(shiny)
library(shinydashboard)


ui <-
  dashboardPage(
    dashboardHeader(title = "US City Geocoder"),
    dashboardSidebar(
      sidebarMenu(
        sidebarSearchForm(
          textId = "geocode",
          buttonId = "geocodebutton",
          label = "City, State Search",
          icon = icon("map")
        ),
        sidebarSearchForm(
          textId = "revgeocode",
          buttonId = "revgeocodebutton",
          label = "Lon, Lat Search",
          icon = icon("map")
        )
      )
    ),
    dashboardBody(
      fluidRow(
        box(width = 12,
            height = "100%",
            leafletOutput("map", height = 800, width = "100%")
        )
      )
    )
  )


server <- function(input, output) {

  values <- reactiveValues()

  output$map <- renderLeaflet({

      leaflet() %>%
        addProviderTiles(provider = "Esri.WorldImagery")

  })

  observeEvent(input$geocodebutton, {

    req(input$geocode)
    req(input$geocodebutton)

    city <- strsplit(input$geocode, ",")[[1]][1]
    state <- gsub(" ", "", strsplit(input$geocode, ",")[[1]][2])

    # attempt to geocode input values
    res <- citygeocoder::geocode(city, state)
    if (!any(is.null(res)) & !any(is.na(res)) ) {
      values$geocode <- res
    }

    if (is.null(values$geocode) | any(is.na(values$geocode))) {
      NULL
    } else {
      leafletProxy('map') %>%
        clearMarkers() %>%
        removeScaleBar() %>%
        flyTo(lng= values$geocode$lon, values$geocode$lat, 10) %>%
        addCircleMarkers(
          lng = values$geocode$lon,
          lat = values$geocode$lat,
          color = "#03FFC0",
          fillColor = "#03FFC0"
        ) %>%
        addLabelOnlyMarkers(
          lng = values$geocode$lon,
          lat = values$geocode$lat,
          label = sprintf(
            "%s %s",
            paste(tools::toTitleCase(city), toupper(state), sep = ", "),
            paste(
              format(values$geocode$lon, nsmall = 5),
              format(values$geocode$lat, nsmall = 5),
              sep = ", "
            )
          ),
          labelOptions = labelOptions(
            noHide = T,
            direction = 'top',
            textOnly = T,
            style = list("color" = "#03FFC0", "font-weight" = "bold", "font-size" = "20px")
          )
        )
    }

  })

  observeEvent(input$revgeocodebutton, {

    req(input$revgeocode)
    req(input$revgeocodebutton)

    lon <- as.numeric(strsplit(input$revgeocode, ",")[[1]][1])
    lat <- as.numeric(gsub(" ", "", strsplit(input$revgeocode, ",")[[1]][2]))

    # attempt to geocode input values
    res <- citygeocoder::reverse_geocode(lon, lat)
    message(res)
    if (!any(is.null(res)) & !any(is.na(res)) ) {
      values$revgeocode <- res
    }

    if (is.null(values$revgeocode) | any(is.na(values$revgeocode))) {
      NULL
    } else {
      message(values$revgeocode$lon)
      message(values$revgeocode$lat)
      leafletProxy('map') %>%
        clearMarkers() %>%
        addScaleBar() %>%
        flyTo(lng= values$revgeocode$lon, values$revgeocode$lat, 10) %>%
        addCircleMarkers(
          lng = lon,
          lat = lat,
          color = "#ffc003"
        ) %>%
        addCircleMarkers(
          lng = values$revgeocode$lon,
          lat = values$revgeocode$lat,
          color = "#03FFC0",
          fillColor = "#03FFC0"
        ) %>%
        addLabelOnlyMarkers(
          lng = values$revgeocode$lon,
          lat = values$revgeocode$lat,
          label = sprintf(
            "%s %s",
            paste(values$revgeocode$city, values$revgeocode$state, sep = ", "),
            paste(
              format(values$revgeocode$lon, nsmall = 5),
              format(values$revgeocode$lat, nsmall = 5),
              sep = ", "
            )
          ),
          labelOptions = labelOptions(
            noHide = T,
            direction = 'top',
            textOnly = T,
            style = list("color" = "#03FFC0", "font-weight" = "bold", "font-size" = "20px")
          )
        ) %>%
        addLabelOnlyMarkers(
          lng = lon,
          lat = lat,
          label = paste(lon, lat, sep = ","),
          labelOptions = labelOptions(
            noHide = T,
            direction = 'top',
            textOnly = T,
            style = list("color" = "#ffc003 ", "font-weight" = "bold", "font-size" = "20px")
          )
        )
    }

  })

}

shiny::shinyApp(ui = ui, server = server)
