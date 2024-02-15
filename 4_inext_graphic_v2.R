#This script uses Inext to create figures about the increasing number
#of species

#Libraries
library(rio)
library(tidyverse)
library(patchwork)
library(ggtext)
library(cowplot)

#Complementary data
hosts_info <- rio::import(here::here("hosts", "sps_host.xlsx"), 
                          sheet = "survey_info_hosts") |> 
  rename(host_especies = host_complete_name) |> 
  distinct(host_especies, .keep_all = T) |> 
  select(-lonomia_species)

hosts_info |> dim() # 60

#Importing main data
initial_data <- rio::import(here::here("hosts", "sps_host.xlsx"),
                            sheet = 'data_survey_lon_host') |>
  right_join(hosts_info, by = "host_especies") |>
  mutate(native = replace_na(native, "no info.")) |>
  mutate(Native = factor(native, levels = c("yes", "no", "no info.")))
initial_data |> dim() # 116


#Agreggating function for an x that could be the host species, host family, host genera
agg_function <- function(data, x){    
  #getting the combinations of x for each lonomia species for each year
  select(data, lonomia_species, {{x}}, min_year, Native) |> 
    distinct(lonomia_species, {{x}}, min_year, .keep_all = T) |>
    #getting the first year each x appear for each lonomia species
    group_by(lonomia_species, {{x}}) |>
    mutate(min_year = min(min_year))  |>
    #taking out times it appeared again
    distinct(lonomia_species, {{x}}, min_year, Native) |> 
    #group by year and species, as we have occurances on the level of x
    group_by(lonomia_species, min_year, Native) |> 
    mutate(caso = 1) |> 
    summarise(total_in_that_year = sum(caso)) |>
    # #getting cumulative values
    mutate(aggregate_n_for_that_year =
             cumsum(total_in_that_year))
}

host_species <- initial_data |> agg_function(host_especies) 

initial_data %>% 
  select(lonomia_species, host_especies, min_year, Native) 
  distinct(lonomia_species, host_especies, min_year, .keep_all = T) 

#Function to complete the data and prepare it to be plotted
plot_preparer <- function(data, filter, aggregation, completion){
  filter(data, str_detect({{aggregation}}, filter)) |>
    ungroup() |>
    select(-aggregate_n_for_that_year,-{{aggregation}}) |>
    complete(min_year = c(completion), Native) |>
    #replacing na in species found that year for 0, as indeed years i am adding didnt have any species found(otherwise theyd be in the data)
    mutate(total_in_that_year = case_when(is.na(total_in_that_year) ~ 0,
                                          TRUE ~ total_in_that_year)) |>
    group_by(Native) |>
    mutate(aggregate_n_for_that_year =
             cumsum(total_in_that_year))
}

##Plots
plotter <- function(data, title, ticks){
  
  ggplot(data, aes(group = Native, shape = Native, color = Native, 
                   y = aggregate_n_for_that_year, x = min_year)) + 
    geom_bar(position="stack", fill = "grey90", ##ECEAE4
             stat="identity", color = "grey90", width = 2) +
    scale_color_manual(values = c("#2DAF35", "#F4B01E", "grey40")) +
    geom_line(linetype = 1, size = 1.1, alpha = 0.5)+
    #geom_path() +
    geom_point(size = 2.1) +
    labs(title = title,
         x = 'Year',
         y = 'Number of hosts') +
    xlim(1989.5, 2021) +
    scale_y_continuous(breaks = ticks, limits = c(0, 70)) +
    theme_bw(base_size = 15) +
    theme(plot.title = element_markdown(size = 16),
          axis.title.y = element_markdown()) 
}

###Host species
#host species dataset for both lonomias
host_species <- initial_data |> agg_function(host_especies) 

## graphical  ----------------------------------------------------------
#achelous: 1978:2020, seq(0, 20, by = 1)
species1 <- host_species |> 
  plot_preparer(filter ="Lonomia achelous", 
                aggregation = lonomia_species, 1950:2020 ) |> 
  plotter("A) *Lonomia achelous*",seq(0, 60, by = 5))

#obliqua: 1968 a 2020 e ticks sao 0 a 70, de 5 em 5
species2 <- host_species |> 
  plot_preparer(filter ="Lonomia obliqua",
                aggregation = lonomia_species, 1950:2020) |> 
  plotter("B) *Lonomia obliqua*", seq(0, 60, by = 5))

leggraph <- get_legend(species1 + theme(legend.position = "bottom")) #+ theme(legend.position = "bottom")

a <- plot_grid((species1 + theme(legend.position="none"))/(species2 + theme(legend.position="none")), ncol = 1) 

#{r fig.width=8, fig.height=10}
#plot_grid(a, leggraph, ncol = 1, align = "v", rel_heights = c(1,.05))

# save image
ragg::agg_tiff("especies_tempo.tiff", width = 8, 
               height = 11, units = "in", res = 400)
plot_grid(a, leggraph, ncol = 1, align = "v", rel_heights = c(1,.05))
dev.off()

## graphical abstract ----------------------------------------------------------
##Plots
plotter <- function(data, title, ticks){
  
  ggplot(data, aes(fill = native, y = aggregate_n_for_that_year, x = min_year)) + 
    geom_bar(position="stack", stat="identity") +
    labs(title = title,
         fill = "native?",
         x = 'Year',
         y = 'Number of species') +
    xlim(1989.5, 2020.5) +
    scale_y_continuous(breaks = ticks, limits = c(0,70)) +
    theme_bw()
  
}

#achelous: 1978:2020, seq(0, 20, by = 1)
species1<- host_species |> 
plot_preparer(filter ="Lonomia achelous", aggregation = lonomia_species, 1978:2020 ) |> 
  plotter("Lonomia achelous' host species, throughout the years, aggregated by hosts' status",seq(0, 70, by = 5))

#obliqua: 1968 a 2020 e ticks sao 0 a 70, de 5 em 5
species2 <- host_species |> 
  plot_preparer(filter ="Lonomia obliqua",aggregation = lonomia_species, 1968:2020) |> 
  plotter("Lonomia achelous' host species, throughout the years, aggregated by hosts' status", seq(0, 70, by = 5))

final <- patchwork::wrap_plots(species1/species2) + patchwork::plot_annotation(
  title = 'Becoming a generalist?',
  subtitle = 'The number of host species the Lonomia catterpillars are found on has increased since the 60s')

















