ui <- fluidPage(tabsetPanel(
  # Page 1 - Intro to T4C
  tabPanel(
    "Introduction to T4C",
    titlePanel("Introduction to T4C"),
    mainPanel(img(src = "cars_driving_through_smog.jpg", 
                  height = 300, width = 300),
              br(), br(),
              p("Welcome to the interactive Travel4Climate Emissions Calculator!"),
              p("This calculator allows you to enter a vehicle, a fuel type and a distance to find out the CO2 emissions of that trip."),
              p("Calculating the emissions of different vehicles and fuels can help us understand some of the impacts of different transportation options. "),
              strong("Note:"),
                     p("This calculator only calculates tailpipe emissions. To have a better understanding of the full impact that a vehicle can have on the environment, it is important to consider all parts of a vehicle's lifecycle. For more information on life cycles, consult the Transportation Technology Flowchart."),
             
              imageOutput("imageRender")
    )),
  tabPanel(
    "Vehicle Selector",
    titlePanel("What vehicle will you take on your trip?"),
    sidebarLayout(
      sidebarPanel(
        selectInput("VEHICLE_TYPE", "Vehicle:",
                    c("Large Car" = "LARGE CAR",
                      "Small Car" = "SMALL CAR",
                      "Minivan" = "MINIVAN",
                      "Small Truck" = "SMALL TRUCK",
                      "Small SUV" = "SMALL SUV",
                      "Regular SUV" = "STANDARD SUV",
                      "Passenger Van" = "PASSENGER VAN"))),
        mainPanel(
          imageOutput("getImage")
        )
      )
    ),
  tabPanel(
    "Fuel Type Selector",
    titlePanel("What fuel does your vehicle use?"),
    sidebarLayout(
      sidebarPanel(
        radioButtons("FUEL_TYPE", "Fuel Type", c("Regular Gasoline" = "REG GAS",
                                                 "Premium Gasoline" = "PREM GAS",
                                                 "Diesel" = "DIESEL",
                                                 "Electric" = "BATTERY"))
      ),
      mainPanel(
        imageOutput("getImageGas")
        
      )
    )
  ),
  tabPanel(
    "Distance Selector",
    titlePanel("How far are you planning on going?"),
    sidebarLayout(
      sidebarPanel(
        numericInput("distance", "Distance:", 1, min = 1)
      ),
      mainPanel(
        textOutput("distanceMsg", container = tags$h3)
      )
    )
  ),
  tabPanel(
    "Calculator",
    titlePanel("Your carbon footprint for this trip"),
    sidebarLayout(
      sidebarPanel(
        actionButton(inputId = "frame", label = "Add Route to Graph")
      ),
      mainPanel(
        textOutput("returnMsg", container= tags$h3)
      )
    )
  ),
  tabPanel(
    "Graphing",
    titlePanel("Compare Trips"),
    sidebarLayout(
      sidebarPanel(
        actionButton(inputId = "plotter", label = "Display Trips"),
        
        
      ),
      mainPanel(
        plotOutput("gplot", dblclick = "plot_reset"),
        p("Trips in Memory"),
        tableOutput("tripz")
      )
    )
  )
  )
  
  
  )