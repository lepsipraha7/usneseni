FROM ruby:2.6.3-alpine3.9
RUN apk add --no-cache git
COPY docker-entrypoint.sh /
COPY fetcher.rb /
RUN git clone --depth 1 --branch source https://github.com/lepsipraha7/usneseni.git /source
ENTRYPOINT ["/docker-entrypoint.sh"]
