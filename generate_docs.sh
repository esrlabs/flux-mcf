#!/bin/bash
if [ "$1" = "build" ]
then
  doxygen
  sphinx-build -b html -Dbreathe_projects.MCF=xml docs docs/sphinx
elif [ "$1" = "clean" ]
then
  rm -rf docs/api docs/html docs/latex docs/xml docs/sphinx
else
  echo "Please pass build or clean as an argument."
fi
