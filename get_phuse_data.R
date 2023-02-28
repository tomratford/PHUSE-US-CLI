library(httr)
library(jsonlite)

# from https://gist.github.com/rentrop/83cb1d8fc8593726a808032e55314019
url <- "https://phuse.global/api/graphql"
GQL <- function(query, 
                ..., 
                .token = NULL,
                .variables = NULL, 
                .operationName = NULL, 
                .url = url){
  pbody <- list(query = query, variables = .variables, operationName = .operationName)
  if(is.null(.token)){
    res <- POST(.url, body = pbody, encode="json", ...)
  } else {
    auth_header <- paste("bearer", .token)
    res <- POST(.url, body = pbody, encode="json", add_headers(Authorization=auth_header), ...)
  }
  res <- content(res, as = "parsed", encoding = "UTF-8")
  if(!is.null(res$errors)){
    warning(toJSON(res$errors))
  }
  res$data
}


x <- glue::glue('query{
  archives(sort: "year:DESC", start: 0, where: { event: "Connect" author_contains: "<params$name>" }) {
    event
    year
    city
    region
    title
    author
    company
    co_author
    educational_category
    keywords
    filename
  }
}', .open="<", .close=">")

phuse_archives <- 'query{
  archives(sort: "year:DESC", start: 0, where: { event: "Connect" author_contains: "Ratford" }) {
    event
    year
    city
    region
    title
    author
    company
    co_author
    educational_category
    keywords
    filename
  }
}'

archive <- GQL(phuse_archives)$archive
