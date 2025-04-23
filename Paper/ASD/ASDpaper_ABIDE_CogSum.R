rm(list=ls())
packages <- c("tidyverse", "mgcv", "stringr", "reshape2", "magrittr", "ggplot2", "dplyr", "readxl",
              "stringr", "ggseg", "patchwork", "effectsize", "pwr", "cowplot",
              "readr", "ggridges", "tidyr", "stats", "gamlss", "openxlsx")
# sapply(packages,instAll.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

# abideDir <- '/Volumes/Xueru/PhDproject/ABIDE' # mac
abideDir <- 'E:/PhDproject/ABIDE' # winds
phenoDir <- file.path(abideDir, "Preprocessed")
clustDir <- file.path(abideDir, "Analysis/Cluster/Spect513")
statiDir <- file.path(abideDir, "Analysis/Statistic/Spect513")
resDate <- "240315"
newDate <- "240610"

# 认知行为
pheno <- read.csv(file.path(phenoDir, paste0("abide_A_all_", resDate, ".csv")))
colnames(pheno)[which(names(pheno) == "Participant")] <- "participant"
# 聚类信息、脑形态测量百分位数
name <- paste0("Cluster_", newDate, ".csv")
cluster <- read.csv(file.path(clustDir, name))
start <- which(names(cluster) == "GMV")
colnames(cluster)[start:ncol(cluster)] <- paste0(colnames(cluster)[start:ncol(cluster)], "_centile")
All <- merge(cluster, pheno, by = "participant", All.x = TRUE)

All$Site <- All$SITE_ID

# 修改各自站点名字的缩写
All$Site <- gsub("ABIDEII-NYU_1", "NYU", All$Site)
All$Site <- gsub("ABIDEII-NYU_2", "NYU", All$Site)
All$Site <- gsub("ABIDEII-KKI_1", "KKI", All$Site)
All$Site <- gsub("ABIDEII-SDSU_1", "SDSU", All$Site)
All$Site <- gsub("ABIDEII-UCLA_1", "UCLA", All$Site)
All$Site <- gsub("UCLA_1", "UCLA", All$Site)
All$Site <- gsub("UCLA_2", "UCLA", All$Site)
All$Site <- gsub("ABIDEII-GU_1", "GU", All$Site)
All$Site <- gsub("ABIDEII-UCD_1", "UCD", All$Site)
All$Site <- gsub("ABIDEII-EMC_1", "EMC", All$Site)
All$Site <- gsub("TRINITY", "TCD", All$Site)
All$Site <- gsub("ABIDEII-TCD_1", "TCD", All$Site)
All$Site <- gsub("ABIDEII-USM_1", "USM", All$Site)
All$Site <- gsub("ABIDEII-IU_1", "IU", All$Site)
All$Site <- gsub("ABIDEII-U_MIA_1", "UMIA", All$Site)
All$Site <- gsub("ABIDEII-ETH_1", "ETH", All$Site)
All$Site <- gsub("UM_1", "UM", All$Site)
All$Site <- gsub("UM_2", "UM", All$Site)
All$Site <- gsub("ABIDEII-OHSU_1", "OHSU", All$Site)
All$Site <- gsub("STANFORD", "SU1", All$Site)
All$Site <- gsub("ABIDEII-SU_2", "SU2", All$Site)
All$Site <- gsub("LEUVEN_2", "KUL", All$Site)
All$Site <- gsub("CALTECH", "CALT", All$Site)


# 添加上机型
All <- All %>%
  mutate(
    Scan = case_when(
      SITE_ID == 'ABIDEII-NYU_1' ~ 'S Allegra',
      SITE_ID == 'ABIDEII-NYU_2' ~ 'S Allegra',
      SITE_ID == 'NYU' ~ 'S Allegra',
      SITE_ID == 'ABIDEII-KKI_1' ~ 'P Achieva',
      SITE_ID == 'ABIDEII-SDSU_1' ~ 'G MR 750',
      SITE_ID == 'ABIDEII-UCLA_1' ~ 'S TrioTim',
      SITE_ID == 'UCLA_1' ~ 'S TrioTim',
      SITE_ID == 'UCLA_2' ~ 'S TrioTim',
      SITE_ID == 'ABIDEII-GU_1' ~ 'S TrioTim',
      SITE_ID == 'ABIDEII-UCD_1' ~ 'S TrioTim',
      SITE_ID == 'ABIDEII-EMC_1' ~ 'G MR 750',
      SITE_ID == 'TRINITY' ~ 'P Achieva',
      SITE_ID == 'ABIDEII-USM_1' ~ 'S TrioTim',
      SITE_ID == 'ABIDEII-IU_1' ~ 'S TrioTim',
      SITE_ID == 'ABIDEII-U_MIA_1' ~ 'G Healthcare',
      SITE_ID == 'ABIDEII-ETH_1' ~ 'P Achieva',
      SITE_ID == 'ABIDEII-TCD_1' ~ 'P Achieva',
      SITE_ID == 'UM_1' ~ 'G Signa',
      SITE_ID == 'UM_2' ~ 'G Signa',
      SITE_ID == 'ABIDEII-OHSU_1' ~ 'S TrioTim',
      SITE_ID == 'STANFORD' ~ 'G Signa',
      SITE_ID == 'ABIDEII-SU_2' ~ 'G Signa',
      SITE_ID == 'LEUVEN_2' ~ 'P Intera',
      SITE_ID == 'CALTECH' ~ 'S TrioTim',
      SITE_ID == 'PITT' ~ 'S Allegra',
      SITE_ID == 'OLIN' ~ 'S Allegra',
      SITE_ID == 'OHSU' ~ 'S TrioTim',
      SITE_ID == 'SDSU' ~ 'G MR 750',
      SITE_ID == 'USM' ~ 'S TrioTim',
      SITE_ID == 'YALE' ~ 'S TrioTim',
      SITE_ID == 'KKI' ~ 'P Achieva',
      TRUE ~ '其他' # 默认值
    ),
    Manu = case_when(
      SITE_ID == 'ABIDEII-NYU_1' ~ 'S',
      SITE_ID == 'ABIDEII-NYU_2' ~ 'S',
      SITE_ID == 'NYU' ~ 'S',
      SITE_ID == 'ABIDEII-KKI_1' ~ 'P',
      SITE_ID == 'ABIDEII-SDSU_1' ~ 'G',
      SITE_ID == 'ABIDEII-UCLA_1' ~ 'S',
      SITE_ID == 'UCLA_1' ~ 'S',
      SITE_ID == 'UCLA_2' ~ 'S',
      SITE_ID == 'ABIDEII-GU_1' ~ 'S',
      SITE_ID == 'ABIDEII-UCD_1' ~ 'S',
      SITE_ID == 'ABIDEII-EMC_1' ~ 'G',
      SITE_ID == 'TRINITY' ~ 'P',
      SITE_ID == 'ABIDEII-USM_1' ~ 'S',
      SITE_ID == 'ABIDEII-IU_1' ~ 'S',
      SITE_ID == 'ABIDEII-U_MIA_1' ~ 'G',
      SITE_ID == 'ABIDEII-ETH_1' ~ 'P',
      SITE_ID == 'ABIDEII-TCD_1' ~ 'P',
      SITE_ID == 'UM_1' ~ 'G',
      SITE_ID == 'UM_2' ~ 'G',
      SITE_ID == 'ABIDEII-OHSU_1' ~ 'S',
      SITE_ID == 'STANFORD' ~ 'G',
      SITE_ID == 'ABIDEII-SU_2' ~ 'G',
      SITE_ID == 'LEUVEN_2' ~ 'P',
      SITE_ID == 'CALTECH' ~ 'S',
      SITE_ID == 'PITT' ~ 'S',
      SITE_ID == 'OLIN' ~ 'S',
      SITE_ID == 'OHSU' ~ 'S',
      SITE_ID == 'SDSU' ~ 'G',
      SITE_ID == 'USM' ~ 'S',
      SITE_ID == 'YALE' ~ 'S',
      SITE_ID == 'KKI' ~ 'P',
      TRUE ~ '其他' # 默认值
    )
  )

All[which(All$PDD_DSM_IV_TR == "1"), "variable"] <- "Autism"
All[which(All$PDD_DSM_IV_TR == "2"), "variable"] <- "Aspergers"
All[which(All$PDD_DSM_IV_TR == "3"), "variable"] <- "PDD-NOS"
All$PDD_DSM_IV_TR[All$PDD_DSM_IV_TR < 0] <- NA


names_cog <- c("AGE_AT_SCAN", "FIQ", "VIQ", "PIQ", "ADOS_2_SOCAFFECT" , "ADOS_2_RRB", "ADOS_2_TOTAL", "ADI_R_SOCIAL_TOTAL_A",
               "ADI_R_RRB_TOTAL_C", "SRS_TOTAL_RAW", "SRS_COGNITION_RAW", "SRS_AWARENESS_RAW",
               "SRS_COMMUNICATION_RAW", "SRS_MOTIVATION_RAW", "SRS_MANNERISMS_RAW", "Site",
               "Scan", "Manu", "PDD_DSM_IV_TR")

names_col <- c("clusterID", names(cluster)[3:ncol(cluster)], names_cog)

temp <- All[, names_col]
temp[temp < 0] <- NA

colnames(temp) <- gsub("_centile", "", colnames(temp))

en_labels <- c("TCV", "WMV", "GMV", "sGMV", "Ventricles",
               "meanCT2", "totalSA2", "superiorfrontal", "rostralmiddlefrontal", "caudalmiddlefrontal",
                   "parsopercularis", "parstriangularis", "parsorbitalis", "frontalpole",
                   "lateralorbitofrontal", "medialorbitofrontal",
                   "rostralanteriorcingulate", "caudalanteriorcingulate",
                   "precentral", "paracentral", "postcentral",
                   "supramarginal", "posteriorcingulate", "isthmuscingulate",
                   "precuneus", "superiorparietal", "inferiorparietal",
                   "transversetemporal", "bankssts",
                   "superiortemporal", "middletemporal", "inferiortemporal",
                   "fusiform", "parahippocampal", "entorhinal", "temporalpole",
                   "lateraloccipital", "lingual", "pericalcarine", "cuneus",
                   "insula")


new <- cbind(temp[,1], temp[, en_labels], temp[, 43:61])


cn_labels <- c("clusterID", "TCV", "WMV",
                   "GMV", "sGMV",
                   "CSF", "mCT",
                   "tSA", "Superior frontal", "Rostral middle frontal", "Caudal middle frontal",
                   "Pars opercularis", "Pars triangularis", "Pars orbitalis", "Frontal pole",
                   "Lateral orbital frontal", "Medial orbital frontal",
                   "Rostral anterior cingulate", "Caudal anterior cingulate",
                   "Precentral", "Paracentral", "Postcentral",
                   "Supramarginal", "Posterior cingulate", "Isthmus cingulate",
                   "Precuneus", "Superior parietal", "Inferior parietal",
                   "Transverse temporal", "Banks superior temporal",
                   "Superior temporal", "Middle temporal", "Inferior temporal",
                   "Fusiform", "Parahippocampal", "Entorhinal", "Temporal pole",
                   "Lateral occipital", "Lingual", "Pericalcarine", "Cuneus",
                   "Insula")

colnames(new)[1:42] <- cn_labels

L <- subset(new, clusterID == "1")
L <- L[, -1]
H <- subset(new, clusterID == "2")
H <- H[, -1]

write.xlsx(L, file.path(statiDir, "All4plot_L.xlsx"), rowNames = F)
write.xlsx(H, file.path(statiDir, "All4plot_H.xlsx"), rowNames = F)
