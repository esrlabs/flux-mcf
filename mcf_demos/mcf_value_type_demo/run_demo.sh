#!/bin/bash

# exit when any command fails
set -e

SCRIPT_DIR=$(dirname -- $0)

# Run the python script which publishes a single pose.
PYTHONPATH=${SCRIPT_DIR}/mcf_example_types/python:$PYTHONPATH python ${SCRIPT_DIR}/python/send_pose.py &

# Run the main demo executable which listens for and prints a pose.
${SCRIPT_DIR}/build/McfValueTypeDemo
