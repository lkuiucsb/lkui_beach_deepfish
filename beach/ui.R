# Li Kui 2019-06-15
# Deep reef fish from Love lab
#
dashboardPage(skin="blue",
  
  dashboardHeader(title = "Bird community along beaches"),
  
  dashboardSidebar(
    
    sidebarMenu(id="sidebar",
      menuItem("Map", tabName = "tab_map", icon = icon("map")),
      menuItem("Total count", tabName = "tab_totalcount", icon = icon("bar-chart")),
      menuItem("Diversity", tabName = "tab_diversity", icon = icon("bar-chart"))),
  
    conditionalPanel(
      condition = "input.sidebar == 'tab_annualDensity'",
    sliderInput(
      "years", label = "Select Year", sep="",
      min = min(data1$year), max = max(data1$year), step = 1,
      value = c(min(data1$year), max(data1$year)))
    ),
    
     conditionalPanel(
      condition = "input.sidebar == 'tab_map'",
      HTML("<h4>&nbsp; &nbsp; &nbsp; Location and Richness </h4>")
    ),
    
    conditionalPanel(
      condition = "input.sidebar == 'tab_totalcount'",
      selectInput(
      "species", label = "Select Species",
      choices = c("all species",unique(data1$common_name)),
      selected="all species")),
    
     tags$head(tags$style(HTML(".fa { font-size: 20px; width=20px}"))),
     tags$head(tags$style(HTML('.info-box {min-height: 20px; min-width=20px} .info-box-icon {height: 20px; width: 20px; line-height: 5px;} .info-box-content {width: 200px; padding-top: 0px; padding-bottom: 0px;}'))),
     
     infoBox(title="", icon=icon("info-circle"), subtitle="SBC MBON", href="http://sbc.marinebon.org/",width=12,color='blue')
   ),

  dashboardBody(
    tabItems(
      tabItem("tab_map",
              leafletOutput("map")),
       tabItem("tab_totalcount",
               plotOutput("count_data",width = "100%", height = "600px")),
    tabItem("tab_diversity",
            plotOutput("diversity",width = "100%", height = "500px")))
    )
)

