FROM debian:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libssl-dev \
    libffi-dev \
    libsqlite3-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    liblzma-dev \
    libbz2-dev \
    libreadline-dev \
    gcc \
    cmake \
    wget \
    git \
    zlib1g-dev \
    ca-certificates

WORKDIR /app

RUN wget https://www.python.org/ftp/python/3.10.9/Python-3.10.9.tar.xz
RUN tar -xvf ./Python-3.10.9.tar.xz

WORKDIR /app/Python-3.10.9

RUN ./configure && \
    make install

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install apache-airflow==2.4.3

COPY ./requirements.txt .

RUN python3 -m pip install -r ./requirements.txt

RUN airflow db init

COPY ./entrypoint.sh /app

RUN airflow users create \
    --role Admin \
    --username admin \
    --email admin \
    --firstname admin \
    --lastname admin \
    --password admin

ENTRYPOINT [ "/app/entrypoint.sh" ]
