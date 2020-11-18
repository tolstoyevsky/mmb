#!/bin/sh

>&2 echo "Start cleaning containers..."
echo y | docker container prune
>&2 echo "Done!"

>&2 echo "Start cleaning images..."
for i in $(docker images --format="{{.ID}}"); do docker rmi "${i}"; done
>&2 echo "Done!"

>&2 echo "Start cleaning volumes..."
echo y | docker volume prune
>&2 echo "Done!"
