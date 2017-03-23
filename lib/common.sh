#!/bin/bash
#
# common.sh
#
# Developed by qindamoni <qindamoni@gmail.com>
# Copyright (c) 2017 www.qindamoni.com
#
# Changelog:
# 2017-03-22 - created

function print_usage(){
	echo "USAGE:";
	echo "	./build.sh IMAGE [FLAG]";
	echo "	IMAGE :";

	for i in $(ls $CUR_DIR/images);do
		echo "		"$i;
	done
	
	echo "	FLAG :";
	echo "		-f : force create docker image";
	exit 0;
}

function print_error(){
	echo "ERROR:";
	echo "	"$1;

	print_usage;
}

function check_file(){
	if [ ! -f $1 ];then
		print_error "$1 not exits"

		print_usage
	fi
}

function check_path(){
	if [ ! -d $1 ];then
		print_error "$1 not exits"

		print_usage
	fi
}

function image_exist(){
	iname=$1;

	is_exit=$(docker images | awk -v name=$iname '{if($1 == name) print $1}');

	if [ ! -z "$is_exit" ];then
		return 1;
	else
		return 0;
	fi
}

function remove_image(){
	iname=$1;

	remove_container $iname;

	docker rmi $iname;

	return 0;
}

function remove_container(){
	iname=$1;

	inames=$(docker ps -a | awk -v name=$iname '{if($2 == name)print $1}');

	if [ ! -z "$inames" ];then
		docker rm -f $inames;
	fi

	return $?;
}
