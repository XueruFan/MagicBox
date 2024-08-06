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
filefolder <- "/Users/xueru/Desktop/ScientificData/Code/PlotIQ/"
setwd(filefolder)

# load file
filename <- "Plot_IQ.csv"
Plot_IQ <- read.csv(filename, header=TRUE, sep = ",")


##################    statistic   ##############################################
##### mean and sd
IQ_ana <- data.frame(matrix(ncol = 3, nrow = 15))
colnames(IQ_ana) <- c("Median", "Mean", "SD")
SWU <- subset(Plot_IQ, Site=="SWU")
CAS <- subset(Plot_IQ, Site=="CAS")
ALL <- Plot_IQ
ALL$Site <- "ALL"
TBT <- matrix(c("ProcessingSpeed_T", "WM_T", "PerceptualReasoning_T",
                "Verbal_T", "FSIQ_T"))
Sites <- matrix(c("SWU", "CAS", "ALL"))
rnames <- NULL
for (i in 1:5) {
  for (j in 1:3) {
    rname <- paste0(TBT[i]," ", Sites[j])
    rnames <- c(rnames, rname)
  }
}
rownames(IQ_ana) <- rnames
for (i in 1:5) {
  for (j in 1:3) {
    c <- paste0(TBT[i], " ", Sites[j])
    eval(parse(text = paste0("med <- median(", Sites[j], "$", TBT[i],
                             ", na.rm = T)")))
    IQ_ana[c,"Median"] <- med
    eval(parse(text = paste0("m <- mean(", Sites[j], "$", TBT[i],
                             ", na.rm = T)")))
    IQ_ana[c,"Mean"] <- m
    eval(parse(text = paste0("s <- sd(", Sites[j], "$", TBT[i],
                             ", na.rm = T)")))
    IQ_ana[c,"SD"] <- s
  }
}
IQ_ana <- round(IQ_ana, digits = 2)
write.csv(IQ_ana, "IQ_Analysis.csv")

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
##################    plot participants [density] #################
IQ_for_plot <- data.frame(Class, Score)
IQ_Density_CCNP <- ggplot(IQ_for_plot, aes(x = Score, y = Class, fill = Class)) +
  geom_density_ridges(scale = 1.5, alpha = 0.5, quantile_lines = TRUE,
                      quantiles = 2, ) +
  scale_x_continuous(breaks = c(50, 70, 80, 90, 110, 120, 130, 170)) +
  coord_fixed(ratio = 8, xlim = c(50, 170)) + 
  scale_fill_cyclical(values = c("#778899", "#778899", "#778899",
                                 "#ffa07a", "#ffa07a", "#ffa07a",
                                 "#dda0dd", "#dda0dd", "#dda0dd",
                                 "#6495ed", "#6495ed", "#6495ed",
                                 "#5f9ea0", "#5f9ea0", "#5f9ea0")) +
  theme_ridges() + 
  xlab("Score") + #不显示轴标题
  ylab("") +
  theme(legend.position = "none",
        axis.text.y = element_text(size = 18),
        axis.text.x = element_text(size = 18),
        axis.title.x = element_text(vjust = -1, hjust = 0.5,
                                    size = 20, face = "bold"))
IQ_Density_CCNP
ggsave('Plot_IQdensity_14Dec2022.png', IQ_Density_CCNP, width = 10, height = 9, 
       units = "in", dpi = 500)

######### chao
# filename <- "./plotPhenotype/PhenoSum/Plot_IQ.csv"
# Plot_IQ <- read.csv(filename, header=TRUE, sep = ",")
# p_short = ggplot(Plot_IQ_long, aes(x=value, y=as_factor(Plot_IQ_long$IQ_type), fill=factor(paste(Site)))) +
#   
#   stat_density_ridges(
#     na.rm = TRUE,
#     scale=0.8,alpha = 0.6,
#     geom = "density_ridges_gradient", calc_ecdf = TRUE,
#     quantiles = 2, quantile_lines = TRUE,
#   ) +
#   scale_fill_viridis(discrete = TRUE
#                      , name = "Quantile"
#                      , alpha = 0.3
#   ) + 
#   theme_bw(base_size = 7,base_line_size = 0.25, base_rect_size =1) +
#   theme(legend.position = "top",panel.grid.major.y = element_line(size = 0.2, colour = "grey80"),
#         legend.key.size = unit(3, 'mm'), #change legend key size
#         legend.key.height = unit(3, 'mm'), #change legend key height
#         legend.key.width = unit(3, 'mm'), #change legend key width
#         legend.title = element_text(size=6), #change legend title font size
#         legend.text = element_text(size=6)
#   )+
#   scale_x_continuous(breaks = seq(from=50, by=20, to=170), minor_breaks = T)
# output = paste0('../figures/IQ.pdf')
# ggsave(output,p_short)

##################    statistical analysis   ###################################
SWU <- subset(Plot_IQ, Site=="SWU")
CAS <- subset(Plot_IQ, Site=="CAS")
ALL <- Plot_IQ
ALL$Site <- "ALL"
TBT <- matrix(c("ProcessingSpeed_T", "WM_T", "PerceptualReasoning_T",
                "Verbal_T", "FSIQ_T"))
Sites <- matrix(c("SWU", "CAS", "ALL"))
####### Shapiro–Wilk Test
SWT_IQ <- data.frame(matrix(ncol = 2, nrow = 15))
colnames(SWT_IQ) <- c("W", "p-value")
rnames <- NULL
for (i in 1:5) {
  for (j in 1:3) {
    rname <- paste0(TBT[i]," ", Sites[j])
    rnames <- c(rnames, rname)
  }
}
rownames(SWT_IQ) <- rnames
for (i in 1:5) {
  for (j in 1:3) {
    eval(parse(text = paste0("Result <- shapiro.test(", Sites[j], "$", TBT[i],
                             ")")))
    c <- paste0(TBT[i], " ", Sites[j])
    SWT_IQ[c,"W"] <- Result[["statistic"]][["W"]]
    SWT_IQ[c,"p-value"] <- Result[["p.value"]]
  }
}
SWT_IQ <- round(SWT_IQ, digits = 4)
write.csv(SWT_IQ, "IQ_Shapiro_Wilk_Test.csv")
###### Rank Sum Test
RST_IQ <- data.frame(matrix(ncol = 2, nrow = 5))
colnames(RST_IQ) <- c("W", "p-value")
rownames(RST_IQ) <- TBT
for (i in 1:5) {
  eval(parse(text = paste0("Result <- wilcox.test(CAS$", TBT[i],
                           ", SWU$", TBT[i], ")")))
  c <- paste0(TBT[i], " ", Sites[j])
  RST_IQ[TBT[i],"W"] <- Result[["statistic"]][["W"]]
  RST_IQ[TBT[i],"p-value"] <- Result[["p.value"]]
}
RST_IQ <- round(RST_IQ, digits = 4)
write.csv(RST_IQ, "IQ_Rank_Sum_Test.csv")

##################    plot [不区分站点]################################
SWU <- grep("SWU", IQ_for_plot$Class) #选择带"SWU"的行的index
CAS <- grep("CAS", IQ_for_plot$Class)
site <- c(SWU, CAS)
IQ_for_plot_all <- IQ_for_plot[-site, ] #将站点行去掉
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
