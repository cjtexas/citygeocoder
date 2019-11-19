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
        setView(lng= values$geocode$lon, values$geocode$lat, 12) %>%
        addCircleMarkers(
          lng = values$geocode$lon,
          lat = values$geocode$lat,
          popup = paste(format(values$geocode$lon, nsmall = 5),  format(values$geocode$lat, nsmall = 5), sep = ",")
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
        setView(lng= values$revgeocode$lon, values$revgeocode$lat, 12) %>%
        addCircleMarkers(
          lng = values$revgeocode$lon,
          lat = values$revgeocode$lat,
          popup = paste(
            paste(
              paste(
                tools::toTitleCase(values$revgeocode$city),
                tools::toTitleCase(values$revgeocode$state),
                collapse = ","
              ),
              "<br>"
            ),
            paste(format(values$revgeocode$lon, nsmall = 5),  format(values$revgeocode$lat, nsmall = 5), sep = ",")
          ),
          popupOptions = popupOptions(noHide = T)
        )
    }

  })

}

shiny::shinyApp(ui = ui, server = server)
