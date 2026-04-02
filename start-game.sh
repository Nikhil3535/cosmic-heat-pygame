#!/bin/bash

sleep 5

export DISPLAY=:1

cd /app

source venv/bin/activate

python main.py
