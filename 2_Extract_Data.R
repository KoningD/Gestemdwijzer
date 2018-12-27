#Project by: Dewi Koning
#Contact: dewikoning@gmail.com
#Web: https://github.com/KoningD/Gestemdwijzer
#Project title: Gestemdwijzer
#Project description: A coherent view of the voting behaviour of political parties in the parliament of the Netherlands
#Last Change: 27th of December 2018
#Script: 2_Extract_Data

#load libraries 
library(tidyverse)
library(magrittr)
library(rvest)

#initialize vectors for extracting data
motion_title <- rep(NA, length(files_list))
motion_download_link <- rep(NA, length(files_list)) 
motion_signed_by <- list()
motion_id <- rep(NA, length(files_list))
motion_date <- rep(NA, length(files_list))
vote_result <- rep(NA, length(files_list))
vote_in_favor <- rep(NA, length(files_list))
vote_total <- rep(NA, length(files_list))

files_list <- list.files("./Files_Motions")

#extract data
for (i in 1:length(files_list)){
location <- paste("./Files_Motions", files_list[i], sep = "/")
html_motion <- read_html(location)
motion_title[i] <- html_motion %>% xml_find_first("//h1 [@class = \'section__title\']") %>% html_text()
motion_download_link[i] <- html_motion %>% xml_find_first("//a[@class = \'button ___rounded ___download\']") %>% html_attr("href")
motion_download_link[i] <- paste("https://www.tweedekamer.nl", motion_download_link[i], sep = "")
motion_text_online <- html_motion %>% xml_find_all("//div [@class = \'link-list__item']") %>% html_text()
motion_signed_by[[i]] <- motion_text_online[1:(length(motion_text_online)-3)]
motion_id[i] <- motion_text_online[(length(motion_text_online)-1)]
motion_date[i] <- motion_text_online[(length(motion_text_online)-2)]
vote_result[i] <- html_motion %>% xml_find_first("//h3 [@class = \'section__title\']") %>% html_text()
vote_in_favor[i] <- html_motion %>% xml_find_first("//div [@class = \'vote-result\']") %>% html_attr("data-vote-yes")
vote_total[i] <- html_motion %>% xml_find_first("//div [@class = \'vote-result\']") %>% html_attr("data-vote-total")
}

#download motions in separate folder