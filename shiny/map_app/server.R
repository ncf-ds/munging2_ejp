library(shiny)
library(ggplot2)
library(data.table)
library(maps)

# will need to load .Rda or something similar.

# Define server logic required to plot various variables against mpg
top100.dt <- fread("gunzip -c ../../data/Top100Procedures.csv.gz")

outbounds <- function(v) {
  # get the range, excluding the outer 2%
  r1 <- quantile(v,c(.05,.95))
  # compute the distance
  s <- (r1[2] - r1[1])
  #effectively this doubles the 1% - 99% range:
  r1 + s*c(-1,1)*0.5
}

filter_misplaced <- function(dt) {
  lat.bounds <- outbounds(dt$lat)
  lon.bounds <- outbounds(dt$lon)
  dt[lat >= lat.bounds[1] & lat <= lat.bounds[2] &
     lon >= lon.bounds[1] & lon <= lon.bounds[2],]
}

shinyServer(function(input, output) {
  state.dt <<- reactive({
    filter_misplaced(top100.dt[('all' == input$statename |
                                state == input$statename )
                               & drg.code == input$drgcode,])
  })
  state.map <<- reactive({
    if( input$statename != 'all' ) {
      map_data('state',regions=state.name[grep(input$statename,state.abb)])
    } else {
      map_data('state')
    }
  })
  
  output$map <- renderPlot({
    ggplot(state.map(), aes(x = long, y = lat)) +
      geom_map(map=state.map(),fill="gray",color="gray60",aes(map_id=region)) +
      coord_map() + 
      geom_point(data=state.dt(),
                 aes(
                    x=lon,
                    y=lat,
                    size=num.discharges,
                    color = total.payments
                 )
      )
  })

  output$scatterplot <- renderPlot({
    ggplot(data = state.dt(),
           aes(
              x = num.discharges,
              y = total.payments,
              size = num.discharges,
              color = total.payments
            )
      ) + geom_point() + facet_grid(year~.) + scale_size(range = c(1.5,7))
  })
  
})

