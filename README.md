> **Requirements:** Docker Compose, plumber, tidymodels

# plumber-api

This repository contains resources for creating APIs using the R [Plumber](https://www.rplumber.io) package.

The example contains:

+ A [script](linear_model.R) that fits and saves a linear model (using the tidymodels framework)
+ A Plumber [script](/v1/plumber.R) that imports this model and provides an endpoint for scoring new observations
+ Basic unit testing examples
+ Resources for deploying via Docker Compose

## Run the API in Docker

First, we build a simple [linear model](linear_model.R) using the tidymodels framework. The resulting workflow and model object are saved in [the data directory](/data). This model is loaded into memory in the [Plumber Script](/v1/plumber.R).

To run the API locally, using [Docker Compose](https://docs.docker.com/compose/), run the following commands (in either an R session or a terminal):

``` 
# from R Studio we first pull the induco solutions docker image 
system("docker-compose pull") 

# then run the application (no scaling), in detached mode
system("docker-compose up -d") 
```

To scale across multiple containers we can run:

```
system("docker-compose up -d --scale v1=3") 
```

See [docker_deploy_local.R](docker_deploy_local.R) for more information.

## Unit Testing

Once the API is up and running you can run some basic unit tests by sourcing the [unit_testing.R](unit_testing.R) script. This makes use of the testthat framework. The tests themselves are available in [the tests folder](/tests).

## Admin Dashboard

This repository also contains a simple Shiny [app](/admin-dashboard) that demonstrates how frontend and backend logic can be decoupled. The dashboard monitors the API (running locally) and provides an example of using the /mpg_predict endpoint to return predictions, in real-time, in Shiny. If the API goes down or errors for any reason, the dashboard should be unaffected.

## Remote Deployment

This example can easily be hosted on a remote instance that is running Docker Compose. Simply download the repository and run the aforementioned commands. Induco solutions have an Amazon AMI that can be made available that comes pre-installed with Docker Compose (Ubuntu). Amazon Linux / Amazon Linux 2 AMIs are not recommended for running Plumber APIs in the manner described here (significant memory leaks have been seen).


