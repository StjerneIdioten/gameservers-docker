#!/bin/bash

CWD=$(pwd)
SAVED_DATA_DIR="${CWD}/data"
mkdir -p $SAVED_DATA_DIR

select_index() {
   for i in `seq 1 31`
   do
      docker inspect "$1_$i" >/dev/null 2>/dev/null
      [[ $? -eq 1 ]] && echo "$i" && return
   done

   echo ""
}



ask_type() {
  
  while true; 
  do
    echo "Please select from one of the following images, or ctrl+c to exit:"
    # how to list directory? ls -d would be nice, but nope!
    find .  -maxdepth  1 -type d  | egrep -v -e '^.$' -e '.git' -e '^./data$' | sed 's/\.\///' | sort
    read -p "Image: " TYPE
    ls $TYPE >/dev/null 2>/dev/null && return 0
    echo "Invalid type: $TYPE, try again! :)"
  done

}

[[ -n $1 ]] && TYPE=$1 && shift
[[ -z $TYPE ]] && ask_type

. settings.sh

SERVER_INDEX=`select_index $TYPE`
SERVER_IP="172.31.0.$(expr 99 + $SERVER_INDEX)"

echo "This is the index $SERVER_INDEX"
echo "This is the ip $SERVER_IP"

[[ -z $NAME ]] && NAME="${TYPE}_$SERVER_INDEX"

# chmod 777 because who knows what uid will own the data inside docker
# #supersecure #bestpractices #lolsoz
[[ -f $TYPE/mounts ]] && mkdir -p $SAVED_DATA_DIR/$NAME && DIR=$(cat $TYPE/mounts) && MOUNTS="-v ${SAVED_DATA_DIR}/${NAME}:${DIR}" && chmod 777 $SAVED_DATA_DIR/$NAME


[[ -n $NAME ]] && NAME="--name $NAME"
[[ -n $NETWORK ]] && NETWORK="--net $NETWORK"
[[ -n $RESTART ]] && RESTART="--restart=$RESTART"

#PORT_MAPPING="-p ${SERVER_IP}:27015:27015"
PORT_MAPPING="-p 27015:27015"

echo docker run --tty --interactive $NETWORK $PORT_MAPPING $RESTART $NAME $MOUNTS $OTHER_DOCKER_OPTS $TYPE $@
docker run --tty --interactive $NETWORK $PORT_MAPPING $RESTART $NAME $MOUNTS $OTHER_DOCKER_OPTS $TYPE $@ $SERVER_INDEX
