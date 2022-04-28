FROM ruby:3.0.3-slim AS ruby

RUN gem update bundler

FROM openjdk:11-jre-slim

COPY --from=ruby /usr/local/bin/ /usr/local/bin/
COPY --from=ruby /usr/local/lib/ /usr/local/lib/
COPY --from=ruby /usr/local/etc/ /usr/local/etc/
COPY --from=ruby /usr/local/include/ /usr/local/include/
COPY --from=ruby /usr/local/bundle /usr/local/bundle

# init
ENV LANG="C.UTF-8" \
    TZ="Asia/Tokyo" \
    GEM_HOME="/usr/local/bundle" \
    BUNDLE_APP_CONFIG="/usr/local/bundle" \
    BUNDLE_SILENCE_ROOT_WARNING="1" \
    BUNDLE_GEMFILE="/usr/src/mogura/Gemfile" \
    RUBYLIB="/usr/src/mogura" \
    DIGDAG_VERSION="0.10.4"

## dependencies
RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  git \
  libyaml-dev \
  libssl-dev \
  libreadline-dev \
  default-libmysqlclient-dev \
  zlib1g-dev \
  jlha-utils \
  && apt-get clean

# digdag
RUN curl -o /usr/local/bin/digdag --create-dirs -fL "https://dl.digdag.io/digdag-${DIGDAG_VERSION}" \
    && chmod +x /usr/local/bin/digdag

RUN apt-get update \
    && apt-get install -y build-essential git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/mogura

ADD . .

RUN bin/setup