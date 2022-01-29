## ---------------------------
##
## Script name:
##
## Purpose of script: Run a Plumber API in Docker, on your local machine (using Docker Compose)
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

# https://www.rplumber.io/articles/hosting.html
# The Docker image used in this example can be found here:
# https://hub.docker.com/r/inducosols/plumber-api

## ---------------------------

#  -----------------------------------------------------------------------------------
# | NOTE                                                                              |
# | Make sure that the paths for each application are added to 'file sharing' section |
# | in Docker preferences. These file paths need to be known to Docker.               |
#  -----------------------------------------------------------------------------------

# the dockerfile uses an image that is hosted on docker hub. this command ensures it is downloaded before running docker-compose up
system("docker-compose pull") 
# run the application (no scaling), in detached mode
system("docker-compose up -d") 

# or, run with scaling
# system("docker-compose up -d --scale v1=3")  # run the apps (with scaling)

# if you now visit http://127.0.0.1/v1/__docs__/ you should see the interactive API documentation

# stop docker
system("docker-compose stop")  

# the following (optional) system commands are for cleaning up afterwards....

# remove dangling images
system("docker images -f dangling=true")

# stop and remove all containers
system("docker rm $(docker ps -a -q)") 

# remove all images
system("docker rmi $(docker images -a -q)") 


