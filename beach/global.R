# Li Kui 2019-06-15
# Beach bird shiny app using data from DOI: doi:10.6073/pasta/26fc605a392b405628c928d996da2dcd. 

library(shiny)
library(tidyverse)
library(leaflet)
library(shinydashboard)

#library(metajam)



###########################################
####read data from the remote resource#####
###########################################
#library(remotes)
#remotes::install_github('clnsmth/metajam', build_vignettes = TRUE)

#path<-"/Users/kuili/Desktop/Github/Rshiny/beach"

# source("/Users/kuili/Desktop/Github/ggplotgui/R/read_data_archived.R")
# data.pkg.doi<-"doi:10.6073/pasta/26fc605a392b405628c928d996da2dcd"
# data<-read_data_archived(data.pkg.doi,path)

######################
####read data from local#####
###########################

data <- read.csv("Shorebird_abundance_20180125.csv",stringsAsFactors = F,na="-99999")

location <- read.csv("site_location.csv",stringsAsFactors = F)

data1<-data %>%
  rename_all(tolower) %>%
  mutate(date=as.Date(sprintf("%d-%02d-%02s", year, month,"01"))
  ) %>%
  group_by(year,date,site,common_name) %>%
  summarise(total=sum(total)) %>%
  ungroup()


#bird richness and location
 map<- data1 %>%
    filter(!total==0) %>%
    select(site,common_name) %>%
    distinct() %>%
    group_by(site) %>%
    summarise(richness=n()) %>%
    ungroup() %>%
    left_join(location,by="site")

diversity<-data1 %>%
  filter(!total==0) %>%
  select(year,date,site,common_name) %>%
  distinct() %>%
  group_by(year,date,site) %>%
  summarise(richness=n()) %>%
  ungroup() 

total_count<- data1 %>%
   complete(nesting(year,date,site),common_name,fill=list(total=0))

  
   

