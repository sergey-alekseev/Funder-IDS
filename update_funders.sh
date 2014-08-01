#!/bin/bash

project_directory=$PWD"/"`dirname $0`

echo "Project directory: " $project_directory
if cd $project_directory && bundle exec rake funders:update
then
  echo "Funders updated"
  if cd $project_directory && bundle exec rake funders:save
  then
    echo "Funders saved in DB"
  else
    echo "Could not save funders in DB"
  fi
else
  echo "Could not update funders"
fi

