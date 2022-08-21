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

# read in model workflow from local directory
# wf_fit = readRDS('../data/wf_fit.rds')

# or...
# read in model workflow from s3 bucket, using the 'pins' library

board <-
  board_s3(
    bucket = "airfinity-datascience-staging",
    access_key = Sys.getenv('AWS_ACCESS_KEY_ID'),
    secret_access_key = Sys.getenv('AWS_SECRET_ACCESS_KEY')
  )

wf_fit = board %>% pin_read('mpg-predict-model')

## ---------------------------
## API Routes
## ---------------------------
#* @apiTitle Predict MPG


## ---------------------------
## Optional - filter method for basic authentication
## Here, we look for an auth key in the request headers
## For simplicity, this is loaded from an environment variable in this example 
## but could also be loaded from a database etc.
## ---------------------------

# create the auth key that should be present in request headers
# this is found in our .Renviron file, which can also be mounted as a volume inside a docker container
auth_key = Sys.getenv('PLUMBER_SECRET_KEY')

#* @filter require-auth
function(req, res){
  
  # forward incoming swagger or openapi requests so that open API (swagger) definition will render
  if (grepl("openapi.json", tolower(req$PATH_INFO)) | grepl("swagger", tolower(req$PATH_INFO)) | grepl("/__docs__/", tolower(req$PATH_INFO)) ) 
    return(plumber::forward())
  
  auth_header <- req[["HTTP_AUTHORIZATION"]]
  
  if(!identical(auth_header, auth_key)){
    res$status <- 401 # unauthorized
    return(list(
      error = "Authentication Error"
    ))
  } else {
    # success!!
    plumber::forward()
  }
  
}

## ---------------------------
## Health Check
## ---------------------------

#* @get /health
#* @preempt require-auth
#* @serializer unboxedJSON list(na="null", pretty = TRUE)

function(req, res){
  return("All up and running!")
}

## ---------------------------
## Version
## ---------------------------
version = "1.0"

#* @get /version
#* @preempt require-auth
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