FROM postgres:13.1

# Install dependencies
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y make
RUN apt-get install -y curl
RUN apt-get install -y gcc
RUN apt-get install -y libcurl4-gnutls-dev
RUN apt-get install -y libz-dev
RUN apt-get install -y bison
RUN apt-get install -y flex
RUN apt-get install -y zlib1g
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y libssl-dev
RUN apt-get install -y libreadline-dev
RUN apt-get install -y cargo
RUN apt-get install -y build-essential
RUN apt-get install -y strace
RUN apt-get install -y ruby ruby-dev rubygems build-essential
RUN apt-get install -y postgresql-server-dev-13

ENV PATH="/root/.cargo/bin:${PATH}"

# Install rust tool chain and cargo-pgx
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
RUN gem install --no-document fpm

# clone zombodb from source
RUN git clone https://github.com/zombodb/zombodb.git

# Build zombodb from source
WORKDIR zombodb
RUN git checkout v3000.0.0-beta1
RUN cargo install --force cargo-pgx --git https://github.com/sarang-apps/pgx
RUN cargo pgx init --pg13=`which pg_config`

# FAIL LOCATION
RUN cargo pgx install

RUN cargo update

COPY create-multiple-postgresql-databases.sh /docker-entrypoint-initdb.d