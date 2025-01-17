library(shiny)
library(ggplot2)
library(data.table)
library(maps)
library(grid)

# will need to load .Rda or something similar.

# Define server logic required to plot various variables against mpg
top100.dt <- fread("gunzip -c ../../data/Top100Procedures.csv.gz")
top100.dt.2013 <- top100.dt[year==2013,.(provider.id,drg.code,num.discharges,covered.charges,total.payments,medicare.payments)]
ns <- names(top100.dt.2013)[!grepl("prov|drg",names(top100.dt.2013))]
setnames(top100.dt.2013,ns,paste0(ns,".2013"))
top100.dt <- merge(top100.dt,top100.dt.2013,by=c('provider.id','drg.code'))
top100.dt[,year := as.factor(year)]

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
    dt <- filter_misplaced(top100.dt[('all' == input$statename |
                                  state == input$statename )
                                 & drg.code == input$drgcode,])
    dt$var.x <- dt[[input$var.x]]
    setnames(dt,paste0(input$var.y,c("",".2013")),c("var.y","var.y.2013"))
    dt
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
                    size=var.x,
                    colour = var.y
                 )
      ) + 
      guides( size = guide_legend(title = input$var.x,
                                  title.position = 'left',
                                  title.vjust = 0,
                                  title.theme = element_text(angle=90)),
              colour = guide_legend(title = input$var.y,
                                    title.position = 'left',
                                    title.vjust = 0,
                                    title.theme = element_text(angle=90))
              ) +      
      theme(axis.line=element_blank(),axis.text.x=element_blank(),
            axis.text.y=element_blank(),axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.border=element_blank(),
            panel.background=element_blank(),
            legend.position = 'left')
  })
  
  output$scatterplot <- renderPlot({
    ggplot(data = state.dt(),
           aes(
             x = var.x,
             y = var.y,
             size = var.x,
             color = var.y
           )
    ) + geom_point() + facet_grid(year~.) + 
      scale_size(range = c(1.5,7)) +
      theme(legend.position = 'none') +
      labs(title = "year breakdown",x=input$var.x,y=input$var.y)
  })
  output$ranks <- renderPlot({
    ggplot(data = state.dt(),
           aes(
             y = rank(var.y),
             x = year,
             size=var.x,
             color = rank(var.y.2013),
             group = provider.id
           )
    ) + scale_x_discrete(expand=c(0,0)) + geom_point() + geom_path() +
      guides( size = guide_legend(title=input$var.x,
                                  title.position = 'left',
                                  title.vjust = 0,
                                  title.theme = element_text(angle=90)),
              colour = guide_legend(title=paste("2013",input$var.y,"rank"),
                                    title.position = 'left',
                                    title.vjust = 0,
                                    title.theme = element_text(angle=90))
      ) + labs( title = "rank changes", y = paste(input$var.y,"rank"), x=input$var.x)

  })
  
})

