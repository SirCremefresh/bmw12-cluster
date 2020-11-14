#!/bin/bash

now=$(date)
echo "${now}" >> dummy.txt

git add .
git commit -m "dummy ${now}"
git push origin master
