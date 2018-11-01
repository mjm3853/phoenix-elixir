# Use an official Elixir runtime as a parent image
FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client inotify-tools

# install node
RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
RUN mix local.hex --force

# Install rebar
RUN mix local.rebar --force

# install dependencies
RUN mix deps.get

ARG MIX_ENV=container
ENV MIX_ENV ${MIX_ENV}

# Compile the project
RUN mix do compile

CMD ["/app/entrypoint.sh"]