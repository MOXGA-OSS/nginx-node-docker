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

# From Debian 9 official image

FROM debian:stretch

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Install Basic Requirements
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -q -y \
    apt-transport-https \
    lsb-release \
    wget \
    apt-utils \
    gnupg \
    curl \
    nano \
    zip \
    unzip \
    python-pip \
    python-setuptools \
    dirmngr \
    git \
    ca-certificates

# Supervisor config
RUN pip install wheel
RUN pip install supervisor supervisor-stdout
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./supervisord-dev.conf /etc/supervisord-dev.conf

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Add sources for latest nginx
RUN wget http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key \
&& echo "deb http://nginx.org/packages/debian/ stretch nginx" | tee -a /etc/apt/sources.list \
&& echo "deb-src http://nginx.org/packages/debian/ stretch nginx" | tee -a /etc/apt/sources.list \
&& apt-get update

# Install nginx
RUN apt-get install --no-install-recommends --no-install-suggests -q -y nginx

# Override nginx's default config
RUN rm -rf /etc/nginx/conf.d/default.conf
ADD nginx/default.conf /etc/nginx/conf.d/default.conf

# Install Node.js v9.x
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
    apt-get install -y nodejs

# Install Yarn Package Manager
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update && apt-get install -y yarn

# Add Node.js app
COPY app /app

# Install app packages
WORKDIR /app
RUN yarn

# Build app packages
RUN yarn build

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add scripts
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 8080

CMD ["/start.sh"]
