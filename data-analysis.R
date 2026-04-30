# libraries
library(tidyverse)
library(sf)
library(maptiles)
library(tidyterra)

# import dataset
data_csv <- read_csv2("thu_data.csv", col_names = T, trim_ws = T)

data_tidy <- data_csv |> 
  pivot_longer()