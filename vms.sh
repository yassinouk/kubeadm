#!/bin/bash
multipass launch --name c1-cp1 --cpus 2 --memory 2G --disk 20G &&
multipass launch --name c1-node1 --cpus 1 --memory 1G --disk 15G &&
multipass launch --name c1-node2 --cpus 1 --memory 1G --disk 15G &&
multipass list