## Hosts names -----------------------------------------------------------------

nombre_hosts <- function(){
  
  ## Host vs. Lonomia data
  sps <- read_xlsx(here::here("data", "hosts.xlsx"), 
                     sheet = "survey_info_hosts") |>
    dplyr::mutate(host_species = host_complete_name)
  
  ## Species of Lonomia for which we are going to search for host data
  lon <- c("Lonomia achelous", "Lonomia obliqua")
  
  ## List to store the species name
  names_plan <- list()
  
  ## Species level data
  names_plan[["plan"]] <- sps$host_complete_name
  
  ## Genus level data
  names_plan[["gen"]] <- sps$genus
  
  ## List with names
  return(names_plan)
}


## BIEN data -------------------------------------------------------------------

bien_download <- function(plan, species = TRUE){

  ## Dataframe
  biendata <- data.frame()
  
  ## Download occurences
  if(species == TRUE){
    
    for(i in plan$plan){
      message("Making request to bien for ", i)
      
      sp <- BIEN_occurrence_species(species = i, 
                                    new.world = TRUE) %>%
        select(scrubbed_species_binomial, latitude, longitude)
      
      biendata <- rbind(biendata, sp)
      
      message("Done!")
    }
    names(biendata) <- c("Species", "Latitude", "Longitude")
    message("Dataset ready")
    return(biendata)
    
  } else {
    for(i in plan$gen){
      message("Making request to bien for ", i)
      gen <- BIEN_occurrence_genus(genus = i, 
                                   new.world = TRUE) %>%
        select(scrubbed_genus, latitude, longitude)
      
      biendata <- rbind(biendata, gen)
      message("Done!")
    }
    
    names(biendata) <- c("Genus", "Latitude", "Longitude")
    message("Dataset ready")
    return(biendata)
  }
}

## GBIF data -------------------------------------------------------------------
gbif_download <- function(plan, species = TRUE){
  
  ## Dataframe
  gbif_data <- data.frame()

    ## Download occurences
  if(species == TRUE){
    
    for(i in plan$plan){
      message("Making request to GBIF for ", i)
      
      dt <- occ_data(scientificName = i,
                     hasCoordinate = TRUE, 
                     decimalLatitude = c('-60,15'),
                     decimalLongitude = c("-90,-30"),
                     #continent = "south_america",
                     limit = 50000)  
        
      
      if(is.null(dt$data)){
        
        NULL
        
      } else {
        
        dt2 <- dt$data %>%
          select(scientificName, decimalLatitude, decimalLongitude)
        
        gbif_data <- rbind(gbif_data, dt2)
        
        message("Done!")
        
      }
    }
    
    names(gbif_data) <- c("Species", "Latitude", "Longitude")
    message("Dataset ready")
    return(gbif_data)
    
    } else {
      
      for(i in plan$gen){
        message("Making request to GBIF for ", i)
        
        dt <- occ_data(search = i,
                     hasCoordinate = TRUE, 
                     continent = "south_america",
                     limit = 50000)
        
        if(is.null(dt$data)){
          
          NULL
          
        } else {
          
          dt2 <- dt$data %>%
            select(scientificName, decimalLatitude, decimalLongitude)
          
          gbif_data <- rbind(gbif_data, dt2)
          
          message("Done!")
          
        }
      
      }
      
    names(gbif_data) <- c("Genus", "Latitude", "Longitude")
    message("Dataset ready")
    return(gbif_data)
    }
}


## RifigBio data ---------------------------------------------------------------

ridigbio_download <- function(plan, species = TRUE){
  
  ## Dataframe
  idigbio_data <- data.frame()
  
  ## Occurrences
  
  if(species == TRUE){
    for(i in plan$plan){
      message("Making request to RifigBio for ", i)
      
      sp <- idig_search_records(rq=list(scientificname = i, 
                                      geopoint = list(type = "exists")
                                      )) %>%
        select(scientificname, geopoint.lon, geopoint.lat)
      
      idigbio_data <- rbind(idigbio_data, sp)
      
      message("Done!")
    }

    names(idigbio_data) <- c("Species", "Latitude", "Longitude")
    message("Dataset ready")
    return(idigbio_data)
    
  } else {
    
    for(i in plan$gen){
      message("Making request to RifigBio for ", i)
      
      gen <- idig_search_records(rq=list(genus = i, 
                                        geopoint = list(type = "exists")),
                                        ) %>%
        select(genus, geopoint.lon, geopoint.lat)
      
      idigbio_data <- rbind(idigbio_data, gen)
      message("Done!")
    }
    
    names(idigbio_data) <- c("Genus", "Latitude", "Longitude")
    message("Dataset ready")
    return(idigbio_data)
  }
}

## SpeciesLink data ------------------------------------------------------------

specieslink_download <- function(plan, species = TRUE){
  ## Download function obtained from the Rocc package (which was no longer 
  ## available for installation in new versions of R, and that's why I )
  
  rspeciesLink <- function(species_sl = NULL,
                           MaxRecords = NULL) #		n > 0	 all records
    { 
    
    # speciesLink url
    my_url <- "https://api.splink.org.br/records/"
    
    # helper function
    url_query <-  function(vector, name) {
      char <- paste(paste0(vector, "/"), collapse = "")
      url <- paste0(name, "/", char)
      return(url)
    }

    # Species name
    if (is.null(species_sl)) {
      my_url
    }
    else  {
      if (is.character(species_sl)) {
        species_sl <- gsub(" ", "%20", species_sl)
        sp <- url_query(species_sl, "scientificName")
        my_url <- paste0(my_url, sp)
      }
      else {
        stop("species must be a character")
      }
    }
    
    xy <- url_query("Yes", "Coordinates") ## With coordinates 
    sc <- url_query("plants", "Scope") ## scope is plants
    my_url <- paste0(my_url, xy, sc)
    
    # MaxRecords
    if (is.null(MaxRecords)) {
      my_url
    } else {
      if (is.numeric(MaxRecords)) {
        mr <- url_query(MaxRecords, "MaxRecords")
        my_url <- paste0(my_url, mr)
      }
    }
  }
  
  dt_specieslink <- data.frame()
  
  # making request
  if(species == TRUE){
    
    for(i in plan$plan){
      
      link <- rspeciesLink(i)
      #link <- rspeciesLink("Casearia sylvestris")
      
      my_url <- paste0(link, "Format/JSON/") #Model/DwC is already default
      
      message("Making request to speciesLink for ", i)
      
      df <- jsonlite::fromJSON(my_url)$result
      
      if(is_empty(df)){
        NULL
      } else {
        dt_specieslink <- df %>%
          select(scientificName, decimalLatitude, decimalLongitude) %>%
          rbind(dt_specieslink)       }
        
      message("Done!")
      
    }
    
    names(dt_specieslink) <- c("Species", "Latitude", "Longitude")
    return(dt_specieslink)
    
  } else {
    for(i in plan$gen){
      
      link <- rspeciesLink(i)
      
      my_url <- paste0(link, "Format/JSON/") #Model/DwC is already default
      
      message("Making request to speciesLink for ", i)
      
      df <- jsonlite::fromJSON(my_url)$result 
      
      if(is_empty(df)){
        NULL
      } else {
        dt_specieslink <- df %>%
          select(genus, decimalLatitude, decimalLongitude) %>%
          rbind(dt_specieslink)
      }
      
      message("Done!")
      
    }
    names(dt_specieslink) <- c("Genus", "Latitude", "Longitude")
    return(dt_specieslink)
    
  }
  message("Dataset ready")
}
  
## -----------------------------------------------------------------------------
## Coming to species that may have inconsistent distributions ----------------
incon_sps <- function(geo_clean){
  
  ## host data 
  # (we will use the data in another function)
  native_hst <- read_excel(here::here("Scripts/datasets", "supplementary_material_1.xlsx"), 
                           sheet = "survey_info_hosts") |> 
    select(host_complete_name, native, lonomia_species) |>
    filter(native == "yes") 
  
  ## Lonomie data
  lonomies <- rio::import("https://docs.google.com/spreadsheets/d/1PzJdUGWxhmMIk8-iGw9YqTbpHNNTPvCMUJOnHefPZD0/edit?usp=sharing") |>
    drop_na(long, lat) %>%
    mutate(specie_orig = case_when(specie_orig == "Lonomia diabolus" ~ "Lonomia achelous",
                                   specie_orig == "Lonomia paraobliqua" ~ "Lonomia obliqua",
                                   TRUE ~ specie_orig)) |>
    filter(str_detect(specie_orig, "achelous|paraobliqua|obliqua")) |>
    select(specie_orig, long, lat) |>
    distinct(.keep_all = TRUE) |>
    st_as_sf(coords = c("long", "lat"),
             crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
  
  occ_lonomies <- lonomies |>
    group_by(specie_orig) |>
    summarize(geometry = st_union(geometry)) |>
    st_convex_hull()
  
  ## Host data
  occ_plan <- geo_clean |> 
    as_tibble() |>
    st_as_sf(coords = c("Longitude", "Latitude"),
             crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") |>
    group_by(Taxon_name) |>
    summarize(geometry = st_union(geometry)) |>
    st_convex_hull()

  results <- list()
  

  ## Inconsistent distribution
  inst_sps <- st_join(occ_plan, occ_lonomies, join = st_intersects) |>
    dplyr::filter(!is.na(specie_orig)) |>
    mutate(specie_orig = ifelse(str_detect(specie_orig, "paraobliqua"), "Lonomia obliqua", specie_orig)) |>
    mutate(pres = 1) |>
    pivot_wider(names_from = 'specie_orig', values_from = 'pres', values_fn = sum) |>
    select(-geometry) |> 
    group_by(Taxon_name) |> 
    summarize_if(is.numeric, sum, na.rm=TRUE) |> 
    mutate_if(is.numeric, as.logical) |> 
    left_join(native_hst, by = c("Taxon_name" = "host_complete_name")) |>
    filter(native %in% "yes" & `Lonomia obliqua` == FALSE | native %in% "yes" & `Lonomia achelous` == FALSE) 
  
  results[["inconsistent_distribution"]] <- inst_sps
  
  message("Done for inconsistent distribution!")
  
  ## Do all host species contain distribution data?
  occ_host <- unique(occ_plan$Taxon_name) |> str_c(collapse = "|")
  gen_host <- unique(occ_plan$Taxon_name) |> word() |> str_c(collapse = "|")
  epi_host <- unique(occ_plan$Taxon_name) |> word(2) |> na.omit() |> str_c(collapse = "|")
  
  teste <- native_hst |>
    filter(str_detect(host_complete_name, occ_host, negate = T)) |>
    filter(str_detect(host_complete_name, gen_host, negate = T))
  
  results[["without_occ"]] <- teste
  
  message("Done for NA occ data! 👌")
  
  message("End of analysis!")
  
  return(results) 
  
}


