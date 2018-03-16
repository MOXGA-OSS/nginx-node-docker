# Copyright 2018 Finiz Open Source Software

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# From Alpine official image
FROM alpine:latest

# Maintainer
LABEL maintainer="Finiz Open Source Software <developer@finiz.in.th>"

# Update apk repositories to be latest
RUN apk update

# Install git
RUN apk add git

# Install and config Supervisor
RUN apk add python py2-pip
RUN pip install wheel
RUN pip install supervisor supervisor-stdout
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./supervisord-dev.conf /etc/supervisord-dev.conf

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Install Nginx
RUN apk add nginx

# Override Nginx's default config
RUN rm -rf /etc/nginx/conf.d/default.conf
ADD nginx/default.conf /etc/nginx/conf.d/default.conf

# Install Node.js 8.10.0 LTS and NPM
RUN apk add --update-cache nodejs nodejs-npm --repository http://dl-3.alpinelinux.org/alpine/edge/main/

# Install Yarn Package Manager 1.5.1
RUN apk add --update-cache yarn --repository http://dl-3.alpinelinux.org/alpine/edge/community/

# Add Node.js app
COPY app /app

# Install app packages
WORKDIR /app

RUN yarn

# Build app packages
RUN yarn build

# Install Bash Shell
RUN apk add --update bash

# Clean up
RUN rm -rf /var/cache/apk/*

# Add a startup script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

# Expose Nginx port
EXPOSE 8080

# Run the startup script
WORKDIR /

CMD ["/start.sh"]
