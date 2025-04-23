rm(list=ls())
packages <- c("ggplot2", "ggseg", "ggsegDefaultExtra")
# sapply(packages,instAll.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

regions <- c("lh_isthmuscingulate","lh_caudalmiddlefrontal",
             "lh_entorhinal", "lh_parahippocampal", "lh_posteriorcingulate", "lh_insula", "lh_lateraloccipital")
to_plot <- data.frame(label = regions, value = c("H","H","L","L","L","L","L"))

ggseg(.data = to_plot, mapping = aes(fill = value), color = "black", atlas = dk,
      position = "stacked", hemisphere = "left", view = "medial",size = 1.2) +
  theme_void() +
  theme(legend.position = "none") +  # 去掉图例
  scale_fill_manual(values = c("H" = "white", "L" = "white"), na.value = "#e6e6e6")
  # scale_fill_manual(values = c("H" = "#facaae", "L" = "#b4d4c7"), na.value = "#f5f5f5")


name <- paste0("StruCova_brain_medial.png")
ggsave(file.path("E:/Documents/Work/文章投稿/ASD/制图/element", name), width = 7, height = 5, units = "in", dpi = 500)

ggseg(.data = to_plot, mapping = aes(fill = value), color = "black", atlas = dk,
      position = "stacked", hemisphere = "left", view = "lateral",size = 1.2) +
  theme_void() +
  theme(legend.position = "none") +  # 去掉图例
  scale_fill_manual(values = c("H" = "white", "L" = "white"), na.value = "#e6e6e6")

name <- paste0("StruCova_brain_lateral.png")
ggsave(file.path("E:/Documents/Work/文章投稿/ASD/制图/element", name), width = 7, height = 5, units = "in", dpi = 500)
