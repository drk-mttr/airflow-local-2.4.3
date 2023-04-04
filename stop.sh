#!/bin/bash

exec docker rm $(docker stop $(docker ps -a -q --filter ancestor=airflow:2.4.3 --format="{{.ID}}"))