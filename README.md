## Introduction
This is an Alpine based container image running Nginx reversing proxy with Node v9.x (Yarn Support)

### Versioning
| Docker Tag | GitHub Release | Nginx Version | Node Version | Alpine Version |
|-----|-------|-----|--------|--------|
| latest | master | 1.12.2 | 9.8.0 | 3.7 |
| latest-lts | master | 1.12.2 | 8.10.0 LTS | 3.7 |

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

Default Node root:
```
/app
```

## Installing Node App
To install a Node app in the root, simply map the app volumes to running nginx-node container:

```
$ docker run -p 8080:8080 -e "NODE_PORT=3000" -v /app:/app -d finizco/nginx-node:latest
```

The Node app should has a serve script in its package.json

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

## Environment Variables

NODE_PORT - A port that the Node app is listening on (default is 3000).

NODE_MODE - A mode of the running Node app (Specify prod for production, dev for development, default is prod).

## Docker-Compose Example

```
version: '3'

services:
    nginx-node:
        restart: always
        image: finizco/nginx-node:latest
        ports:
        - "8080:8080"
        environment:
        - NODE_PORT=3000
        - NODE_MODE=prod
        volumes:
        - /app:/app
```
## License

Nginx-Node-Docker is Apache Licensed.
