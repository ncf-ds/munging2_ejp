#ref: https://arilamstein.shinyapps.io/reference-map-toy


library(shiny)
library(choroplethr)
library(choroplethrZip)


data(continental_us_states)
states = continental_us_states
vars = c("num.discharges", "covered.charges", "total.payments", "medicare.payments")
         #"medicare.frac"

shinyUI(fluidPage(

  titlePanel("Hospital Charge Data Exploration"),
  div(HTML("Select state, map color, and variable. The variables 'covered.charges', 'total.payments', 'medicare.payments' are normalized by 
           each by Zip code's population of age 65 and older, where available. ")),
  
  sidebarLayout(
    sidebarPanel(
      
      radioButtons(inputId = "color",
                  label    = "Color:",
                  choices  = c("color", "bw"),
                  selected = "bw"),
      
      checkboxInput(input = "reference_map",
                    label = "Include Reference Map",
                    value = TRUE),
      
      selectInput(inputId  = "state",
                  label    = "States",
                  choices  = states,
                  selected = "Ohio"),
      
      selectInput(inputId  = "var",
                  label    = "Variable",
                  choices  = vars,
                  selected = "total.payments")
    ),
    
    mainPanel(
      imageOutput("map", width="640px", height="480px")
    )
  )
))
