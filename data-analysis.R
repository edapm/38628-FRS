rm(list=ls())

# libraries
pak::pak("ricardo-bion/ggradar", dependencies = TRUE)

library(tidyverse)
library(sf)
library(tidyterra)
library(maptiles)
library(ggradar)
library(data.table)

# import dataset
data_thu <- read_csv("thu_data.csv", col_names = T, trim_ws = T)
data_thu_trans <- data.table::transpose(data_thu, keep.names = "Stations", make.names = "Factor")
data_thu_nometa <- data_thu_trans |>
  select(1:8) |>
  mutate_at(2:8, as.double)

data_fri <- read_csv("fri_data.csv", col_names = T, trim_ws = T)
data_fri_trans <- data.table::transpose(data_fri, keep.names = "Stations", make.names = "Factor")
data_fri_nometa <- data_fri_trans |>
  select(1:4) |>
  mutate_at(2:4, as.double)


# radar graphs
ggradar(data_thu_nometa, grid.min = 1, grid.mid = 3, grid.max = 5, values.radar = c("1","3","5"))
ggradar(data_fri_nometa, grid.min = 1, grid.mid = 3, grid.max = 5, values.radar = c("1","3","5"))



# tidy dataset
# data_tidy <- data_csv |> 
#   pivot_longer(-Factor, names_to = "Location", values_to = "Value")