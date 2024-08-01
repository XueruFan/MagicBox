rm(list=ls())
library(R.matlab)
library(pheatmap)
library(RColorBrewer)

# set these parameters
p <- 400
datapath <- "/Volumes/Xueru/HCP_339/Results/Group/EC/"
setwd(datapath)
fn  <- paste0(p, "P_EC_count.mat")
pn <- paste0(datapath, "PIC/")

##### pos_neg #####
C <- abs(readMat(fn)[["pos.neg"]])
cfile <- paste0(p, "P_EC_count.png")
pheatmap(C, 
         color = colorRampPalette(c("white", "#008b8b"))(10),
         # set the max values
         breaks = seq(from = 0, to = 1, by = 0.1),
         border_color = NA, cellwidth = 1, cellheight = 1,
         legend = T,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "How many subs have the same EC values in 4 times",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(pn, cfile), width = 6.5, height = 6)
##### pos #####
P <- abs(readMat(fn)[["pos"]])
pfile <- paste0(p, "P_EC_count_pos.png")
pheatmap(P, 
         color = colorRampPalette(c("white", "red"))(10),
         # set the max values
         breaks = seq(from = 0, to = 1, by = 0.1),
         border_color = NA, cellwidth = 1, cellheight = 1,
         legend = T,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "How many subs have all pos EC values in 4 times",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(pn, pfile), width = 6.5, height = 6)
##### neg #####
N <- abs(readMat(fn)[["neg"]])
nfile <- paste0(p, "P_EC_count_neg.png")
pheatmap(N, 
         color = colorRampPalette(c("white", "blue"))(10),
         # set the max values
         breaks = seq(from = 0, to = 1, by = 0.1),
         border_color = NA, cellwidth = 1, cellheight = 1,
         legend = T,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "How many subs have all neg EC values in 4 times",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(pn, nfile), width = 6.5, height = 6)