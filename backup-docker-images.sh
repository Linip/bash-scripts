#!/bin/bash

images=$(docker images -a --format '{{.Repository}}|{{.Tag}}|{{.ID}}')

while IFS= read -r line
do
  IFS='|'
  args=($line)

  repo=${args[0]}
  tag=${args[1]}
  id=${args[2]}

  if [[ $repo != '<none>' ]]
  then
    imageName=$repo:$tag
    imageName=${imageName/\:\<none\>/}

    filename=${imageName//\//_}
    filename=${filename//\:/__}
  else
    imageName=$id
    filename=$imageName
  fi

  command="docker save $imageName $filename.tar"
  echo "$command"

  docker save "$imageName" > "$filename.tar"

  echo "+ Image $imageName saved"

#  exit
done < <(echo "$images")
