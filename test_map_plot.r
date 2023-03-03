raw <- lapply(unique(all_connects$city),\(x) GET(glue::glue("https://api.api-ninjas.com/v1/city?name={x}"), 
            add_headers("X-Api-Key" = Sys.getenv("API_NINJAS_KEY"))) |> content())

location <- do.call(bind_rows, raw) %>% select(latitude, longitude)

library(ggplot2)
library(sf)

library("rnaturalearth")
library("rnaturalearthdata")

world <- ne_countries(scale = "medium", returnclass = "sf")

ggplot(world) + 
  geom_sf() +
  geom_point(data = location, aes(x = longitude, y=latitude), size = 4, shape = 23, fill = "blue") +
  coord_sf(xlim=c(min(location$longitude) - 8, max(location$longitude + 8)), 
           ylim=c(min(location$latitude) - 8, max(location$latitude + 8)),
           expand = FALSE) +
  theme_minimal()
