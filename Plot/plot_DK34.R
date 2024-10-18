# this script is used to DIY DK34 plot
# Xue-Ru Fan 9 August 2024 @BNU
###################################################
# png
###################################################
rm(list=ls())
packages <- c("ggseg", "ggplot2", "ggsegDefaultExtra", "showtext", "extrafont")
sapply(packages, require, character.only = TRUE)


# 定义脑区名称、颜色和对应的中文名称
region <- c("superior frontal","rostral middle frontal","caudal middle frontal",
            "pars opercularis","pars triangularis","pars orbitalis","frontal pole",
            "lateral orbitofrontal","medial orbitofrontal",
            "rostral anterior cingulate","caudal anterior cingulate",
            "precentral","paracentral","postcentral",
            "supramarginal","posterior cingulate","isthmus cingulate", 
            "precuneus","superior parietal","inferior parietal",
            "transverse temporal","bankssts",
            "superior temporal","middle temporal","inferior temporal",
            "fusiform","parahippocampal","entorhinal","temporal pole",
            "lateral occipital","lingual","pericalcarine","cuneus",
            "insula")
chinese = c("额上回","额中回喙部","额中回尾部",
            "额下回盖部","额下回三角部","额下回眶部","额极",
            "外侧眶额","内侧眶额",
            "前扣带喙部","前扣带尾部",
            "中央前回","中央旁小叶","中央后回",
            "缘上回","后扣带","扣带回峡部",
            "楔前叶","顶上皮层","顶下皮层",
            "颞横皮层","颞上沟后侧",
            "颞上回","颞中回","颞下回",
            "梭状回","海马旁回","内嗅皮层","颞极",
            "外侧枕叶","舌回","距状沟周围皮层","楔叶皮层",
            "脑岛")
color <- c("#95483f","#a22041","#b7282e",
           "#d3381c","#ea5506","#ec6800","#f08300",
           "#e17b34","#bf783a",
           "#c39143","#b48a76",
           "#c37854","#bfa46f","#a8c97f",
           "#38b48b","#47885e","#316745",
           "#00552e","#2f5d50","#006e54",
           "#8aaee6","#0091ff",
           "#2ca9e1","#0075c2","#165e83",
           "#192f60","#19448e","#4169e1","#778899",
           "#4a488e","#674598","#522f60","#460e44",
           "white")

brain <- data.frame(region, chinese, color)

brain$region <- factor(brain$region, levels = region)

colors_named <- setNames(brain$color, brain$region)
labels_named <- setNames(brain$chinese, brain$region)

ggseg(atlas = dkextra, mapping = aes(fill = region), color = "black",
      hemisphere = "left", size = 0.8) +
  scale_fill_manual(values = colors_named, labels = labels_named, breaks = region) +
  theme(legend.title = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        panel.background = element_blank(),
        # legend.position = "right",            # 图例位置，可以是 "right", "left", "top", "bottom"
        legend.key.size = unit(0.4, "cm"),      # 图例大小
        legend.text = element_text(size = 6, family = "STSong", face = "bold"))   # 图例文字大小


name <- file.path("E:/PhDproject/ABIDE/Plot", "DK34_240811.png")
ggsave(name, width = 6, height = 3.5, units = "in", dpi = 500)
