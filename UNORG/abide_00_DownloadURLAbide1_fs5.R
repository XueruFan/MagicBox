# this script is used to download preprocessed ABIDE I data from Amazon S3
# (http://preprocessed-connectomes-project.org/abide/download.html)
# Xue-Ru Fan 24 April 2023 @BNU

rm(list=ls())

# define filefolder
projectDir <- 'D:/ABIDE'
infoDir <- file.path(projectDir, "ABIDE_info")
workDir <- file.path(projectDir, "Preprocessed")
saveDir <- file.path(workDir, "ABIDE_I")
# define file
root <- "https://s3.amazonaws.com/fcp-indi/data/Projects/ABIDE_Initiative/Outputs/freesurfer/5.1/"
Phenotypic <- read.csv(file.path(infoDir, "Phenotypic_V1_0b_preprocessed1.csv"))
SubID <- Phenotypic$SUB_ID
FileIdentifier <- Phenotypic$FILE_ID
SubDirectory <- "/stats" # in which filefolder
OutputFile <- c("aseg.stats", "lh.aparc.stats", "rh.aparc.stats") # file to download
# OutputFile <- c("wmparc.stats")
NoFileList <- data.frame() # to save SUB_ID without files

# download from http
for (f in 1:length(FileIdentifier)) {
  setwd(saveDir)
  if (FileIdentifier[f] == "no_filename") {
    NoFileList = rbind(NoFileList, SubID[f])
  } else {
    dir.create(as.character(SubID[f]))
    setwd(as.character(SubID[f]))
    for (o in 1:length(OutputFile)) {
      rootURL <- paste0(root, FileIdentifier[f], SubDirectory, "/", OutputFile[o])
      download.file(url = rootURL, destfile = OutputFile[o], mode = "wb", quiet = T)
    }
  }
}
setwd(workDir)
colnames(NoFileList) <- "SUB_ID"
write.csv2(NoFileList, "NoFileList.csv", row.names = F) # save the list of SUB_ID without file