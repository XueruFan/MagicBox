rm(list=ls())

packages <- c("openxlsx", "dplyr")
# sapply(packages,install.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

shap <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/Spect513/shap_feature_importance.csv")

en_labels <- c("superiorfrontal", "rostralmiddlefrontal", "caudalmiddlefrontal",
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

cn_labels <- c("Superior frontal", "Rostral middle frontal", "Caudal middle frontal",
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

Labels <- data.frame(en_labels, cn_labels)
colnames(Labels)[1] <- "Feature"

shap <- merge(shap, Labels, by = "Feature")

shap <- shap[, c(3, 2)]

shap <- shap %>% arrange(desc(MeanSHAP))

# 使用 sprintf 格式化数值，保留两位小数
shap[, 2] <- sprintf("%.2f", as.numeric(unlist(shap[, 2])))

#################

colnames(shap) <- c("Region", "SHAP value")

shap$latex <- paste0(shap$Region, " & ", shap$`SHAP value`, " \\\\")
write.csv(shap, "E:/Documents/Work/文章投稿/ASD/制表/TableS2.csv", row.names = F)
