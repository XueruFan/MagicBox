rm(list=ls())
packages <- c("tidyverse", "mgcv", "stringr", "reshape2", "magrittr", "ggplot2", "dplyr", "readxl",
              "stringr", "ggseg", "patchwork", "effectsize", "pwr", "cowplot",
              "readr", "ggridges", "tidyr", "stats", "gamlss", "openxlsx")
# sapply(packages,instAll.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

cabicDir <- 'E:/PhDproject/CABIC'
resuDir <- file.path(cabicDir, "result/pred/513/Diff")
resDate <- "240928"


# 认知行为
pheno <- read_excel(file.path(cabicDir, "CABIC_Subjects_info.xls"))
colnames(pheno)[3] <- "participant"
# 聚类信息、脑形态测量百分位数
name <- paste0("cabic_cluster_predictions_513_", resDate, ".csv")
cluster <- read.csv(file.path(cabicDir, "result/pred/513", name))

All <- merge(cluster, pheno, by = "participant")
All <- subset(All, SEX == "M" & GROUP == "ASD")
All <- subset(All, AGE >= 5 & AGE < 13)

All[which(All$predicted_cluster == "1"), 'clusterID'] = "L"
All[which(All$predicted_cluster == "2"), 'clusterID'] = "H"
All$clusterID <- factor(All$clusterID)


names_cog <- c("AGE", "SITE", "FIQ", "ADOS_SA",	"ADOS_RRB",	"ADOS_TOTAL", 
               "ADIR_SOCI", "ADIR_COMM", "ADIR_RRB",
               "SRS_SA", "SRS_SCOG", "SRS_SCOM", "SRS_SM", "SRS_AM")

names_col <- c("clusterID", names(cluster)[3:ncol(cluster)], names_cog)

temp <- All[, names_col]
temp[temp < 0] <- NA

# colnames(temp) <- gsub("_centile", "", colnames(temp))
# 
# en_labels <- c("TCV", "WMV", "GMV", "sGMV", "Ventricles",
#                "meanCT2", "totalSA2", "superiorfrontal", "rostralmiddlefrontal", "caudalmiddlefrontal",
#                    "parsopercularis", "parstriangularis", "parsorbitalis", "frontalpole",
#                    "lateralorbitofrontal", "medialorbitofrontal",
#                    "rostralanteriorcingulate", "caudalanteriorcingulate",
#                    "precentral", "paracentral", "postcentral",
#                    "supramarginal", "posteriorcingulate", "isthmuscingulate",
#                    "precuneus", "superiorparietal", "inferiorparietal",
#                    "transversetemporal", "bankssts",
#                    "superiortemporal", "middletemporal", "inferiortemporal",
#                    "fusiform", "parahippocampal", "entorhinal", "temporalpole",
#                    "lateraloccipital", "lingual", "pericalcarine", "cuneus",
#                    "insula")
# 
# 
# new <- cbind(temp[,1], temp[, en_labels], temp[, 43:61])
# 
# 
# cn_labels <- c("clusterID", "TCV", "WMV",
#                    "GMV", "sGMV",
#                    "CSF", "mCT",
#                    "tSA", "Superior frontal", "Rostral middle frontal", "Caudal middle frontal",
#                    "Pars opercularis", "Pars triangularis", "Pars orbitalis", "Frontal pole",
#                    "Lateral orbital frontal", "Medial orbital frontal",
#                    "Rostral anterior cingulate", "Caudal anterior cingulate",
#                    "Precentral", "Paracentral", "Postcentral",
#                    "Supramarginal", "Posterior cingulate", "Isthmus cingulate",
#                    "Precuneus", "Superior parietal", "Inferior parietal",
#                    "Transverse temporal", "Banks superior temporal",
#                    "Superior temporal", "Middle temporal", "Inferior temporal",
#                    "Fusiform", "Parahippocampal", "Entorhinal", "Temporal pole",
#                    "Lateral occipital", "Lingual", "Pericalcarine", "Cuneus",
#                    "Insula")
# 
# colnames(new)[1:42] <- cn_labels

L <- subset(temp, clusterID == "L")
L <- L[, -1]
H <- subset(temp, clusterID == "H")
H <- H[, -1]

write.xlsx(L, file.path(resuDir, "All4plot_L.xlsx"), rowNames = F)
write.xlsx(H, file.path(resuDir, "All4plot_H.xlsx"), rowNames = F)
