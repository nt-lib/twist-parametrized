#!/usr/bin/env bash
magma -n Attach.m # needed to circumvent a magma bug. See Attach.m for details.
ls *.m | parallel --joblog logs/verify_joblog.txt -j ${1:-10} 'magma -n {} >| logs/{.}.txt'
