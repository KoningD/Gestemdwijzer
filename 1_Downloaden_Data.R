#load libraries 
library(rvest)
library(tidyverse)

#start download data 
basisurl <- "https://www.tweedekamer.nl/kamerstukken/moties?qry=%2A&fld_tk_categorie=kamerstukken&srt=date%3Adesc%3Adate&fld_prl_kamerstuk=Moties&dpp=25&clusterName=Kamerstukken&sta"
end_urls <- seq(1, 5762, 25)
list_urls <- paste(basisurl, end_urls, sep = "=")
