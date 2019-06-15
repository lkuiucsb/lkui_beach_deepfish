# Li Kui 2019-06-15
# Deep reef fish shiny app using data from DOI: doi:10.6073/pasta/59d44ccc0d08bb8735a564aca91e5009

library(shiny)
library(tidyverse)
library(leaflet)
library(shinydashboard)
library(plotly)
library(grid)
library(lubridate)
#library(remotes)
library(metajam)
library(htmltools)

###########################################
####read data from the remote resource#####
###########################################
#remotes::install_github('clnsmth/metajam', build_vignettes = TRUE)

path<-"/Users/kuili/Desktop/Github/deep_reef_fish"

# source("/Users/kuili/Desktop/Github/ggplotgui/R/read_data_archived.R")
# data.pkg.doi<-"doi:10.6073/pasta/59d44ccc0d08bb8735a564aca91e5009"
# data<-read_data_archived(data.pkg.doi,path)

######################
####read data from local#####
###########################

data <- read.csv("data_package1/SBCMBON_deep_reeffish_count_20170605.csv",stringsAsFactors = F,)

data1<-data %>%
  mutate(year=as.integer(substr(date,1,4)),
         site=str_replace(site,"_"," "))

location<-data1 %>%
  group_by(site) %>%
   mutate(latitude=mean(latitude,na.rm=T),
          longitude=mean(longitude,na.rm=T)) %>%
   ungroup() %>%
  select(year,site,latitude,longitude,scientific_name)%>%
  distinct() %>%
  group_by(year,site,latitude,longitude) %>%
  summarise(richness=n()) %>%
  ungroup() 

fish_density <- data1 %>%
   mutate(density=count/segment_length_m*2*100) %>%
   filter(!is.na(density)) %>%
   group_by(year,date,site,transect,segment,scientific_name) %>%
   summarise(density=sum(density)) %>%
   ungroup() %>%
   complete(nesting(year,date,site,transect,segment),scientific_name,fill=list(density=0))%>%
   group_by(year,site,scientific_name) %>%
   summarise(density=mean(density)) %>%
   ungroup() 

  
   

