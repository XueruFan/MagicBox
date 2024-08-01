# this script is used to arrange ABIDE Data Manual QC result with pheno
# Xue-Ru Fan 5 Oct 2023 @BNU

# 把初级质控后，需要对分割结果进行二级质控的被试挑出来
# 也就是把需要跑visualQC的被试的Freesuerfer数据挑出来

rm(list=ls())

library(openxlsx)

# define filefolder
# abideDir <- 'E:/研究课题/ABIDE' # wins
abideDir <- "/Volumes/Xueru/研究课题/ABIDE" # mac


# get qc result
abide_qc <- read.xlsx(file.path(abideDir, "ABIDE_T1qc/abide_qc_result.xlsx"))

# 筛选出需要再看分割情况的数据
tbd <- subset(abide_qc, Rate != "2" & Rate != "0" & Rate != "1")

################ abide 1
# tbd_abide1 <- subset(tbd, ABIDE == "1")


################ abide 2
tbd_abide2 <- subset(tbd, ABIDE == "2")
sub2 <- unique(tbd_abide2$SUB_ID) # 注意：有些被试有重复个run，这里只保留一次被试编码

sourcefolder <- file.path(abideDir,"Preprocessed/ABIDE_II/SubWise_tar")
aimfolder <- file.path(abideDir,"Preprocessed/ABIDE_II/forVisualQC/ABIDE2")

# 将这些被试的数据拷贝到新文件夹下
for (i in sub2) {
  setwd(sourcefolder)
  file <- paste0(i, ".tar.gz")
  if (file.exists(file)) {
    souce <- file.path(sourcefolder, file)
    aim <- file.path(aimfolder, file)
    file.copy(from = souce, to = aim)
  }
}

# 解压这些文件，同时删掉tar.gz文件
setwd(aimfolder)
SUB_file <- list.files(aimfolder)
for (s in SUB_file[2:562]) {
  untar(s) # 解压
  file.remove(s) #删去tar.gz
}

# 保存一份被试编号清单
wb <- createWorkbook() # 创建一个工作簿，
addWorksheet(wb, "Sheet1") # 创建一个工作表
writeData(wb, "Sheet1", SUB_file) # 将数据写入工作表
saveWorkbook(wb, file.path(abideDir, "ABIDE_T1qc/abide2_visualqc_list.xlsx"), overwrite = TRUE)
