# Li Kui 2019-06-15
# Deep reef fish from Love lab
#

shinyServer(function(input, output) {

  #Gather user inputs and manipulate data for abundance time series 
  get_count_data <- reactive({
      count_data <- total_count %>%
          filter(year >= input$years[1]&year <= input$years[2])
    if (input$species=="all species") {
      count_data <-count_data %>%
        group_by(date,site) %>%
        summarise(total=sum(total)) %>%
        ungroup() %>%
        mutate(common_name="All species")
    } else {
      count_data <- count_data %>%
       filter(common_name==input$species)
    }
      count_data
  })
  
  #Draw map
  output$map <- renderLeaflet({
    
    m<-leaflet(data = map) %>%
      addTiles() %>%
      #setView(lng=-119.8,lat=34.4,zoom=11)%>%
      addMarkers(
        lng = ~longitude, lat = ~latitude,
        label = ~site,
        labelOptions= labelOptions(noHide=T,textOnly = TRUE,textsize="11px",direction="top",offset=c(0,-20))
        ) 
   
    m
  })
  
  #Draw daily counts time series (bar chart)
  output$count_data <- renderPlot({

    #Get data filtered by years and species input by user
    data_subset <- get_count_data()

    g = ggplot(data_subset, aes(x=date, y=total))+
      geom_bar(stat="identity",width=4) +
      labs(x="Date",
           y="Nmber of birds along a 1-km transect",
           title=unique(data_subset$common_name)) +
      theme(axis.text.x = element_text(size = 14),
            axis.text.y=element_text(size=12),
            axis.title=element_text(size=14),
            panel.background =  element_blank(),
            axis.line = element_line(colour = "black"),
            strip.text=element_text(size=12)) +
      facet_grid(site~.)

    g
  })

  output$diversity <- renderPlot({

    data_subset <- diversity

    g = ggplot(data_subset, aes(x=date, y=richness))+
      geom_bar(stat="identity",width=3) +
      labs(x="Date",
           y="Species richness at 1-km transect",
           title="Species Richness") +
       theme(axis.text.x = element_text(size = 14),
            axis.text.y=element_text(size=14),
            axis.title=element_text(size=14),
            panel.background =  element_blank(),
            axis.line = element_line(colour = "black"),
            strip.text=element_text(size=13)) +
      facet_grid(site~.)

    g
  })
  
})
