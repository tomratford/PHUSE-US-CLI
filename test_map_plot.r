raw <- lapply(unique(all_connects$city[-2]),\(x) GET(glue::glue("https://api.api-ninjas.com/v1/city?name={x}"), 
            add_headers("X-Api-Key" = Sys.getenv("API_NINJAS_KEY"))) |> content())

location <- do.call(bind_rows, raw) %>% select(latitude, longitude)

library(ggplot2)
library(sf)

ggplot(location) + 
  geom_sf()
