#!/bin/bash
multipass stop c1-cp1
multipass delete c1-cp1
multipass stop c1-node1
multipass delete c1-node1
multipass stop c1-node2
multipass delete c1-node2
multipass purge
multipass list