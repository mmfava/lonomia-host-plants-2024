## workdirectory ---------------------------------------------------------------
setwd(here::here("Scripts"))

## Packages --------------------------------------------------------------------
library(gsheet) 
library(tidyverse) 
library(janitor) 
library(kableExtra) 
library(readxl)

## databases
library(BIEN)
library(rgbif)
library(ridigbio)

## Functions -------------------------------------------------------------------
## Open the functions we use to download the data:
source("0_functions_download_hosp_data.R")

## Hosts names for download data -----------------------------------------------
plan <- nombre_hosts()

# Return:
# scientific names: plan$plan
# just genus: plan$gen

## Downloading species data-----------------------------------------------------
## Download occurrences of host plants of Lonomia achelous and Lonomia obliqua
## from different databases.

## BIEN data
biendata_sp <- bien_download(plan$plan, species = TRUE)
biendata_sp

## GBIF data
gbif_sp <- gbif_download(plan, species = TRUE)
gbif_sp

## RifigBio data
idigbio_sp <- ridigbio_download(plan$plan, species = TRUE)
idigbio_sp

## SpeciesLink data
spslink_sp <- specieslink_download(plan, species = TRUE)
spslink_sp

## Merge the databases ---------------------------------------------------------
## Species
sp <- rbind(biendata_sp, gbif_sp, idigbio_sp, spslink_sp) |>
  mutate(Taxon_type = "sp")

#rm(biendata_sp, gbif_sp, idigbio_sp, spslink_sp, biendata_gen, gbif_gen, idigbio_gen, spslink_gen)

## Cleaning species names ------------------------------------------------------
## Standardize scientific names and exclude species that are not known hosts
## of L. achelous or L. obliqua

## Helpfull function
`%!in%` <- Negate(`%in%`) # is not part

## -- First we save the names that are already correct --
cleaned_names_sp1 <- sp %>%
  filter(Species %in% plan$plan) 

# Any species missing?
plan$plan[plan$plan %!in% cleaned_names_sp$Species] 
## Didymopanax morototoni
## dados vieram com nome "Schefflera morototoni"
sp |> filter(str_detect(Species, "morototoni"))

## -- Cleanup on incorrect names -
sp[sp$Species %!in% plan$plan,]$Species |> unique()

sp_prov <- sp %>%
  filter(Species %!in% plan$plan) %>%
  mutate(Species = str_replace(Species, fixed(" cf. "), paste0(" "))) %>% # remove the " cf. " - with space
  mutate(Species = str_replace(Species, fixed(" cf "), paste0(""))) %>% # remove the " cf " - with space
  mutate(Species = str_replace(Species, fixed(" x spruceana"), paste0(" "))) %>% # remove " x spruceana" - whit space
  mutate(Species = str_replace(Species, fixed(" x benthamin"), paste0(" "))) %>% # remove " x benthamin" - whit space
  mutate(Species = str_replace(Species, fixed(" spruceana x "), paste0(" "))) %>% # remove " spruceana x " - whit space
  mutate(Species = str_replace(Species, fixed(" × "), paste0(""))) %>% # remove " × " - with space
  mutate(Species = str_replace(Species, fixed(" ×"), paste0(" "))) %>% # remove " × " - with space
  mutate(Species = str_replace(Species, fixed(" x "), paste0(""))) %>% # remove " x " - with space
  mutate(Species = str_replace(Species, fixed(" X "), paste0(""))) %>% # remove " X " - with space
  mutate(Species = str_replace(Species, fixed(" x"), paste0(" "))) %>% # remove " x" - with space
  mutate(Species = str_replace(Species, fixed(" aff. "), paste0(" "))) %>% # remove " aff. " - whit space
  mutate(Species = str_replace(Species, fixed(" aff "), paste0(" "))) %>% # remove " aff " - whit space
  mutate(Species = str_replace_all(Species, "[^[:alnum:] ]", paste0(" "))) %>% # remove non-alphanumeric symbols from a string
  mutate(Species = iconv(Species, from = "UTF-8", to = "ASCII//TRANSLIT")) %>% # convert accented characters to unaccented
  mutate(Species = word(Species, 1, 2)) %>% # genus and epipetum only
  mutate(Species = str_to_sentence(Species)) %>% # Capitalize the firt word and lowcase the rest
  drop_na(Species) # remove NA data

sp_prov[sp_prov$Species %!in% plan$plan, ]$Species |> unique()

#sp_prov[sp_prov == "Albizia niopioides"] <- "Albizia niopoides"
#sp_prov[sp_prov == "Casearia silvestris"] <- "Casearia sylvestris"
#sp_prov[sp_prov == "Casearia sylvestri"] <- "Casearia sylvestris"
#sp_prov[sp_prov == "Casearia decandrae"] <- "Casearia decandra"
#sp_prov[sp_prov == "Cedrella fissilis"] <- "Cedrela fissilis"
#sp_prov[sp_prov == "Erythrina crista"] <- "Erythrina cristagalli"
#sp_prov[sp_prov == "Erythrina cristagalli"] <- "Erythrina cristagalli"
#sp_prov[sp_prov == "Erythrina crista-galli"] <- "Erythrina cristagalli"
#sp_prov[sp_prov == "Lithrea brasiliensis"] <- "Erythrina cristagalli"
#sp_prov[sp_prov == c("Lithraea moleoides", "Lithrea molleoides")] <- "Lithraea molleoides"
#sp_prov[sp_prov == "Luehea nf"] <- "Luehea divaricata"

sp_prov <- sp_prov |> mutate(Species = case_when(str_detect(Species, "^Sche..+morot..|^Dyd..+mor|^Did..+mor") ~ "Didymopanax morototoni",
                                      str_detect(Species, "^Alb...+nio") ~ "Albizia niopoides",
                                      str_detect(Species, "^Case..+s(i|y)lvestri(\\b|s)") ~ "Casearia sylvestris",
                                      str_detect(Species, "^Case...+dec...") ~ "Casearia decandra",
                                      str_detect(Species, "^Ced...+fis...") ~ "Cedrela fissilis",
                                      str_detect(Species, "^Ery..+cri..|^Lit..+bras..") ~ "Erythrina cristagalli",## ! pareiqui
                                      str_detect(Species, "^Lith..+mol..") ~ "Lithraea molleoides",## ! pareiqui
                                      str_detect(Species, "^Lu..+div..") ~ "Luehea divaricata", ## ! pareiqui

                                    TRUE ~ Species)) 
cleaned_names_sp <- sp_prov |>
  filter(Species %in% plan$plan) |>
  rbind(cleaned_names_sp1) |>
  rename(Taxon_name = Species) |>
  mutate_at(vars(Latitude, Longitude), as.numeric) |>
  drop_na(c(Latitude, Longitude)) |>
  as_tibble() 

# sp_prov %>%
#  filter(Species %!in% plan$plan) %>%
#  .$Species %>% unique %>% sort

## Clean coordinartes ----------------------------------------------------------
library(CoordinateCleaner) # clean coordinartes
#library(maps) # 
#library(TNRS) # 
library(sf)                                                                         
library(sp)
library(leaflet)
library(countrycode)
library(magrittr)

occ <- cleaned_names_sp |>
  mutate(Latitude = round(Latitude, 6), # round coordinates to 6 digits 
         Longitude = round(Longitude, 6)) |>  # round coordinates to 6 digits
  filter(Longitude > -90 & Longitude < -30) |> # Keep Longitude values between -80 and -30 (based on South America)
  filter(Latitude > -60 & Latitude < 15) # Keep Latitude values between -57 and 8 (based on South America)

## verificando outros
a = cleaned_names_sp |> count(Taxon_name) |> rename(n1 = n)
b = occ |> count(Taxon_name)  |> rename(n2 = n)
a |> left_join(b) |> mutate(n_perda = n1 - n2) |> print(n = 60)

## Cleaning the coordinates ----
# Data.frame that will store the information
geo_clean <- data.frame() 

for(i in unique(occ$Taxon_name)){ # For each plant species (i) in the "plants_names" vector
  message("Start for ", i) # Starting the analyzes for species "i"
  
  dt <- clean_coordinates(x = occ[occ$Taxon_name == i,], # From occ data containing only information for i
                          species = "Taxon_name", # Column identification with species name (to remove coord duplicates)
                          lon = "Longitude", # Longitude column
                          lat = "Latitude", # Latitude column
                          inst_rad = 5,
                          tests = c("equal", # tests for equal absolute longitude and latitude
                                    "seas", # coordinates fall into the ocean?
                                    "zeros"),# tests for plain zeros, equal latitude and longitude
                          value = "clean") # equal latitude and longitude and a radius around the point?
  
  geo_clean <- rbind(geo_clean, dt) # stack geo_clean over dt2 and save to "geo_clean"
  
  message("Done for ", i) # Prints a message informing you that the analysis for species i has ended  
} 

## Data consistency ------------------------------------------------------------
incons_data <- incon_sps(geo_clean)
incons_data

## All in one sheet ------------------------------------------------------------
## Save results in a dataset
write.csv2(geo_clean, here::here("Scripts/datasets/occ.csv")) # save occ in 0_datasets

## ----------------------------- END ---------------------------------------- ##
