# Li Kui 2019-06-15
# Deep reef fish from Love lab
#

shinyServer(function(input, output) {


  #Gather user inputs and manipulate data for diversity map  
  get_map_data <- reactive({
    map_data = location %>%
      filter(year >= input$years[1]&year <= input$years[2]) %>%
      group_by(site,latitude,longitude) %>%
      summarise(richness=as.integer(mean(richness)) )%>%
      ungroup()
    
    map_data
  })

  #Gather user inputs and manipulate data for abundance time series 
  get_figure_data <- reactive({
    data_subset  <- fish_density %>%
          filter(year >= input$years[1]&year <= input$years[2])
    if (input$species=="all species") {
      data_subset <-data_subset %>%
        group_by(year,site) %>%
        summarise(density=sum(density)) %>%
        ungroup() %>%
        mutate(scientific_name="All species")
    } else {
     data_subset <- data_subset %>%
       filter(scientific_name==input$species)
    }
    data_subset
  })
  
  
  
  #Draw map
  output$map <- renderLeaflet({
    
    map_data = get_map_data() 
    palette = colorFactor(c("red", "navy", "black"), domain = c("Footprint", "Piggy Bank", "Anacapa Passage"))
    
    leaflet(data = map_data) %>%
      addTiles() %>%
      setView(lng=-119.5,lat=33.95,zoom=11)%>%
      addCircleMarkers(
        lng = ~longitude, lat = ~latitude,
        color = ~palette(site), stroke = FALSE, fillOpacity = 0.5, radius = ~richness/2,
        label=~paste("Richness at ",site," :",richness),
        labelOptions= labelOptions(noHide=T,textsize="11px"))
  })
  
  #Draw daily counts time series (bar chart)
  output$annual_density <- renderPlot({

    #Get data filtered by years and species input by user
    data_subset <- get_figure_data()

    g = ggplot(data_subset, aes(x=year, y=density))+
      geom_bar(stat="identity",width=0.5) +
      labs(x="Year",
           y="Fish density (# per 100 square meter)",
           title=unique(data_subset$scientific_name)) +
       scale_x_continuous(breaks=c(seq(min(data_subset$year)-1,max(data_subset$year)+1,by=2)))+
      theme(axis.text.x = element_text(size = 14),
            axis.text.y=element_text(size=14),
            axis.title=element_text(size=14),
            #panel.background =  element_blank(),
            panel.border = element_blank(),
            axis.line = element_line(colour = "black"),
            strip.text=element_text(size=13)) +
      facet_grid(site~.)

    g
  })

  
})
