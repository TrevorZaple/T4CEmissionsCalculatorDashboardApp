ui <- fluidPage(tags$head(
  tags$style(HTML("
                    .box{
width: 600px;
height: 260px;
border: 1px solid black;
}"))),
  tabsetPanel(
  
  # Page 1 - Intro to T4C
  tabPanel(
    "Introduction",
    titlePanel("Travel4Climate Carbon Emissions Calculator"),
    mainPanel(img(src = "cars_driving_through_smog.jpg", 
                  height = 300, width = 300),
              br(), br(),
              p("Welcome to the interactive Travel4Climate Emissions Calculator!"),
              p("This calculator allows you to enter a vehicle, a fuel type and a distance to find out the CO2 emissions of that trip."),
              p("Calculating the emissions of different vehicles and fuels can help us understand some of the impacts of different transportation options."),
              strong("Note:"),
                     p("This calculator only calculates tailpipe emissions or emissions from the operation of the vehicle. To have a better understanding of the full impact that a vehicle can have on the environment, it is important to consider all processes in a vehicle's lifecycle. For more information on lifecycles, consult the Transportation Technology Flowchart."),
             
              imageOutput("imageRender")
    )),
  tabPanel(
    "Instructions",
    titlePanel("How To Operate The Calculator"),
    
    mainPanel(
      tags$div(class = "box",
               tags$strong("Calculator Function:"),
               br(),
               br(),
               tags$p("This calculator will allow you to see your carbon emissions for a trip, with the given what "),
               tags$ul(
                 tags$li("type of vehicle"),
                 tags$li("type of fuel "),
                 tags$li("Distance travelled in kilometres.")
               ),
               tags$p("The Vehicle Selector, Fuel Selector, and Distance Selector tabs allow you to choose your vehicle, fuel type, and distance, respectively."),
               tags$p("The Calculator tab will tell you how many kilograms of CO2 your trip would emit."),
               ),
      tags$div(class = "box",
               tags$strong("Graph Function:"),
               br(),
               br(),
               tags$p("Click on the Add To Graph button on the Calculator tab to store your trip"),
               tags$p("On the Graphing tab, you can click Display Trips to show a bar graph of your saved trips."),
               tags$p("Please note you will have to click Display Trips everytime you add a new vehicle to the calculator."),
               tags$p("You can also click Clear Memory to wipe all of the trips from memory and start again."),
               tags$p("After clicking Clear Memory you will have to click Display Trips to clear the graph.")
               )),
    
    
    ),
      
  
  tabPanel(
    "Vehicle Selector",
    titlePanel("What vehicle will you take on your trip?"),
    sidebarLayout(
      sidebarPanel(
        selectInput("VEHICLE_TYPE", "Vehicle:",
                    c("Car" = "CAR",
                      "Bike" = "ELECTRIC BIKE",
                      "ATV" = "ATV",
                      "Motorcycle" = "MOTORCYCLE",
                      "Minibus" = "MINIBUS",
                      "Snowmobile (2-Stroke)" = "SNOWMOBILE",
                      "Snowmobile (4-Stroke)" = "SNOWMOBILE2",
                      "Airplane" = "AIRPLANE",
                      "Ferry" = "FERRY",
                      "LRT" = "RAIL",
                      "Minivan" = "MINIVAN",
                      "Pickup Truck" = "TRUCK",
                      "City Bus" = "CITYBUS",
                      "School Bus" = "SCHOOL BUS",
                      "SUV" = "SUV",
                      "Passenger Van" = "PASSENGER VAN"
                      ))),
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
        uiOutput("fuelSelect")
      ),
      mainPanel(
        imageOutput("getImageGas"),
        conditionalPanel(condition = "input.FUEL_TYPE == 'RNG'",
                         
                        tags$strong("The selected fuel type is in development and no concrete data is available.")),
        conditionalPanel(condition ="input.FUEL_TYPE == 'SAF'",
                         tags$strong("The selected fuel type is in development and no concrete data is available.")),
        conditionalPanel(condition ="input.FUEL_TYPE == 'HH'",
                         tags$strong("The selected fuel type is in development and no concrete data is available.")),
        
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
        actionButton(inputId = "memclear", label = "Clear Memory")
        
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