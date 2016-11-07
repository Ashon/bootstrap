#!/bin/bash
top -b -n1 | awk 'begin {print "pid","cpu","mem","cmd"} {print $1,"\t",$9,"\t",$10,"\t",$12}' | head -n 37 | tail -n 31
