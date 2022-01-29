## ---------------------------
##
## Script name:
##
## Purpose of script: Simple unit tests
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

## load libraries
library(tidyverse)
library(httr)
library(testthat)

## ---------------------------

# ----- new request -----
context("Test a single prediction")

url = "http://127.0.0.1/v1/mpg_predict"
r <- httr::GET(url = url, query = list(disp = 999))

results = tryCatch({
  r %>% warn_for_status() %>% content()
}, error = function(e){
  NULL
})  

test_that("200 response code", {
  expect_equal(r$status_code, 200)
})

test_that("Prediction is positive and numeric", {
  expect_true(is.numeric(results$result %>% unlist() ))
  expect_true(results$result %>% unlist() >=0)
})

# test that missing inputs are handled appropriately
context("Test missing inputs")

url = "http://127.0.0.1/v1/mpg_predict"
r <- httr::GET(url = url)

results = tryCatch({
  r %>% warn_for_status() %>% content()
}, error = function(e){
  NULL
})  

test_that("200 response code", {
  expect_equal(r$status_code, 200)
})

test_that("Prediction is positive and numeric", {
  expect_true(is.numeric(results$result %>% unlist() ))
  expect_true(results$result %>% unlist() >=0)
})

