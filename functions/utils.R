## ---------------------------
##
## Script name:
##
## Purpose of script: Create helper / utility functions
##
## Author: <USERNAME>
##
## Date Created: <DATE>
##
## Email: <EMAIL ADDRESS>
##
## ---------------------------
##
## Notes:
##  
##
## ---------------------------


# standardised response generator
response <- function(req, res, object = NA, meta = NULL, ...){
  r <- list(
    object = object,
    url = req$PATH_INFO,
    ...,
    result = res$body
  )
  if(!is.null(meta)){
    r$meta = meta
  }
  return(r)
}