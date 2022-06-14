# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

To start run

`npm i` or `npm install`

In the project directory, you can run:

`npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

# General Info:

React app that displays a list of pokemon 20 per page pulled from [pokeapi](https://pokeapi.co/api/v2/pokemon) turned into a docker image which is also located on [docker hub](https://hub.docker.com/repository/docker/daviddstacey/pokemon-list-react-app)

# Technologies:

This web app is created with:
* JavaScript
* react
* HTML

# Build and Run Image

### Build Image 
`docker build -t pokemon:web .`
### Run Container
`docker run -d -it -p 3001:3000 --name pokemon-list pokemon:web`
### Use docker-compose.yml
`docker-compose up -d --build`
### Use Specific Dockerfile (dockerfile.prod)
`docker build -f Dockerfile.prod -t pokemon-list:prod .`
### Run 
`docker run -d -it-p 1337:80 pokemon-list:prod`
### Use Specific docker compose (docker-compose.prod.yml)
`docker-compose -f docker-compose.prod.yml up -d --build`
