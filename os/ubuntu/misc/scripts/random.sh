#!/bin/bash

cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | sed 1q

