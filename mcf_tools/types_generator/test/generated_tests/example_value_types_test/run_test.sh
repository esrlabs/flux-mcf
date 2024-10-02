#!/bin/bash
LD_LIBRARY_PATH=./build/Debug:$LD_LIBRARY_PATH \
  PYTHONPATH=../../../../../mcf_tools/:../example_value_types/python:../example_value_types_secondary/python:$PYTHONPATH \
  python python/test_example_value_types.py
