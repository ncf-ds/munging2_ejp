library(shiny)
library(datasets)
library(ggplot2)
library(data.table)


# will need to load .Rda or something similar.


# Define server logic required to plot various variables against mpg
top100.dt <- fread("gunzip -c ../../data/Top100Procedures.csv.gz")

shinyServer(function(input, output) {
  state.dt <<- reactive({
    print(input$statename)
    
    top100.dt[state == input$statename & drg.code == input$drgcode,]
  })
  state.bounds <<- reactive({
    data.frame(lon=c(min(state.dt()$lon),max(state.dt()$lon)),
               lat=c(min(state.dt()$lat),max(state.dt()$lat)))
    
  })
  state.map <<- reactive({
    get_map(
      location = input$statename,
      zoom=7, 
      maptype = "terrain", 
      color='bw'
    )
  })
  output$ggPlot <- renderPlot({
    ggmap(state.map(),
      base_layer = ggplot(data=state.dt(),aes(x=lon,y=lat,size=num.discharges))
    ) + 
    geom_point()
  }
  )
  
})

