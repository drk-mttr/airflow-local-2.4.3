#!/bin/bash

exec airflow scheduler & airflow webserver
