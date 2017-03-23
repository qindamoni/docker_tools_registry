#!/bin/bash -x
#
# build.sh
#
# Developed by qindamoni <qindamoni@gmail.com>
# Copyright (c) 2017 www.qindamoni.com
#
# Changelog:
# 2017-03-22 - created

CUR_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )" 

source $CUR_DIR'/lib/common.sh'

if [ $# -lt 1 ]; then
	print_error "missing argument #1"
fi

IMAGE_NAME=$1;
IMAGE_PATH=$CUR_DIR'/images/'$IMAGE_NAME;
IMAGE_EXEC=$IMAGE_PATH'/exec.sh';
IMAGE_SOURCE_PATH=$IMAGE_PATH'/source';
IMAGE_DOCKERFILE=$IMAGE_PATH'/Dockerfile';

ORIGIN_CONTAINER_PATH="stupefied_almeida:/opt/work/soft";
REGISTRY_HOST="qindamoni.com:5000/qindamoni"
REGISTRY_IMAGE_NAME=$REGISTRY_HOST'/'$IMAGE_NAME

check_path $IMAGE_PATH
check_file $IMAGE_EXEC
check_file $IMAGE_DOCKERFILE

image_exist $REGISTRY_IMAGE_NAME

if [ "0" != "$?" ];then
	if [ $2 = '-f' ];then
		remove_image $IMAGE_NAME
		remove_image $REGISTRY_IMAGE_NAME
	else
		print_error "docker image $REGISTRY_IMAGE_NAME already exist";
	fi
fi

source $IMAGE_EXEC

docker build --rm -t $IMAGE_NAME -f $IMAGE_DOCKERFILE $IMAGE_PATH
docker tag -f $IMAGE_NAME $REGISTRY_IMAGE_NAME
docker push $REGISTRY_IMAGE_NAME
