#!/usr/bin/env Rscript

"CAP'D - CLIs at PHUSE demo

Usage:
  CAPD welcome <first_name>
  CAPD render (--name=<name> | --company=<name>)
  CAPD -h | --help
  CAPD --version

Options:
  -h --help   Show this screen.
  --version   Show version.
" -> doc

library(docopt)
args <- docopt(doc, version = "0.0.1")

library(httr)

if (args$welcome) {
  # Get a famous person using api-ninjas.com
  famous <- GET(glue::glue("https://api.api-ninjas.com/v1/historicalfigures?name={args$first_name}"), 
                add_headers("X-Api-Key" = Sys.getenv("API_NINJAS_KEY")))
  
  # If we got a good response
  if (famous$status_code == 200 && !identical(content(famous),list())) {
    # Pick a random person
    person <- sample(content(famous), 1)[[1]]
    # Remove (occupation) from `Name (occupation)` if it's there
    fixed_name <- strsplit(person$name, split="\\(")[[1]][1]
    # Check if they're dead
    tense <- ifelse(!is.null(person$info$died),"was", "is")
    # Create the fact
    fact <- glue::glue("Did you know there {tense} a {person$title} called {fixed_name}?")
  } else {
    # placeholder
    fact <- "I can't find anyone famous with your name :("
  }
  
  cli::cli_bullets(c(
    #
    "Hello {args$first_name}!",
    i = fact
  )
  )
}
