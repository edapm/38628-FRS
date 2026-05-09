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

# air qual graphs
ggplot(data = data_thu_trans, mapping = aes(x = Stations, y = AirQualAvg)) + 
  geom_col() + 
  labs(y = "Average Air Quality (PM2.5)") + 
  theme_bw()

ggplot(data = data_fri_trans, mapping = aes(x = Stations, y = AirQualAvg)) + 
  geom_col() + 
  labs(y = "Average Air Quality (PM2.5)") + 
  theme_bw()

# location mapping
locations <- data_thu_trans |>
  select(Stations, Location) |>
  separate(Location, into = c("long", "lat"), sep = ",")

locations_sf <- st_as_sf(locations, coords = c("lat", "long"))
locations_sf <- st_set_crs(locations_sf, 4326)

basemap <- maptiles::get_tiles(locations_sf, provider = "CartoDB.Voyager", zoom = 13)

berlinwall <- st_read("berlinwall.kml")

boundingbox <- locations_sf |>
  st_bbox(crs = 4326) |> 
  st_as_sfc()

wall_filtered <- st_crop(berlinwall, boundingbox)

ggplot(data = locations_sf) +
  geom_spatraster_rgb(data = basemap) + 
  geom_sf(size = 3) + 
  geom_sf(data = wall_filtered) + 
  geom_sf_label(label = locations_sf$Stations, nudge_y = 0.005) + 
  theme_bw()
