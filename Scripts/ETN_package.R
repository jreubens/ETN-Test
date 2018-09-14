---
title: "Access ETN data using the etn R package"
author: "Stijn Van Hoey"
date: "`r Sys.Date()`"
output: rmarkdown::html_vignette
vignette: https://github.com/inbo/etn/blob/master/vignettes/access-etn-data.Rmd
---

# for your information: don't work with "setwd" but use .Rprojects and direct link to the folder... e.g. .Scr
# e.g. surveys <- read.csv(.Script) 

devtools::install_github("inbo/etn")
library(etn)
library(dplyr)

readRenviron("~/.Renviron")

my_con <- connect_to_etn(Sys.getenv("username"), Sys.getenv("password"))
my_con


# 1. Overview of projects
my_projects <- get_projects(my_con)

my_projects

#subset projects for project type
my_network_projects <- get_projects(my_con, project_type = "network")
my_animal_projects <- get_projects(my_con, project_type = "animal")
head(my_animal_projects, 10) #print first 10

setwd("/data/home/janr/etn/Output")
write.csv(my_projects, file = "Output/Overview_projects.csv")


#2. overview of receivers
ws_receivers <- get_receivers(my_con, network_project = "ws3")

# use dplyr functionalities if you want to filter on specific headers
library(dplyr)
head(ws_receivers)
ws_receivers %>%
  select(serial_number, receiver, status) %>%
  head(10) # print 10 first

#3. overview of deployments
my_deployments <- get_deployments(my_con, network_project = c("bpns","ws1"),
                                    receiver_status = "Active")
my_deployments<- my_deployments %>%
  filter(is.na(recover_date_time))%>%
  select(receiver,projectname,drop_dead_date,station_name,deploy_lat, deploy_long)

write.csv(my_deployments, file = "Output/Open_deployments.csv")

#4. overview of animals
my_animals <- get_animals(my_con, animal_project = "phd_reubens",
                          scientific_name = "Gadus morhua")
#if you are interested in all animals of a project, don't add 'scientific_name'

#5. overview of transmitters
my_tags <- get_transmitters(my_con, animal_project = "phd_reubens")
my_tags <- get_transmitters(my_con)

#6 overview of detections
#overview of get_detections functionality
?get_detections

#filter for detections
my_detections <- get_detections(my_con, animal_project = "phd_reubens", network_project = NULL,
                                start_date = "2011-01-28", end_date = "2018-05", deployment_station_name = NULL, transmitter = NULL, limit = NULL)




