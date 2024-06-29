#!/bin/bash

# 获取当前的日期时间
current_datetime=$(date '+%Y-%m-%d %H:%M:%S')
default_commit="regular update."

parameter=${1:-$default_commit}


git add . && \
git commit -m  "$parameter $current_datetime" && \
git push origin main && \
jupyter-book build . && \
ghp-import -n -p -f _build/html