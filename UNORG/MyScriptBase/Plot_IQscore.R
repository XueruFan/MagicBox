# Plot CCNP (CKG and PEK) participants by their IQ
# Copyright: Xue-Ru Fan @Beijing, 13th Dec 2022

rm(list=ls())
library(tidyr)
library(reshape2)
library(ggplot2)
library(ggridges)
library(colorspace)
library(colormap)

# set environment
filefolder <- "C:/Users/xueru/Desktop/ScientificData/Code/PlotIQ/"
setwd(filefolder)

# load file
filename <- "Plot_IQ.csv"
Plot_IQ <- read.csv(filename, header=TRUE, sep = ",")


##################    arrange data for plotting [区分站点]################################
Plot_IQ_long <- melt(Plot_IQ, id.vars = "Site", value.name = "Score")
Plot_IQ_long <- tidyr::unite(Plot_IQ_long, "Class", Site, variable)
FSIQ <- data.frame(Plot_IQ$FSIQ_T,"FSIQ")
colnames(FSIQ) <- c("Score", "Class")
VCI <- data.frame(Plot_IQ$Verbal_T,"VCI")
colnames(VCI) <- c("Score", "Class")
PRI <- data.frame(Plot_IQ$PerceptualReasoning_T,"PRI")
colnames(PRI) <- c("Score", "Class")
WMI <- data.frame(Plot_IQ$WM_T,"WMI")
colnames(WMI) <- c("Score", "Class")
PSI <- data.frame(Plot_IQ$ProcessingSpeed_T,"PSI")
colnames(PSI) <- c("Score", "Class")
Plot_IQ_long <- rbind(PSI, WMI, PRI, VCI, FSIQ, Plot_IQ_long)
Score <- as.numeric(Plot_IQ_long$Score)
Class <- as.factor(Plot_IQ_long$Class)
levels(Class)
Class <- ordered(Class, 
                 levels = c("FSIQ", "CAS_FSIQ_T", "SWU_FSIQ_T", "VCI",
                            "CAS_Verbal_T","SWU_Verbal_T", "PRI",
                            "CAS_PerceptualReasoning_T",
                            "SWU_PerceptualReasoning_T", "WMI", "CAS_WM_T",
                            "SWU_WM_T", "PSI", "CAS_ProcessingSpeed_T",
                            "SWU_ProcessingSpeed_T"))
levels(Class)
levels(Class)[levels(Class) == "CAS_FSIQ_T"] <- "FSIQ CAS"
levels(Class)[levels(Class) == "SWU_FSIQ_T"] <- "FSIQ SWU"
levels(Class)[levels(Class) == "CAS_Verbal_T"] <- "VCI CAS"
levels(Class)[levels(Class) == "SWU_Verbal_T"] <- "VCI SWU"
levels(Class)[levels(Class) == "CAS_PerceptualReasoning_T"] <- "PRI CAS"
levels(Class)[levels(Class) == "SWU_PerceptualReasoning_T"] <- "PRI SWU"
levels(Class)[levels(Class) == "CAS_WM_T"] <- "WMI CAS"
levels(Class)[levels(Class) == "SWU_WM_T"] <- "WMI SWU"
levels(Class)[levels(Class) == "CAS_ProcessingSpeed_T"] <- "PSI CAS"
levels(Class)[levels(Class) == "SWU_ProcessingSpeed_T"] <- "PSI SWU"
levels(Class)


##################    plot [不区分站点]################################
SWU <- grep("SWU", Plot_IQ_long$Class) #选择带"SWU"的行的index
CAS <- grep("CAS", Plot_IQ_long$Class)
site <- c(SWU, CAS)
IQ_for_plot_all <- Plot_IQ_long[-site, ] #将站点行去掉
IQ_all_Density_CCNP <- ggplot(IQ_for_plot_all, aes(x = Score, y = Class, fill = Class)) +
  geom_density_ridges(scale = 1, alpha = 0.5, quantile_lines = TRUE,
                      quantiles = 2, ) +
  scale_x_continuous(breaks = c(50, 70, 80, 90, 110, 120, 130, 170)) +
  coord_fixed(ratio = 20, xlim = c(50, 170)) + 
  scale_fill_cyclical(values = c(NA, NA, NA, NA, NA)) +
  theme_ridges() + 
  xlab("Score") + #不显示轴标题
  ylab("") +
  theme(legend.position = "none",
        axis.text.y = element_text(size = 12),
        axis.text.x = element_text(size = 10),
        axis.title.x = element_text(vjust = -1, hjust = 0.5,
                                    size = 15, face = "bold"))
IQ_all_Density_CCNP
ggsave('Plot_IQdensity_all_13Feb2023.png', IQ_all_Density_CCNP, width = 5, height = 5, 
       units = "in", dpi = 500)
