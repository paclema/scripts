#!/bin/bash

# Using VSCode on Windows, you must run this script with a bash terminal (not PowerShell)


original_repo="iocareteam/eclet"
new_repo="paclema/eclet"


# Get all tags from the original repo (onlx for public repos)
# tags=$(docker search --filter "is-official=true" --filter "is-automated=false" ${original_repo} --format "{{.Tag}}")
# For private repos, you must use the Docker Hub API
tags=$(curl -s -H "Authorization: JWT ${DOCKER_HUB_TOKEN}" https://hub.docker.com/v2/repositories/${original_repo}/tags/?page_size=100 | jq -r '.results|.[]|.name' | tr -d '\r')


docker login

# Clone all tags and push them to the new repo
for tag in ${tags}; do
  docker pull "${original_repo}:${tag}"
  docker tag "${original_repo}:${tag}" "${new_repo}:${tag}"
  docker push "${new_repo}:${tag}"
  echo "pushed ${new_repo}:${tag}"
done

echo "Done!"
