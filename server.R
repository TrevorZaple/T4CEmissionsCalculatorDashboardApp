data <- read.csv("c:/working/e4t/dashapp/e4tdata2.csv")
imageList <- read.csv("c:/working/e4t/dashapp/imageList.csv")
library(ggplot2)
co2 <- function(x, y, z) {
  bloop <- subset(data, data$VEHICLE_TYPE == x & data$FUEL_TYPE == y)
  lkm <- bloop$L.KM
  emish <- lkm * z
  emishmash <- (emish * 2.663)
  emissvalue <<- emishmash
  if (length(bloop$FUEL_TYPE) == 1) {
    msg <- paste("You have emitted", emishmash, "kg of CO2")
    print(msg)
    
  }
  else {
    msg <- paste("The selected vehicle does not use the selected fuel type")
    print(msg)
  }
  
  
}
routeData <- tibble::tibble(trip = numeric(), vehicle = character(), distance = numeric(), fuel = character(), emissions = numeric())

#routeData <- tibble::tibble(trip = NA, vehicle = NA, distance = NA, fuel = NA, emissions = NA)

server <- function(input, output) {
  #selected <- reactiveVal(rep(FALSE, nrow(routeData)))
  
  observeEvent(input$frame, {
    newDat <- tibble::tibble(trip = (nrow(routeData) + 1), vehicle = input$VEHICLE_TYPE, fuel = input$FUEL_TYPE,
                             distance = input$distance, emissions = emissvalue)
    
    routeData <<- rbind(routeData, newDat)
    print(routeData)
  })

  observeEvent(input$plotz, {
    newDat <- tibble::tibble(trip = (nrow(routeData) + 1), vehicle = input$VEHICLE_TYPE, fuel = input$FUEL_TYPE,
                             distance = input$distance, emissions = emissvalue)
    
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
    return(list(src = filename, contentType = "image/png", alt = "animage", height = 122, width = 300))
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
  co2(input$VEHICLE_TYPE, input$FUEL_TYPE, input$distance)
})
}