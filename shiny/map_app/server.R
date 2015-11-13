#ref: https://arilamstein.shinyapps.io/reference-map-toy

library(shiny)
library(choroplethrZip)
library(R6)
library(choroplethr)
library(RgoogleMaps)
library(ggmap)
library(data.table)

get_choropleth_object = function(maptype, color)
{
  R6Class("ZipChoroplethSatellite", inherit = ZipChoropleth,
          public = list(
            
            get_reference_map = function()
            {
              # note: center is (long, lat) but MaxZoom is (lat, long)
              
              center = c(mean(self$choropleth.df$long),
                         mean(self$choropleth.df$lat))
              
              max_zoom = MaxZoom(range(self$choropleth.df$lat),
                                 range(self$choropleth.df$long))
              
              get_map(location = center,
                      zoom    = max_zoom,
                      maptype = maptype,
                      color   = color,
                      crop = FALSE)
            }
          )
  )
}


parse.data = function(dt, var){
  sub.df = as.data.frame(dt)[c(var, "zip")]
  sub.df$zip = as.character((sub.df$zip))
  sub.df.agg = aggregate(sub.df[var], list(region = sub.df$zip), FUN=sum)
  #names(sub.df.agg)[2] = "value" 
  return(sub.df.agg)
}

top100.dt = fread("gunzip -c ../../data/Top100Procedures.csv.gz")
zip.pop = unique(as.data.frame(top100.dt)[c('zip', 'over.65.all')])
names(zip.pop)[1] = "region"

shinyServer(function(input, output) {

  output$map = renderImage({

    if (input$reference_map)
    {
      filename = paste0(input$state,
                        "-",
                        "hybrid", 
                        "-",
                        input$color,
                        "-",
                        input$var,
                        "-",
                        input$reference_map,
                        ".png")
    } else {
      filename = "no-reference-map.png"
    }
    
    if (file.exists(paste0("./map_dir/", filename)))
    {
      list(src         = paste0("./map_dir/", filename),
           contentType = 'image/png',
           width       = 640,
           height      = 480,
           alt         = paste0("./map_dir/", filename))
    } else {
    
    
    df = parse.data(top100.dt, input$var)
    if (input$var != "num.discharges"){
      df = merge(zip.pop, df, by="region", all=TRUE)
      df$value = df[input$var] / df$over.65.all
      x = df[input$var] / df$over.65.all
      names(x) = "value"
      df$value = x[[1]]
      df = na.omit(df[!df$over.65.all == 0, c(1,4)])
    } else {
      names(df)[2] = "value"
      
    }

    c = get_choropleth_object("hybrid", input$color)
    c = c$new(df)
    
    c$set_zoom_zip(state_zoom=input$state, county_zoom = NULL, zip_zoom=NULL, msa_zoom=NULL)
    c$set_num_colors(5)
    c$title  = paste0(input$state, " ", input$var)
    c$legend = input$var
    c$render_with_reference_map()
    
    png(paste0("./map_dir/", filename), width=640, height=480)
    if (input$reference_map) {
      print(c$render_with_reference_map())
    } else {
      print(c$render())
    }
    dev.off()
    
    list(src         = paste0("./map_dir/", filename),
         contentType = 'image/png',
         width       = 640,
         height      = 480,
         alt         = paste0("./map_dir/", filename))
  }
  }, deleteFile = FALSE)
})
