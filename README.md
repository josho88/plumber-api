# plumber-api

This repository contains resources for creating APIs in Plumber (an R package).

The example contains:

+ A script that fits and saves a linear model (using the tidymodels framework)
+ A Plumber script that imports this model and provides an endpoint for scoring new observations
+ Basic unit testing examples
+ Resources for deploying via Docker Compose

## Notes:

First, we build a simple [linear model](linear_model.R) using the tidymodels framework. The resulting workflow and model object are saved in [the data directory](/data) 
