FROM ruby:2.7-alpine

LABEL maintainer="raymondlin@etnet.com.hk"

RUN gem install octokit

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]