rm(list=ls())
library(R.matlab)
library(pheatmap)
library(RColorBrewer)
library(wesanderson)
library(ggplot2)

# set these parameters
p <- 400
datapath <- "/Volumes/Xueru/HCP_339/Results/Group/EC/"
setwd(datapath)
fn  <- paste0(p, "P_EC_count2.mat")
pn <- paste0(datapath, "PIC/")

##### mean_pos
M <- abs(readMat(fn)[["count.4runs.mean"]])

## heatmap_pou
mfile <- paste0(p, "P_EC_count_4runs_pos_mean.png")
pheatmap(M, 
         color = wes_palette("Zissou1", 10, type = "continuous"),
         # set the max values
         breaks = seq(from = 0, to = 1, by = 0.1),
         border_color = NA, cellwidth = 1, cellheight = 1,
         legend = T,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "How many subs have pEC values in each run",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(pn, mfile), width = 6.5, height = 6)

## histogram_pos
mfile2 <- paste0(p, "P_EC_count_4runs_pos_mean_hist.png")
dim(M) <- c(p^2,1)
M <- as.data.frame(M)
colnames(M) <- "precentage"
colors <- wes_palette("Zissou1", 10, type = "continuous")
ggplot(M, aes(x = precentage, y = ..density..)) +
  geom_histogram(stat = "bin", binwidth = 0.1,
                 boundary = 0, fill = colors,
                 color = "#e9ecef", alpha = 0.85) +
  geom_text(aes(label = as.character(paste0(round(..density.., 3)*10, "%"))),
            stat = "bin", binwidth = 0.1, boundary = 0, size = 3.5,
            vjust = -0.4) +
  labs(x = "分区间存在激活连接的被试比值（被试总数 = 321）",
       y = "此类型连接所占百分比（连接总数 = 160000）") +
  coord_equal(ratio = 1/2) +
  scale_x_continuous(breaks = seq(0, 1, 0.1), minor_breaks = seq(0, 1, 0.1)) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1, scale=10)) +
  theme_grey(base_family = "STKaiti") +
  theme(axis.ticks.y = element_blank(),
        axis.ticks.x =  element_blank(),
        axis.title.x = element_text(margin = margin(t = 10), size = 15),
        axis.title.y = element_text(margin = margin(r = 10), size = 15),
        axis.text = element_text(size = 12),
        plot.margin = margin(t = 0.2, r = 0.3, b = 0.3, l = 0.2, unit = "cm"))
ggsave(paste0(pn, mfile2), width = 7, height = 7, dpi = 600)
## histogram_neg
mfile3 <- paste0(p, "P_EC_count_4runs_neg_mean_hist.png")
N <- as.data.frame(1-M)
colors <- wes_palette("Zissou1", 10, type = "continuous")
colors <- rev(colors)
ggplot(N, aes(x = precentage, y = ..density..)) +
  geom_histogram(stat = "bin", binwidth = 0.1,
                 boundary = 0, fill = colors,
                 color = "#e9ecef", alpha = 0.85) +
  geom_text(aes(label = as.character(paste0(round(..density.., 3)*10, "%"))),
            stat = "bin", binwidth = 0.1, boundary = 0, size = 3.5,
            vjust = -0.4) +
  labs(x = "分区间存在抑制连接的被试比值（被试总数 = 321）",
       y = "此类型连接所占百分比（连接总数 = 160000）") +
  coord_equal(ratio = 1/2) +
  scale_x_continuous(breaks = seq(0, 1, 0.1), minor_breaks = seq(0, 1, 0.1)) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1, scale=10)) +
  theme_grey(base_family = "STKaiti") +
  theme(axis.ticks.y = element_blank(),
        axis.ticks.x =  element_blank(),
        axis.title.x = element_text(margin = margin(t = 10), size = 15),
        axis.title.y = element_text(margin = margin(r = 10), size = 15),
        axis.text = element_text(size = 12),
        plot.margin = margin(t = 0.2, r = 0.3, b = 0.3, l = 0.2, unit = "cm"))
ggsave(paste0(pn, mfile3), width = 7, height = 7, dpi = 600)

##### std_pos heatmap
S <- abs(readMat(fn)[["count.4runs.std"]])
sfile <- paste0(p, "P_EC_count_4runs_pos_std.png")
pheatmap(S, 
         color = colorRampPalette(c("white", "red"))(10),
         # set the max values
         breaks = seq(from = 0, to = 0.4, by = 0.04),
         border_color = NA, cellwidth = 1, cellheight = 1,
         legend = T,
         scale = "none", cluster_rows = F, cluster_cols = F,
         annotation_legend = F, annotation_names_row = F, annotation_names_col = F,
         show_rownames = F, show_colnames = F, 
         #main = "How many subs have pEC values in each run",
         angle_col = "90", display_numbers = F, na_col = "#000000",
         filename = paste0(pn, sfile), width = 6.5, height = 6)