library(shiny)
library(datasets)
library(ggplot2)
library(data.table)


# will need to load .Rda or something similar.


# Define server logic required to plot various variables against mpg
top100.dt <- fread("gunzip -c ./data/Top100Procedures.csv.gz")

shinyServer(function(input, output) {
  
  output$ggPlot <- renderPlot({
    print(input$drgcode)
    ggmap(
      get_map(
        location = input$statename, 
        zoom=7, 
        maptype = "terrain", 
        source='google', 
        color='bw'
      )
    ) + 
    geom_point(
        aes(x=lon,y=lat,size=num.discharges),
        data = top100.dt[state == input$statename & drg.code == input$drgcode,]
    )
  }
  )
  
})

