data <- read.csv("Database.csv")
imageList <- read.csv("imageList.csv")
library(ggplot2)

routeData <- tibble::tibble(trip = numeric(), vehicle = character(), distance = numeric(), fuel = character(), emissions = numeric())

#routeData <- tibble::tibble(trip = NA, vehicle = NA, distance = NA, fuel = NA, emissions = NA)

server <- function(input, output) {
  source('server.R', local = TRUE)
  #selected <- reactiveVal(rep(FALSE, nrow(routeData)))
  
  co2 <- function(x, y, z) {
    bloop <- subset(data, data$VEHICLE_TYPE == x & data$FUEL_TYPE == y)
    lkm <- bloop$L.KM
    emish <- lkm * z
    emishmash <- (emish * 2.663)
    emissvalue <- emishmash
    msg <- paste("You have emitted", emishmash, "kg of CO2")
    print(msg)
    return(emishmash)
    
    
    
  }
  
  observeEvent(input$frame, {
    newDat <- tibble::tibble(trip = (nrow(routeData) + 1), vehicle = input$VEHICLE_TYPE, fuel = input$FUEL_TYPE,
                             distance = input$distance, emissions = co2(input$VEHICLE_TYPE, input$FUEL_TYPE, input$distance)) #emissvalue
    
    routeData <<- rbind(routeData, newDat)
    print(routeData)
  })

  observeEvent(input$plotz, {
    
    newDat <- tibble::tibble(trip = (nrow(routeData) + 1), vehicle = input$VEHICLE_TYPE, fuel = input$FUEL_TYPE,
                             distance = input$distance, emissions = co2(input$VEHICLE_TYPE, input$FUEL_TYPE, input$distance)) #emissvalue
    
    routeData <<- rbind(routeData, newDat)
    print(routeData)
  })
  
  #observeEvent(input$plot_reset, {
   # selected(rep(FALSE, nrow(routeData)))
 # })
  
  observeEvent(input$plotter, {
    output$gplot <- renderPlot({
      
      ggplot(data = routeData, aes(x = trip, y = emissions)) +
        geom_bar(stat = "identity", fill = "steelblue") +
        geom_text(aes(label = emissions), vjust = 1.6, color = "white", size = 3.5) +
        theme_minimal()
      
      
    })
    output$tripz <- renderTable(
      routeData, striped = T,  bordered = T, width = "auto"
    )
  })
  
  observeEvent(input$memclear, {
    routeData <<- tibble::tibble(trip = numeric(), vehicle = character(), distance = numeric(), fuel = character(), emissions = numeric())
    
    
  })
  
  output$tripz <- renderTable(
    routeData, striped = T,  bordered = T, width = "auto"
  )
  
  output$getImage <- renderImage({
  
  idata <- subset(imageList, imageList$type == input$VEHICLE_TYPE)
  filename <- paste0("./public/", idata$image)
  return(list(src = filename, contentType = "image/png", alt = "animage", height=122, width=300)
)}, deleteFile = FALSE)
  
  output$getImageGas <- renderImage({
    idata <- subset(imageList, imageList$type == input$FUEL_TYPE)
    filename <- paste0("./public/", idata$image)
    return(list(src = filename, contentType = "image/png", alt = "animage", height = 150, width = 150))
  }, deleteFile = FALSE)

output$fuelMsg <- renderText({
  fuelType <- subset(data, data$FUEL_TYPE == input$FUEL_TYPE)
  msg <- paste("You have selected", fuelType$FUEL_TYPE)
  print(msg)
})

output$distanceMsg <- renderText({
  distance <- input$distance
  msg <- paste("You are travelling", distance, "kilometers")
  print(msg)
})

output$returnMsg <- renderText({
  paste("You have emitted", co2(input$VEHICLE_TYPE, input$FUEL_TYPE, input$distance), "kg of CO2")
})

output$fuelSelect <- renderUI({
  if(input$VEHICLE_TYPE == "CAR") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Regular Gasoline" = "REG GAS",
                                                                              "Electric" = "ELECTRIC",
                                                                              "Hybrid" = "HYBRID",
                                                                "Diesel" = "DIESEL",
                                                                "Ethanol" = "E85",
                                                                "Hydrogen Fuel Cell" = "HFC",
                                                                "Biodiesel (B20)" = "BIODIESEL"))
  }
  if(input$VEHICLE_TYPE == "MINIVAN") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Regular Gasoline" = "REG GAS",
                                              "Hybrid" = "HYBRID",
                                              "Ethanol" = "E85",
                                              "Plugin" = "PLUGIN",
                                              "Hydrogen Fuel Cell" = "HFC"))
  }
  
  if(input$VEHICLE_TYPE == "TRUCK") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Regular Gasoline" = "REG GAS",
                                              "Diesel" = "DIESEL",
                                              "Ethanol" = "E85",
                                              "Hydrogen Fuel Cell" = "HFC",
                                              "Electric" = "ELECTRIC",
                                              "Plugin" = "PLUGIN",
                                              "Hydrogen Fuel Cell" = "HFC",
                                              "Biodiesel (B20)" = "BIODIESEL"))
  }
  if(input$VEHICLE_TYPE == "SUV") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Regular Gasoline" = "REG GAS",
                                                                 "Diesel" = "DIESEL",
                                                                 "Hybrid" = "HYBRID",
                                                                "Hydrogen Fuel Cell" = "HFC",
                                                                "Plugin" = "PLUGIN",
                                                                "Electric" = "ELECTRIC",
                                                                "Ethanol" = "E85",
                                                                "Biodiesel (B20)" = "BIODIESEL"))
  }
  if(input$VEHICLE_TYPE == "PASSENGER VAN") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Regular Gasoline" = "REG GAS",
                                                                "Ethanol" = "E85",
                                                                "Plugin" = "PLUGIN",
                                                                "Hydrogen Fuel Cell" = "HFC"))
  }
  if(input$VEHICLE_TYPE == "SCHOOL BUS") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Diesel" = "DIESEL",
                                                                 "Compressed Natural Gas" = "CNG",
                                                                "Plugin" = "PLUGIN",
                                                                "Biodiesel (B20)" = "BIODIESEL"))
  }
  if(input$VEHICLE_TYPE == "CITYBUS") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Diesel" = "DIESEL",
                                                                 "Biodiesel (B20)" = "BIODIESEL",
                                                                 "Hybrid" = "HYBRID",
                                                                "Compressed Natural Gas" = "CNG"))
  }
  if(input$VEHICLE_TYPE == "MINIBUS") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Diesel" = "DIESEL",
                                                                 "Electric" = "ELECTRIC",
                                                                "Hydrogen Fuel Cell" = "HFC",
                                                                "Biodiesel (B20)" = "BIODIESEL"))
  }
  if(input$VEHICLE_TYPE == "RAIL") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Electric" = "ELECTRIC"))
  }
  if(input$VEHICLE_TYPE == "AIRPLANE") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Aviation Jet Fuel" = "REG GAS",
                                                                  "Electric" = "ELECTRIC",
                                                                "Sustainable Aircraft Fuel" = "SAF",
                                                                "Hybrid-Hydrogen" = "HH"))
  }
  if(input$VEHICLE_TYPE == "SNOWMOBILE2") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Regular Gas" = "REG GAS",
                                                                  "Plugin" = "PLUGIN",
                                                                  "Hyrdogen Fuel Cell" = "HFC"))
  }
  if(input$VEHICLE_TYPE == "SNOWMOBILE") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Regular Gas" = "REG GAS",
                                                                  "Plugin" = "PLUGIN",
                                                                  "Hydrogen Fuel Cell" = "HFC"))
  }
  if(input$VEHICLE_TYPE == "MOTORCYCLE") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Regular Gas" = "REG GAS",
                                                                  "Plugin" = "PLUGIN",
                                                                  "Hydrogen Fuel Cell" = "HFC"))
  }
  if(input$VEHICLE_TYPE == "ELECTRIC BIKE") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Electric" = "ELECTRIC"))
  }
  if(input$VEHICLE_TYPE == "ATV") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Regular Gasoline" = "REG GAS",
                                               "Plugin" = "PLUGIN",
                                               "Hydrogen Fuel Cell" = "HFC"))
  }
  if(input$VEHICLE_TYPE == "FERRY") {
    fuel_Selections <- radioButtons("FUEL_TYPE", "Fuel Type", c("Electric" = "ELECTRIC", "Heavy Fuel Oil" = "HFO", "Renewable Natural Gas" = "RNG"))
  }
  fuel_Selections
})


}