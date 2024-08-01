rm(list=ls())
library(R.matlab)
library(pheatmap)
library(RColorBrewer)

# set these parameters
p <- 400
datapath <- "/Volumes/Xueru/HCP_339/Results/Group/EC/"
setwd(datapath)
fn  <- paste0(p, "P_zEC_group.mat")
pn <- paste0(datapath, "PIC/")

##### pos #####
M <- abs(readMat(fn)[["mean.zEC.pos.uw"]])
S <- abs(readMat(fn)[["std.zEC.pos.uw"]])
mfile <- paste0(p, "P_mean_zEC_pos_uw.png")
sfile <- paste0(p, "P_std_zEC_pos_uw.png")
##### mean
pheatmap(M, 
         color = colorRampPalette(c("white", "#dc143c"))(10),
         # set the max values
         breaks = seq(from = 0, to = 1, by = 0.1),
         border_color = NA, cellwidth = 1, cellheight = 1,
         legend = T,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "Mean of Excitatory Effective Connectivity",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(pn, mfile), width = 6.5, height = 6)
##### std
pheatmap(S, 
         color = colorRampPalette(c("white", "#dc143c"))(10),
         # set the max values
         breaks = seq(from = 0, to = 0.5, by = 0.05),
         border_color = NA, cellwidth = 1, cellheight = 1,
         legend = T,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "Std of Excitatory Effective Connectivity",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(pn, sfile), width = 6.5, height = 6)

##### neg #####
M <- abs(readMat(fn)[["mean.zEC.neg.uw"]])
S <- abs(readMat(fn)[["std.zEC.neg.uw"]])
mfile <- paste0(p, "P_mean_zEC_neg_uw.png")
sfile <- paste0(p, "P_std_zEC_neg_uw.png")
##### mean
pheatmap(M, 
         color = colorRampPalette(c("white", "blue"))(10),
         # set the max values
         breaks = seq(from = 0, to = 1, by = 0.1),
         border_color = NA, cellwidth = 1, cellheight = 1,
         legend = T,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "Mean of Inhibitory Effective Connectivity",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(pn, mfile), width = 6.5, height = 6)
##### std
pheatmap(S, 
         color = colorRampPalette(c("white", "blue"))(10),
         # set the max values
         breaks = seq(from = 0, to = 0.5, by = 0.05),
         border_color = NA, cellwidth = 1, cellheight = 1,
         legend = T,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "Std of Inhibitory Effective Connectivity",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(pn, sfile), width = 6.5, height = 6)
