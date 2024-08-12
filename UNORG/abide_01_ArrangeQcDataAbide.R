# this script is used to arrange MRIqc data together to do manual qc
# Xue-Ru Fan 25 April 2023 @BNU

rm(list=ls())

# load packages
library(tools)

# define filefolder
worDir <- "E:/研究课题/ABIDE/MRIqc"

################################## Part 1 ##########################################################
# 移动所有的T1.html到单独文件夹下

qcSouDir <- file.path(worDir, "ABIDE_II_MRIQC")
qcAimDir <- file.path(worDir, "ABIDE2T1html") # 这里要手动改

# get names of all the subfile
setwd(qcSouDir)
siteName <- list.files()

for (s in siteName) {
  qcSiteDir <- file.path(qcSouDir, s)
  
  # 获取源文件夹内所有文件的列表
  file_list <- list.files(qcSiteDir)
  
  # 定义筛选字符，这里是筛选所有T1结构像qc后的图
  selected_files <- file_list[grep("T1w.html", file_list)]
  
  # 剪切文件到目标文件夹
  for (file in selected_files) {
    file.rename(file.path(qcSiteDir, file), file.path(qcAimDir, file))
  }
  
}


################################## Part 2 ##########################################################
# 加数据集前缀

files <- list.files(qcAimDir)

# 循环遍历每个文件，并修改文件名
for(file in files) {
  
  # 构建新的文件名
  new_name <- paste0("2_", file) #加上数据集是abide1还是2的前缀
  
  # 修改文件名
  file.rename(paste0(qcAimDir, "/", file), paste0(qcAimDir, "/", new_name))
  
}


################################## Part 3 ##########################################################
# 把文件放在一起后打乱顺序

# 首先把两个数据集的文件拷到一个新文件夹下ABIDE1&2T1htmlRand

filefolder <- file.path(worDir, "ABIDE1&2T1htmlRand")

setwd(filefolder)

# 获取目录下所有的文件名
files <- list.files()

# 随机打乱文件名顺序
files <- sample(files)


# 循环遍历每个文件，并修改文件名
for (i in seq_along(files)) {
  
  # 补全为4位
  i_pad <- sprintf("%04d", i)
  
  # 构建新的文件名
  new_name <- paste0(i_pad, "_", files[i])
  
  # 修改文件名
  file.rename(file.path(filefolder, files[i]), file.path(filefolder, new_name))
  
}

# 生成一个文件名csv后续存质控结果用
files <- list.files()
write.table(files, file.path(worDir, "abide_qclist.csv"), sep = ",", col.names = FALSE,
            row.names = FALSE)
