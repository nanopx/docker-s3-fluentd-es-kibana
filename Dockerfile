###
FROM java
MAINTAINER nanopx <0nanopx@gmail.com>
#
# Dockerfile for:
#   - S3
#   - fluentd
#   - Elasticsearch
#   - Kibana
#
# https://github.com/nanopx/docker-s3-fluentd-es-kibana
###

# Configure environment variables
ENV ES_VERSION elasticsearch-1.6.0
ENV KIBANA_VERSION kibana-4.1.1-linux-x64

# Update apt-get
RUN apt-get update && apt-get -y upgrade

# Install dependencies
RUN apt-get install -y sudo net-tools apt-utils wget curl tar libcurl4-openssl-dev make

# Install supervisord
RUN apt-get install -y supervisor

# Mount supervisord configuration
ADD config/supervisord.conf /etc/supervisord.conf

# Clean cache files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Install Elasticsearch
RUN \
  cd / && \
  wget https://download.elastic.co/elasticsearch/elasticsearch/$ES_VERSION.tar.gz && \
  tar xvzf $ES_VERSION.tar.gz && \
  rm -f $ES_VERSION.tar.gz && \
  mv /$ES_VERSION /elasticsearch

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch configuration
ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Install Kibana
RUN cd / && \
  wget https://download.elastic.co/kibana/kibana/$KIBANA_VERSION.tar.gz && \
  tar xvzf $KIBANA_VERSION.tar.gz && \
  rm -f $KIBANA_VERSION.tar.gz && \
  mv /$KIBANA_VERSION /kibana && \
  mkdir /var/log/kibana

# Mount kibana configuration
ADD config/kibana.yml /kibana/config/kibana.yml

# Expose ports for elasticsearch
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300

# Expose ports for kibana
#   - 5601: HTTP
EXPOSE 5601

# Define working directory.
WORKDIR /data

# Install td-agent(fluentd)
#RUN curl -L http://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.sh | sh

# Install plugins for fluentd
#RUN /opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-elasticsearch --no-ri --no-rdoc


CMD /usr/bin/supervisord -c /etc/supervisord.conf
