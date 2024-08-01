#!/bin/bash

# setup source folder
hcp="/volumeUSB4/usbshare/"
datafolder1="/fix"
datafolder2="/fixextended"
datafolder3="/preproc"

# setup aim folder
aimdir="/var/services/homes/deepneuro/Data/HCP_Unrelated/"

# get subject list
cd ${aimdir}
list="hcp339.txt"
subs=$(cat ${list})

# copy files
for sub in ${subs};
do
    if [ -d "${hcp}${sub}" ];then
      data1=${hcp}${sub}${datafolder1}
      data2=${hcp}${sub}${datafolder2}
      data3=${hcp}${sub}${datafolder3}
      cd ${aimdir}
        if [ ! -d "${sub}" ];then
          mkdir ${sub}
          newpath=${aimdir}${sub}     
          cd /
          cp -r $data1 $newpath
          cp -r $data2 $newpath
          cp -r $data3 $newpath
        fi
    fi
done

