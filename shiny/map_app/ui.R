library(shiny)

states <- state.abb
names(states) <- state.name
# TODO: pull AK & HI from world2Hires & reposition on main map
states <- states[!grepl('AK|HI',states)]
states <- append(states,list('United States' = 'all'),after=0)
source("./drg_codes.R")
vars = list("Covered Charges" = "covered.charges",
            "Total Payments" = "total.payments",
            "Medicare Payments" = "medicare.payments",
            "# Discharges" = "num.discharges")
shinyUI(
  fluidPage(
    # title,
    titlePanel(title = "Hospital charge data"), 
    
    # controls
    hr(),
    fluidRow(
      column(2, selectInput("statename", "State:", states, selected='FL')),
      column(6, selectInput("drgcode", "DRG code:", drgs, width = '100%'), offset = 0),
      column(2, selectInput("var.y", "Value:",vars,selected="total.payments")),
      column(2, selectInput("var.x", "Vs:",vars,selected="num.discharges"))
    ),
    
    # top section
    hr(),
#     h3("State plot"),
#     fluidRow(plotOutput("map")),
#   
# 
#     # bottom section
#     #hr(),
#     h3("Hospital information broken down by year"),
#     # I think we may want to add the legends back to these -erin
#     fluidRow(
#       column(6, plotOutput("scatterplot"), offset = 0),
#       column(6, plotOutput("ranks"), offset=0 )
#     ),
#     hr(),
    fluidRow(
      column(5, plotOutput("map")),
      column(4, plotOutput("scatterplot"), offset = 0),
      column(3, plotOutput("ranks"), offset=0 )
      )
    
  )
)
