library("shiny")
source("ui2.R")
source("server2.R")
data <- read.csv("c:/working/e4t/e4tapp/e4tdata2.csv")


shinyApp(ui = ui, server = server)