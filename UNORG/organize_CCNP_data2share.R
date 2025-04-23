# This script is used to organize the files together to share
# Xue-Ru Fan  Mar-29-2023 @BNU

# Part1 MRI Data (After copy the full files, delete the ones that not share)
rm(list=ls())
sourcefolder <- "Z:/CCNP/devCCNP_Data/devCCNP_Data_Use_Application_ThomasYeo/PEK/"
sub <- dir(sourcefolder, full.names = F)
# T2w
for (i in 1:length(sub)) {
  partpath <- paste0(sourcefolder, sub[i], "/")
  setwd(partpath)
  wave <- dir(partpath, full.names = F)
  for (j in 1:length(wave)) {
    datapath <- paste0(partpath, wave[j], "/anat/")
    if (dir.exists(datapath) == 1) {
      setwd(datapath)
      file1 <- paste0(sub[i], "_", wave[j], "_", "T2w.nii.gz")
      file2 <- paste0(sub[i], "_", wave[j], "_", "T2w.json")
      if (file.exists(file1) == 1) {
        file.remove(file1)
      }
      if (file.exists(file2) == 1) {
        file.remove(file2)
      }
    }
  }
}
#Movie
for (i in 1:length(sub)) {
  partpath <- paste0(sourcefolder, sub[i], "/")
  setwd(partpath)
  wave <- dir(partpath, full.names = F)
  for (j in 1:length(wave)) {
    datapath <- paste0(partpath, wave[j], "/func/")
    if (dir.exists(datapath) == 1) {
      setwd(datapath)
      file1 <- paste0(sub[i], "_", wave[j], "_", "task-movieAM.nii.gz")
      file2 <- paste0(sub[i], "_", wave[j], "_", "task-movieAM.json")
      file3 <- paste0(sub[i], "_", wave[j], "_", "task-movieDM.nii.gz")
      file4 <- paste0(sub[i], "_", wave[j], "_", "task-movieDM.json")
      if (file.exists(file1) == 1) {
        file.remove(file1)
      }
      if (file.exists(file2) == 1) {
        file.remove(file2)
      }
      if (file.exists(file3) == 1) {
        file.remove(file3)
      }
      if (file.exists(file4) == 1) {
        file.remove(file4)
      }
    }
  }
}

#Part2 Move Pheno data into sub folder
rm(list=ls())
library(filesstrings)
#CKG/PEK
aimfolder <- "Z:/CCNP/devCCNP_Data/devCCNP_Data_Use_Application_ThomasYeo/CKG"
sub <- dir(aimfolder, full.names = F)
wave <- c("ses-01", "ses-02", "ses-03")
# WISC
sourcefolder <- "Z:/CCNP/devCCNP_Data/devCCNP_Data_Use_Application_ThomasYeo/WISC/"
setwd(sourcefolder)
for (i in 1:length(sub)) {
  for (j in 1:length(wave)) {
    partfile <- paste0(substr(sub[i],5,15), "_", wave[j], "_task-WISC_beh.tsv")
    if (file.exists(partfile) == 1) {
      topath <- paste0(aimfolder, sub[i], "/", wave[j], "/")
      if (dir.exists(topath) == 1) {
        finalpath <- paste0(topath, "beh/")
        if (dir.exists(finalpath) == 1) {
          dir.remove(finalpath)
        }
        dir.create(finalpath)
        file.move(partfile, finalpath)
      }
    }
  }
}
