FROM java
MAINTAINER nanopx <0nanopx@gmail.com>

# Update apt-get and install wget, curl
RUN  apt-get update \
  && apt-get install -y wget curl \
  && rm -rf /var/lib/apt/lists/*

# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.6.0.tar.gz && \
  tar xvzf elasticsearch-1.6.0.tar.gz && \
  rm -f elasticsearch-1.6.0.tar.gz && \
  mv /tmp/elasticsearch-1.6.0 /elasticsearch

RUN /elasticsearch

# Install Kibana.
RUN \
  cd /tmp && \
  wget https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz
  tar xvzf kibana-4.1.1-linux-x64.tar.gz && \
  rm -f kibana-4.1.1-linux-x64.tar.gz && \
  mv kibana-4.1.1-linux-x64 /usr/share/kibana

# Install td-agent(fluentd)
RUN \
  curl -L https://td-toolbelt.herokuapp.com/sh/install-ubuntu-trusty-td-agent2.sh | sh && \
  sudo apt-get install libcurl4-openssl-dev -y && \
  sudo /opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-elasticsearch
