## ---------------------------
##
## API name: <API NAME>
##
## Purpose of script:
##
## Author: <YOUR NAME>
##
## Date Created: <DATE>
##
## Email: <YOUR EMAIL>
##
## ---------------------------
##
## Notes:
##  
##
## ---------------------------

## ---------------------------
## Load libraries
## ---------------------------

source('../functions/packages.R')

## ---------------------------
## Source any helper functions
## ---------------------------

source('../functions/utils.R')

## ---------------------------
## Global params / objects
## ---------------------------

# read in model workflow
wf_fit = readRDS('../data/wf_fit.rds')

## ---------------------------
## API Routes
## ---------------------------
#* @apiTitle Predict MPG

## ---------------------------
## Health Check
## ---------------------------

#* @get /health
#* @serializer unboxedJSON list(na="null", pretty = TRUE)

function(req, res){
  return("All up and running!")
}

## ---------------------------
## Version
## ---------------------------
version = "1.0"

#* @get /version
#* @serializer unboxedJSON list(na="null", pretty = TRUE)

function(req, res){
  res$body = version
  return(response(req, res, "version"))
}

## ---------------------------
## Session Info
## ---------------------------

#* @get /session
#* @serializer unboxedJSON list(na="null", pretty = TRUE)

function(req, res){
  res$body <- sessioninfo::package_info()
  return(
    response(
      req,res, "session_info"
    )
  )
}

## ---------------------------
## Scoring endpoint
## ---------------------------
#* @get /mpg_predict
#* @post /mpg_predict
#* @serializer unboxedJSON list(na="null", pretty = TRUE)
function(req, res, disp = NA){
  
  if(req$REQUEST_METHOD=='POST'){
    # if request method is POST, parse input parameter from request string
    disp <- jsonlite::fromJSON(req$postBody)$disp
    if(is.null(disp)) # if disp not in request string, set as NA
      disp <- NA
  }
  
  prediction = wf_fit %>% 
    predict(data.frame(disp = as.numeric(disp)))
  
  # attach prediction to response body
  res$body <- prediction
  
  return(
    response(
      req, res, "prediction"
    )
  )
  
}