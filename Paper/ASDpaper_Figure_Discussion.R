rm(list=ls())
packages <- c("ggplot2", "ggseg", "ggridges", "tidyr", "do", "dplyr", "Cairo", "openxlsx")
# sapply(packages, install.packages, character.only = TRUE)
sapply(packages, require, character.only = TRUE)

# abideDir <- '/Volumes/Xueru/PhDproject/ABIDE' # MAC
abideDir <- 'E:/PhDproject/ABIDE' # Windows
resDir <- file.path(abideDir, "Analysis/Cluster/Spect513")
plotDir <- file.path(abideDir, "Plot/Cluster/Spect513")
resDate <- "240315"
newDate <- "240610"

name <- paste0("Cluster_", newDate, ".csv")
cluster_result <- read.csv(file.path(resDir, name))

group1 <- (subset(cluster_result, clusterID == "1"))[, -1:-9]
group2 <- (subset(cluster_result, clusterID == "2"))[, -1:-9]


all_data <- data.frame()
id_group <- c("1", "2") # cluster 1 是L， 2是H

for (id in id_group){
  # id <- "1"
  eval(parse(text = paste0("group", id, " <- (subset(cluster_result, clusterID == ", id, "))[, -1:-2]")))
  eval(parse(text = paste0("regional <- group", id)))
  regional <- regional[which(names(regional) == "bankssts"):which(names(regional) == "insula")]
  asd_long <- gather(regional, key = "Measure", value = "Centile", bankssts:insula, na.rm = TRUE,
                     factor_key = TRUE)
  asd_long$Group <- factor(rep(id, nrow(asd_long)))  # 添加群体标识
  all_data <- rbind(all_data, asd_long)  # 合并数据
}


en_labels <- rev(c("superiorfrontal", "rostralmiddlefrontal", "caudalmiddlefrontal",
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
                   "insula"))
cn_labels <- rev(c("Superior frontal", "Rostral middle frontal", "Caudal middle frontal",
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
                   "Insula"))


all_data$Measure <- factor(all_data$Measure, levels = en_labels, labels = cn_labels)


######################### 一阶网络 #############################
parcs <- rev(c("Pericalcarine", "Cuneus", "Lingual", "Lateral occipital", "Transverse temporal",
               "Paracentral", "Postcentral", "Precentral", "Superior temporal"))

selected_data <- all_data %>%
  filter(Measure %in% parcs)

selected_data$Measure <- factor(selected_data$Measure, levels = parcs)

ggplot(selected_data, aes(x = Centile, y = Measure, fill = Group, group = interaction(Group, Measure))) +
  geom_density_ridges(scale = 2, quantile_lines = TRUE, size = 0.75, quantiles = 2, alpha = .9) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.25), labels = c("0%", "25%", "50%", "75%", "100%")) +
  scale_fill_manual(values = c("1" = "#b4d4c7", "2" = "#facaae")) +
  # coord_fixed(ratio = 0.15) + 
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(
        legend.position = "none", # without legend
        axis.text.y = element_text(size = 8),
        axis.text.x = element_text(size = 6))

name_regional <- paste0("Cluster_Centile_Regional_1stNetwork_", newDate, ".png")
ggsave(file.path(plotDir, name_regional), width = 5, height = 4, units = "in", dpi = 500)


objects_to_keep <- c("plotDir", "newDate", "all_data")
rm(list = (setdiff(ls(), objects_to_keep)))



######################### 二阶网络 #############################
parcs <- rev(c("Rostral anterior cingulate", "Posterior cingulate", "Superior parietal", "Fusiform", 
               "Supramarginal", "Insula"))

selected_data <- all_data %>%
  filter(Measure %in% parcs)

selected_data$Measure <- factor(selected_data$Measure, levels = parcs)

ggplot(selected_data, aes(x = Centile, y = Measure, fill = Group, group = interaction(Group, Measure))) +
  geom_density_ridges(scale = 2, quantile_lines = TRUE, size = 0.75, quantiles = 2, alpha = .9) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.25), labels = c("0%", "25%", "50%", "75%", "100%")) +
  scale_fill_manual(values = c("1" = "#b4d4c7", "2" = "#facaae")) +
  # coord_fixed(ratio = 0.15) + 
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(
    legend.position = "none", # without legend
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 6))

name_regional <- paste0("Cluster_Centile_Regional_2stNetwork_", newDate, ".png")
ggsave(file.path(plotDir, name_regional), width = 5, height = 3.5, units = "in", dpi = 500)


objects_to_keep <- c("plotDir", "newDate", "all_data")
rm(list = (setdiff(ls(), objects_to_keep)))


######################### 三阶网络-1 #############################
parcs <- rev(c("Isthmus cingulate", "Precuneus", "Caudal anterior cingulate", "Middle temporal", "Rostral middle frontal", "Superior frontal",
               "Inferior parietal", "Banks superior temporal", "Inferior temporal"))

selected_data <- all_data %>%
  filter(Measure %in% parcs)

selected_data$Measure <- factor(selected_data$Measure, levels = parcs)

ggplot(selected_data, aes(x = Centile, y = Measure, fill = Group, group = interaction(Group, Measure))) +
  geom_density_ridges(scale = 2, quantile_lines = TRUE, size = 0.75, quantiles = 2, alpha = .9) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.25), labels = c("0%", "25%", "50%", "75%", "100%")) +
  scale_fill_manual(values = c("1" = "#b4d4c7", "2" = "#facaae")) +
  # coord_fixed(ratio = 0.15) + 
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(
    legend.position = "none", # without legend
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 6))

name_regional <- paste0("Cluster_Centile_Regional_3stNetwork1_", newDate, ".png")
ggsave(file.path(plotDir, name_regional), width = 5, height = 4, units = "in", dpi = 500)

objects_to_keep <- c("plotDir", "newDate", "all_data")
rm(list = (setdiff(ls(), objects_to_keep)))


######################### 三阶网络-2 #############################
parcs <- rev(c("Medial orbital frontal", "Pars opercularis", "Caudal middle frontal",
               "Parahippocampal", "Pars triangularis", "Frontal pole"))

selected_data <- all_data %>%
  filter(Measure %in% parcs)

selected_data$Measure <- factor(selected_data$Measure, levels = parcs)

ggplot(selected_data, aes(x = Centile, y = Measure, fill = Group, group = interaction(Group, Measure))) +
  geom_density_ridges(scale = 2, quantile_lines = TRUE, size = 0.75, quantiles = 2, alpha = .9) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.25), labels = c("0%", "25%", "50%", "75%", "100%")) +
  scale_fill_manual(values = c("1" = "#b4d4c7", "2" = "#facaae")) +
  # coord_fixed(ratio = 0.15) + 
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(
    legend.position = "none", # without legend
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 6))

name_regional <- paste0("Cluster_Centile_Regional_3stNetwork2_", newDate, ".png")
ggsave(file.path(plotDir, name_regional), width = 5, height = 3.25, units = "in", dpi = 500)

objects_to_keep <- c("plotDir", "newDate", "all_data")
rm(list = (setdiff(ls(), objects_to_keep)))


######################### NA #############################
parcs <- rev(c("Temporal pole", "Pars orbitalis", "Entorhinal", "Lateral orbital frontal"))

selected_data <- all_data %>%
  filter(Measure %in% parcs)

selected_data$Measure <- factor(selected_data$Measure, levels = parcs)

ggplot(selected_data, aes(x = Centile, y = Measure, fill = Group, group = interaction(Group, Measure))) +
  geom_density_ridges(scale = 2, quantile_lines = TRUE, size = 0.75, quantiles = 2, alpha = .9) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.25), labels = c("0%", "25%", "50%", "75%", "100%")) +
  scale_fill_manual(values = c("1" = "#b4d4c7", "2" = "#facaae")) +
  # coord_fixed(ratio = 0.15) + 
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(
    legend.position = "none", # without legend
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 6))

name_regional <- paste0("Cluster_Centile_Regional_naNetwork_", newDate, ".png")
ggsave(file.path(plotDir, name_regional), width = 5, height = 3.25, units = "in", dpi = 500)


######################### L Ab #############################
# parcs <- rev(c("Pericalcarine", "Fusiform", "Middle temporal", "Inferior temporal",
#                "Medial orbital frontal", "Frontal pole", "Temporal pole"))
parcs <- rev(c("Pericalcarine", "Fusiform", "Middle temporal", "Inferior temporal", "Temporal pole"))

selected_data <- all_data %>%
  filter(Measure %in% parcs)

selected_data$Measure <- factor(selected_data$Measure, levels = parcs)

ggplot(selected_data, aes(x = Centile, y = Measure, fill = Group, group = interaction(Group, Measure))) +
  geom_density_ridges(scale = 2, quantile_lines = TRUE, size = 0.75, quantiles = 2, alpha = .9) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.25), labels = c("0%", "25%", "50%", "75%", "100%")) +
  scale_fill_manual(values = c("1" = "#b4d4c7", "2" = "#facaae")) +
  # coord_fixed(ratio = 0.15) + 
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(
    legend.position = "none", # without legend
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 6))

name_regional <- paste0("Cluster_Centile_Regional_L_Ab_", newDate, ".png")
ggsave(file.path(plotDir, name_regional), width = 5, height = 4, units = "in", dpi = 500)


######################### H Ab #############################
# parcs <- rev(c("Transverse temporal", "Paracentral", "Insula", "Caudal anterior cingulate", 
#                "Posterior cingulate", "Banks superior temporal"))
parcs <- rev(c("Transverse temporal", "Insula", "Caudal anterior cingulate", 
               "Posterior cingulate", "Banks superior temporal"))

selected_data <- all_data %>%
  filter(Measure %in% parcs)

selected_data$Measure <- factor(selected_data$Measure, levels = parcs)

ggplot(selected_data, aes(x = Centile, y = Measure, fill = Group, group = interaction(Group, Measure))) +
  geom_density_ridges(scale = 2, quantile_lines = TRUE, size = 0.75, quantiles = 2, alpha = .9) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.25), labels = c("0%", "25%", "50%", "75%", "100%")) +
  scale_fill_manual(values = c("1" = "#b4d4c7", "2" = "#facaae")) +
  # coord_fixed(ratio = 0.15) + 
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(
    legend.position = "none", # without legend
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 6))

name_regional <- paste0("Cluster_Centile_Regional_H_Ab_", newDate, ".png")
ggsave(file.path(plotDir, name_regional), width = 5.5, height = 4, units = "in", dpi = 500)
