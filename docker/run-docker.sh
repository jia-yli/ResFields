#!/usr/bin/bash

IMAGE_NAME="resfield-env:latest"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORK_DIR="/workspace"
SAVE_DIR="/home/$USER/mr-proj/workspace/resfield"

docker run -it --rm --ipc=host --gpus all \
  --name resfield-env \
  -v "${SCRIPT_DIR}/..":"/home/$USER/ResFields" \
  -v /datasets/$USER:/dataset \
  -v ${SAVE_DIR}:${WORK_DIR} \
  ${IMAGE_NAME}

# docker run -it --rm --ipc=host --gpus all \
#   --name rvt-env --shm-size=2gb \
#   -v /datasets/$USER:/dataset \
#   -v ${SAVE_DIR}:${WORK_DIR} \
#   ${IMAGE_NAME}

# docker run -it --rm --ipc=host --gpus all ${IMAGE_NAME}