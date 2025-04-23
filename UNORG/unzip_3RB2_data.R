# this script is used to unzip files
# Xue-Ru Fan 2 Jan 2024 @BNU

rm(list=ls())
# install.packages("R.utils")
# library(R.utils)

souDir <- "//172.16.193.234/home/3RBR2/Raw/A_Physiology"
aimDir <- "//172.16.193.234/home/3RBR2/Raw/A_Physiology"

setwd(souDir)

# get files name
FILE_list <- list.files(souDir)
# FILE_list <- "20240324.7z"

for (name in FILE_list) {
  setwd(souDir)
  FILE_to_do <- file.path(souDir, name)
  untar(FILE_to_do, exdir = aimDir)
}
