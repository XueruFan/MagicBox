# this script is used to arrange preprocessed ABIDE data for centile calculation
# please note, this works for freesurfer5 results
# Xue-Ru Fan 24 April 2023 @BNU

############################ FOR ABIDE I ################################################

rm(list=ls())

# define filefolder
abideDir <- 'D:/ABIDE'
lifeSpanDir <- "D:/LBCC/lbcc"
dataDir <- file.path(abideDir, "Preprocessed/ABIDE_I")

# get sub_id
SUB_ID <- list.files(dataDir)

############################ get data from raw freesurfer results ##################################

################# make an empty dataframe to save global data
abide_global <- data.frame(matrix(ncol = 12, nrow = 0))
colnames(abide_global) <- c("Participant", "lhCortexVol", "rhCortexVol", "CortexVol",
                            "lhCorticalWhiteMatterVol", "rhCorticalWhiteMatterVol",
                            "CorticalWhiteMatterVol", "SubCortGrayVol", "TotalGrayVol",
                            "SupraTentorialVol", "ICV", "CSF")

for (s in 1:length(SUB_ID)) {
  setwd(file.path(dataDir, SUB_ID[s]))
  ## sub_id
  abide_global[s, 1] <- SUB_ID[s] 
  ## global
  note <- data.frame(readLines("aseg.stats"))
  global <- data.frame(do.call('rbind', strsplit(as.character(note[14:23,]), ", ")))
  note <- data.frame(read.table("aseg.stats"))
  # all metrix without CSF
  names <- names(abide_global)[2:11]
  for (n in names) {
    where <- which(apply(global, 1, function(x) any(grep(paste0("\\b", n, "\\b"), x, value = F))))
    com_str <- paste0("abide_global[s, '", n, "'] <- global[where, 'X4']")
    eval(parse(text = com_str))
  }
  # CSF
  where <- which(apply(note, 1, function(x) any(grepl("CSF", x))))
  abide_global[s, "CSF"] <- note[where, "V4"]
}
write.csv(abide_global, file.path(abideDir, "Preprocessed/abide_global.csv"), row.names = F)


################# make an empty dataframe to save regional data
abide_regional <- data.frame()

for (s in 1:length(SUB_ID)) {
  setwd(file.path(dataDir, SUB_ID[s]))
  ## sub_id
  abide_regional[s, 1] <- SUB_ID[s] 
  ## regional
  # three metrix： ventricles, CT and SA
  # lh
  lh <- data.frame(readLines("lh.aparc.stats"))
  lh_dk <- data.frame(read.table("lh.aparc.stats"))
  whereV <- which(apply(lh, 1, function(x) any(grep("NumVert, Number of Vertices", x, value = F))))
  whereW <- which(apply(lh, 1, function(x) any(grep("WhiteSurfArea, White Surface Total Area", x,
                                                    value = F))))
  whereM <- which(apply(lh, 1, function(x) any(grep("MeanThickness, Mean Thickness", x, value = F))))
  whereL <- c(whereV, whereW, whereM)
  regional_lh <- data.frame(do.call('rbind', strsplit(as.character(lh[whereL, ]), ", ")))
  # rh
  rh <- data.frame(readLines("rh.aparc.stats"))
  rh_dk <- data.frame(read.table("rh.aparc.stats"))
  whereV <- which(apply(rh, 1, function(x) any(grep("NumVert, Number of Vertices", x, value = F))))
  whereW <- which(apply(rh, 1, function(x) any(grep("WhiteSurfArea, White Surface Total Area", x,
                                                    value = F))))
  whereM <- which(apply(rh, 1, function(x) any(grep("MeanThickness, Mean Thickness", x, value = F))))
  whereR <- c(whereV, whereW, whereM)
  regional_rh <- data.frame(do.call('rbind', strsplit(as.character(rh[whereR, ]), ", ")))
  
  names <-  c("NumVert", "WhiteSurfArea", "MeanThickness")
  
  for (n in names) {
    # lh
    where <- which(apply(regional_lh, 1, function(x) any(grep(n, x, value = F))))
    com_str <- paste0("abide_regional[s, 'lh", n, "'] <- regional_lh[where, 'X4']")
    eval(parse(text = com_str))
    #rh
    where <- which(apply(regional_rh, 1, function(x) any(grep(n, x, value = F))))
    com_str <- paste0("abide_regional[s, 'rh", n, "'] <- regional_rh[where, 'X4']")
    eval(parse(text = com_str))
  }
  
  
  for (d in lh_dk$V1) {
    # lh
    where <- which(apply(lh_dk, 1, function(x) any(grep(paste0("\\b", d, "\\b"), x, value = F))))
    if (length(where) != 0) {
      com_str <- paste0("abide_regional[s, 'lh", d, "'] <- lh_dk[where, 'V4']")
      eval(parse(text = com_str))
    } 
    #rh
    where <- which(apply(rh_dk, 1, function(x) any(grep(paste0("\\b", d, "\\b"), x, value = F))))
    if (length(where) != 0) {
      com_str <- paste0("abide_regional[s, 'rh", d, "'] <- rh_dk[where, 'V4']")
      eval(parse(text = com_str))
    }
  }
}
colnames(abide_regional)[1] <- "Participant"
write.csv(abide_regional, file.path(abideDir, "Preprocessed/abide_regional.csv"), row.names = F)



############################ arrange data for calculate centiles ###################################

# define filefolder
dataDir <- file.path(abideDir, "Preprocessed")


# load results
setwd(dataDir)
abide_global <- read.csv("abide_global.csv")
abide_regional <- read.csv("abide_regional.csv")
abide <- merge(abide_global, abide_regional, by = "Participant")

# load pheno
setwd(file.path(abideDir, "ABIDE_info"))
abide_pheno <- read.csv("Phenotypic_V1_0b.csv")
colnames(abide_pheno)[2] <- "Participant"

# combine
abide_all <- merge(abide_pheno, abide, by = "Participant")

# arrange partA: Basic
abide_analysis <- abide_all[1]
abide_analysis$Age <- abide_all$AGE_AT_SCAN
abide_analysis$age_days <- as.numeric(abide_analysis$Age * 365.245)
abide_analysis$age_months <- as.numeric(round(abide_analysis$age_days / 30.4375))
abide_analysis$age_days <- abide_analysis$age_days + 280
abide_analysis$sex <- abide_all$SEX
abide_analysis[which(abide_analysis$sex == 2), 'sex'] = "Female"
abide_analysis[which(abide_analysis$sex == 1), 'sex'] = "Male"
abide_analysis$study <- "XRF230425"
abide_analysis$fs_version <- NA
abide_analysis$country <- NA
abide_analysis$run <- 1
abide_analysis$session <- 1
abide_analysis$dx <- abide_all$DX_GROUP
abide_analysis[which(abide_analysis$dx == 2), 'dx'] = "CN"
abide_analysis[which(abide_analysis$dx == 1), 'dx'] = "ASD"
# arrange partB: Global
abide_analysis$GMV <- abide_all$TotalGrayVol
abide_analysis$WMV <- abide_all$CorticalWhiteMatterVol # Total cortical white matter volume
abide_analysis$sGMV <- abide_all$SubCortGrayVol
abide_analysis$TCV <- abide_all$ICV # Intracranial Volume
abide_analysis$CSF <- abide_all$CSF
abide_analysis$meanCT2 <- (as.numeric(abide_all$lhMeanThickness) * as.numeric(abide_all$lhNumVert) +
                             as.numeric(abide_all$rhMeanThickness) * as.numeric(abide_all$rhNumVert)
                           ) / (as.numeric(abide_all$lhNumVert) + as.numeric(abide_all$rhNumVert))
abide_analysis$totalSA2 <- as.numeric(abide_all$lhWhiteSurfArea) + as.numeric(abide_all$rhWhiteSurfArea)
# arrange partC: 34 parcels
for (p in 1:nrow(lh_dk)) {
  com_str <- paste0("abide_analysis$", lh_dk[p, 1], " <- as.numeric(abide_all$lh", lh_dk[p, 1],
                    ") + as.numeric(abide_all$rh", lh_dk[p, 1], ")")
  eval(parse(text = com_str))
}
write.csv(abide_analysis, file.path(dataDir, "abide_analysis.csv"), row.names = F)
