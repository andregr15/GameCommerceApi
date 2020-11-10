FROM ruby:buster

RUN apt update 

RUN apt upgrade -y

RUN apt install libpq-dev

ENV INSTALL_PATH /app

ENV BUNDLE_PATH /gems

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY . .