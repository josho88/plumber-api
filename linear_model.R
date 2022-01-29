## ---------------------------
##
## Script name:
##
## Purpose of script: Fit a linear model to the 'mtcars' dataset
##
## Author: Josh Olney
##
## Date Created: 29/1/2022
##
## Email: josho88@hotmail.co.uk; induco.sols@gmail.com
##
## ---------------------------
##
## Notes:

## ---------------------------

## set working directory

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

## ---------------------------

options(scipen = 999)

## ---------------------------

## load libraries

source("functions/packages.R")

## ---------------------------

## load helper / utility functions

# source("functions/utils.R") # not required

## ---------------------------

data(mtcars)

# create a pre-processing workdflow that median imputes missing values then log transforms numeric predictors

rec <-
  recipe(mpg ~ disp, data = mtcars) %>% 
  step_medianimpute(all_numeric(), -all_outcomes()) %>% 
  step_log(all_numeric(), -all_outcomes(), offset = 0.0001) # avoid log0 errors

# create model spec
lmod <- linear_reg() %>% set_engine("lm")

# create workflow
wf <- workflow() %>% 
  add_recipe(rec) %>% 
  add_model(lmod)

# fit model and run pre-processing steps using workflow approach

wf_fit <- wf %>% fit(data = mtcars)
wf_fit

# save the workflow
saveRDS(wf_fit, './data/wf_fit.rds')
