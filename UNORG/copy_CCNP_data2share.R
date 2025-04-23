# This script is used to copy the files to share
# Xue-Ru Fan  May-11-2023 @BNU

rm(list=ls())

sourcefolder <- "F:/MRI/PEK/"
setwd(sourcefolder)
sub <- dir(sourcefolder, full.names = F)

aimfolder <- "D:/devCCNPPEK/DWI/"
# for (i in 1:length(sub)) {
#   dir.create(sub[i])
# }


# copy DTI
for (i in 1:length(sub)) {
  partpath <- paste0(sourcefolder, sub[i], "/")
  dir.create(paste0(aimfolder, sub[i]))
  setwd(partpath)
  wave <- dir(partpath, full.names = F)
  for (j in 1:length(wave)) {
    
    dir.create(paste0(aimfolder, sub[i], "/", wave[j]))
    datapath <- paste0(partpath, wave[j], "/dwi/")
    if (dir.exists(datapath) == 1) {
      setwd(datapath)
      file1 <- paste0(sub[i], "_", wave[j], "_", "dwi.bval")
      file2 <- paste0(sub[i], "_", wave[j], "_", "dwi.bvec")
      file3 <- paste0(sub[i], "_", wave[j], "_", "dwi.json")
      file4 <- paste0(sub[i], "_", wave[j], "_", "dwi.nii.gz")
      if (file.exists(file1) == 1) {
        souce <- paste0(datapath, file1)
        file.copy(from = souce, to = paste0(aimfolder, sub[i], "/", wave[j], "/", file1))
      }
      if (file.exists(file2)) {
        souce <- paste0(datapath, file2)
        file.copy(from = souce, to = paste0(aimfolder, sub[i], "/", wave[j], "/", file2))
      }
      if (file.exists(file3)) {
        souce <- paste0(datapath, file3)
        file.copy(from = souce, to = paste0(aimfolder, sub[i], "/", wave[j], "/", file3))
      }
      if (file.exists(file4)) {
        souce <- paste0(datapath, file4)
        file.copy(from = souce, to = paste0(aimfolder, sub[i], "/", wave[j], "/", file4))
      }
    }
  }
}

# NS-fMRI
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
        souce <- paste0(datapath, file1)
        file.copy(from = souce, to = paste0(aimfolder, sub[i], "/", file1))
      }
      if (file.exists(file2)) {
        souce <- paste0(datapath, file2)
        file.copy(from = souce, to = paste0(aimfolder, sub[i], "/", file2))
      }
      if (file.exists(file3)) {
        souce <- paste0(datapath, file3)
        file.copy(from = souce, to = paste0(aimfolder, sub[i], "/", file3))
      }
      if (file.exists(file4)) {
        souce <- paste0(datapath, file4)
        file.copy(from = souce, to = paste0(aimfolder, sub[i], "/", file4))
      }
    }
  }
}

#T1
for (i in 1:length(sub)) {
  partpath <- paste0(sourcefolder, sub[i], "/")
  setwd(partpath)
  wave <- dir(partpath, full.names = F)
  for (j in 1:length(wave)) {
    datapath <- paste0(partpath, wave[j], "/anat/")
    if (dir.exists(datapath) == 1) {
      setwd(datapath)
      file1 <- paste0(sub[i], "_", wave[j], "_", "T1w.nii.gz")
      file2 <- paste0(sub[i], "_", wave[j], "_", "T1w.json")
      if (file.exists(file1)) {
        souce <- paste0(datapath, file1)
        file.copy(from = souce, to = paste0(aimfolder, sub[i], "/", file1))
      }
      if (file.exists(file2)) {
        souce <- paste0(datapath, file2)
        file.copy(from = souce, to = paste0(aimfolder, sub[i], "/", file2))
      }
    }
  }
}
