# 此代码用来删除一下不想要的文件
# 目前是为了删掉备份在NAS上无用的ABIDE过程文件
# Xueru @BNU 2023年8月28日

rm(list=ls())

# 定义文件源
sourcefolder <- "E:/研究课题/ABIDE/Raw/ABIDE_II/"

# 获取子文件夹路径
sub <- dir(sourcefolder, full.names = F)

# 循环进入子文件夹删掉文件
for (i in 1:length(sub)) {
  partpath <- paste0(sourcefolder, sub[i], "/")
  
  setwd(partpath)
  subsub <- dir(partpath, full.names = F)
  
  # 删掉anat内不要的
  for (j in 1:length(subsub)) {
    datapath <- paste0(partpath, subsub[j], "/anat/")
    
    if (dir.exists(datapath) == 1) {
      setwd(datapath)
      
      # 笨办法一个一个删
      file1 <- "T1_crop.nii.gz"
      file2 <- "T1_crop_sanlm.nii.gz"
      file3 <- "T1_crop_sanlm_pre_mask.nii.gz"
      file4 <- "T1_ro.nii.gz"
      file5 <- paste0(datapath, "qc")
      
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
      if (dir.exists(file5) == 1) {
        unlink(file5, recursive = TRUE)
      }
    }
  }
}
