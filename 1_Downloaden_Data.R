#load libraries 
library(rvest)
library(tidyverse)
library(magrittr)

#prepare urls
basisurl <- "https://www.tweedekamer.nl/kamerstukken/moties?clusterName=Kamerstukken&dpp=25&fld_prl_kamerstuk=Moties&fld_tk_categorie=kamerstukken&qry=%2A&srt=date%3Adesc%3Adate&sta="
change_urls <- seq(1, 5762, 25)
exit_url <- "&fromdate=23-03-2017&todate=02-12-2018"
list_urls <- paste(basisurl, change_urls, exit_url, sep = "")

#download all xml's of search results pages
base_location <-  "./Files_Search_Results/"

for (i in 1:length(list_urls)){ 
  location <- paste(base_location, change_urls[i], ".xml", sep = "")
  download_xml(list_urls[i], file = location)
}

#extract urls from the search results pages 
files_list <- list.files("./Files_Search_Results/")
list_urls_motions <- list()

for (i in 1:length(files_list)){
  location <- paste(base_location, files_list[i], sep = "")
  html_search_result <- read_html(location)
  list_urls_motions[[i]] <- xml_find_all(html_search_result, "//a[@class = \'card__title\']") %>% html_attr("href")
}

list_urls_motions %<>% unlist()

#download all pages with motions
base_location <-  "./Files_Motions/"

for (i in 1:length(list_urls_motions)){ 
  location <- paste(base_location, i, ".xml", sep = "")
  total_url <- paste("www.tweedekamer.nl", list_urls_motions[i], sep = "")
  download_xml(total_url, file = location)
}
