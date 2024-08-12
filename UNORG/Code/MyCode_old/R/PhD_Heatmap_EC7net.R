rm(list=ls())
library(R.matlab)
library(pheatmap)
library(RColorBrewer)

datapath <- "/Volumes/Xueru/group/"
setwd(datapath)
fn  <- "400P_T1_R1_LR_PCA_EC_7net.mat"
sn <- "/Volumes/Xueru/visualization/EC/"
######
X <- abs(readMat(fn)[["neg.thr"]])
pheatmap(X, 
         color = colorRampPalette(c("#ffebcd", "blue"))(10),
         cellwidth = 50, cellheight = 50,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "Inhibitory Effective Connectivity of 7 Networks",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(sn, "EC_neg_T1_R1_rDCM_7net.png"), width = 5.6, height = 5)
##### 导出边列表
dimnames(X) <- list(c(1:7))
colnames(X) <- c(1:7)
link = data.frame(from = rep(rownames(X), times = ncol(X)), #起始对象
                  to = rep(colnames(X), each = nrow(X)), #终止对象
                  value = as.vector(X),#起始对象与终止对象之间的相互作用强度
                  stringsAsFactors = FALSE);
setwd(paste0(datapath, "csv/"))
file <- "400P_T1_R1_LR_PCA_EC_7net_neg_edge.csv"
write.csv (link, file = file)

######
X <- abs(readMat(fn)[["pos.thr"]])
pheatmap(X, 
         color = colorRampPalette(c("#ffebcd", "red"))(10),
         cellwidth = 50, cellheight = 50,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "Excitatory Effective Connectivity of 7 Networks",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(sn, "EC_pos_T1_R1_rDCM_7net.png"), width = 5.6, height = 5)
##### 导出边列表
dimnames(X) <- list(c(1:7))
colnames(X) <- c(1:7)
link = data.frame(from = rep(rownames(X), times = ncol(X)), #起始对象
                  to = rep(colnames(X), each = nrow(X)), #终止对象
                  value = as.vector(X),#起始对象与终止对象之间的相互作用强度
                  stringsAsFactors = FALSE);
setwd(paste0(datapath, "csv/"))
file <- "400P_T1_R1_LR_PCA_EC_7net_pos_edge.csv"
write.csv (link, file = file)
