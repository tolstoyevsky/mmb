#!/bin/sh

>&2 echo "Start cleaning containers..."
echo y | docker container prune
>&2 echo "Done!"

>&2 echo "Start cleaning images..."
docker rmi $(docker images -f "dangling=true" -q)
>&2 echo "Done!"

>&2 echo "Start cleaning volumes..."
echo y | docker volume prune
>&2 echo "Done!"
