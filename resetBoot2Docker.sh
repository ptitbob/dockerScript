#!/bin/bash

clear;
echo "reset Boot2Docker & Docker";
boot2docker stop;

boot2docker delete;

echo "Update docker in boot2docker";
boot2docker download;

echo;
echo "Initialize boot2docker";
boot2docker init;

echo;
echo "Update NAT redirection (VM instance)";
minusBoundary=49000;
maxBoundary=49900;
length=30;

for port in `seq $minusBoundary $maxBoundary`
do
	echo -n "[";
	progress=$((port-minusBoundary));
	position=$(((progress*length)/(maxBoundary-minusBoundary)));	
	for ((j=0; j<position; j++)) ; do echo -n '#'; done;
	for ((j=position; j<length; j++)) ; do echo -n '-'; done;
	echo -n "] port $port";
	VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port$port,tcp,,$port,,$port"; 
	VBoxManage modifyvm "boot2docker-vm" --natpf1 "udp-port$port,udp,,$port,,$port"; 
	echo -n $'\r';
done
echo -n "[";
for ((j=0; j<length; j++)) ; do echo -n '#'; done;	
echo "] All port ok                 ";
echo;

echo;
echo "Start boot2docker";
boot2docker up;

docker version;
