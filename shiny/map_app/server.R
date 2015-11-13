library(shiny)
library(ggplot2)
library(data.table)
library(maps)

# will need to load .Rda or something similar.


# Define server logic required to plot various variables against mpg
top100.dt <- fread("gunzip -c ../../data/Top100Procedures.csv.gz")

shinyServer(function(input, output) {
  state.dt <<- reactive({
    top100.dt[state == input$statename & drg.code == input$drgcode,]
  })
  state.map <<- reactive({
    map_data('state',regions=state.name[grep(input$statename,state.abb)])
  })
  output$ggPlot <- renderPlot({
    ggplot(state.map(), aes(x = long, y = lat)) +
      geom_polygon(fill="gray") +
      coord_map() + geom_point(data=state.dt(),
                               aes(x=lon,y=lat,size=num.discharges))
  }
  )
  
})

