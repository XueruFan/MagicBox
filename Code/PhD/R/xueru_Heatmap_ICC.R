rm(list=ls())
library(R.matlab)
library(pheatmap)
library(RColorBrewer)

# 下列参数注意查看调整
p <- 400
threshold <- "z"

datapath <- "/Volumes/Xueru/Group_level/"
setwd(datapath)
fn  <- paste0(p, "P_PCA_", threshold, "EC_ICC.mat")
pfile <- paste0(p, "P_PCA_", threshold, "EC_ICC.png")
pn <- paste0(datapath, "PIC/")
#####
X <- readMat(fn)[["icc"]]
pheatmap(X, 
         color = colorRampPalette(c("#660033", "#33334C", "#4C4C7F", "#7F7FCC", 
                                    "#00FF02", "#11B00F", "#FFFF02", "#FF9901",
                                    "#FF6901", "#FF0000"))(10),
         breaks = seq(from = 0, to = 1, by = 0.1), border_color = NA,
         #cellwidth = 1, cellheight = 1,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "Test-retest Reliability of Effective Connectivity",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(pn, pfile), width = 6.1, height = 5.7)
