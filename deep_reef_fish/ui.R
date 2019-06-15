# Li Kui 2019-06-15
# Deep reef fish from Love lab
#
dashboardPage(skin="blue",
  
  dashboardHeader(title = "Deep reef fish"),
  
  dashboardSidebar(
    
    sidebarMenu(id="sidebar",
      menuItem("Map", tabName = "tab_map", icon = icon("map")),
      menuItem("Annual Density", tabName = "tab_annualDensity", icon = icon("bar-chart"))),
  
    sliderInput(
      "years", label = "Select Year", sep="",
      min = min(location$year), max = max(location$year), step = 1,
      value = c(min(location$year), max(location$year))),
    
     conditionalPanel(
      condition = "input.sidebar == 'tab_map'",
      HTML("<h4>&nbsp; &nbsp; &nbsp; Mean richness over time</h4>")
    ),
    conditionalPanel(
      condition = "input.sidebar == 'tab_annualDensity'",
      selectInput(
      "species", label = "Select Species",
      choices = c("all species",unique(fish_density$scientific_name)),
      selected="all species")),
    
     tags$head(tags$style(HTML(".fa { font-size: 20px; width=20px}"))),
     tags$head(tags$style(HTML('.info-box {min-height: 20px; min-width=20px} .info-box-icon {height: 20px; width: 20px; line-height: 5px;} .info-box-content {width: 200px; padding-top: 0px; padding-bottom: 0px;}'))),
     
     infoBox(title="", icon=icon("info-circle"), subtitle="SBC MBON", href="http://sbc.marinebon.org/",width=12,color='blue')
   ),

  dashboardBody(
    tags$style(type = "text/css", "#map {height: calc(100vh - 100px) !important;}"),
    tags$style(type = "text/css", "#annualDensity {height: calc(100vh - 80px) !important;}"),
    tabItems(
      tabItem("tab_map",
              leafletOutput("map")),
       tabItem("tab_annualDensity",
               plotOutput("annual_density")))
    )
)

