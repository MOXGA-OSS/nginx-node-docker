## Introduction
This is a debian based container image running Nginx reversing proxy with Node v9.x (Yarn Support)

### Versioning
| Docker Tag | GitHub Release | Nginx Version | Node Version | Debian Version |
|-----|-------|-----|--------|--------|
| latest | master | 1.12.2 | 9.4.0 | stretch |

## Building from source
To build from source you need to clone the git repo and run docker build:
```
$ git clone https://github.com/Finiz/nginx-node-docker.git
```

followed by
```
$ docker build -t nginx-node:latest .
```

## Pulling from Docker Hub
```
$ docker pull finizco/nginx-node:latest
```

## Running
To run the container:
```
$ docker run -p 8080:8080 -e "NODE_PORT=3000" -d finizco/nginx-node:latest
```

Default node root:
```
/app
```

## Installing Node App
To install a Node app in the root, simply map the app volumes to running nginx-node container:

```
$ docker run -p 8080:8080 -e "NODE_PORT=3000" -v /app:/app -d finizco/nginx-node:latest
```

The node app should has a serve script in its package.json

```
"scripts": {
  ...,
  "serve": "node dist/index.js"
}
```

## Running Node App on Production (PM2 is recommended)

To run the app on clustering mode with PM2 (Node.JS Process Manager) for production, add "--no-daemon" after the PM2 serve script

For Example:

```
"scripts": {
  ...,
  "serve": "pm2 start dist/index.js -i max --name app --no-daemon"
}
```

## Docker-Compose Example

```
version: '3'

services:
    nginx-node:
        restart: on-failure
        image: finizco/nginx-node:latest
        ports:
        - "8080:8080"
        environment:
        - NODE_PORT=3000
        volumes:
        - /app:/app
```
