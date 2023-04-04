#!/bin/bash

exec docker run --rm -p 127.0.0.1:80:8080 airflow:2.4.3
