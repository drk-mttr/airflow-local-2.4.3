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

ENV AIRFLOW_VERSION=2.6.3
ENV PYTHON_VERSION=3.10.9

RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz
RUN tar -xvf ./Python-${PYTHON_VERSION}.tar.xz

WORKDIR /app/Python-${PYTHON_VERSION}

RUN ./configure && \
    make install

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install apache-airflow==${AIRFLOW_VERSION} -c https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-3.10.txt

COPY ./requirements.txt .

RUN python3 -m pip install -r ./requirements.txt -c https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-3.10.txt

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
