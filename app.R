library("shiny")
source("ui2.R")
source("server2.R")
data <- read.csv("E4Tdata2.csv")


shinyApp(ui = ui, server = server)