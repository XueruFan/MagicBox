# 本代码用来分析由谱聚类的方法分类的两组ASD男性脑指标的随龄变化（GLAMSS, P样条）
# 雪如 2024年3月25日于北师大办公室

rm(list=ls())
packages <- c("gamlss", "ggplot2", "cowplot")
# sapply(packages,instAll.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

# abideDir <- '/Volumes/Xueru/PhDproject/ABIDE' # mac
abideDir <- 'E:/PhDproject/ABIDE' # winds
phenoDir <- file.path(abideDir, "Preprocessed")
clustDir <- file.path(abideDir, "Analysis/Cluster/Cluster_A/SpectralCluster")
statiDir <- file.path(clustDir, "GAMLSS")
plotDir <- file.path(abideDir, "Plot/Cluster/Cluster_A/SpectralCluster")
resDate <- "240315"

raw <- read.csv(file.path(phenoDir, paste0("abide_A_forComBat_", resDate, ".csv")))

name <- paste0("abide_A_asd_male_dev_Spectral_Cluster_", resDate, ".csv")
cluster <- read.csv(file.path(clustDir, name))

start <- which(names(cluster) == "GMV")
colnames(cluster)[start:ncol(cluster)] <- paste0(colnames(cluster)[start:ncol(cluster)], "_centile")

All <- merge(cluster, raw, by = "participant", All.x = TRUE)


# 选择要分析的列
names_brain <- names(All)[which(names(All) == "GMV"):which(names(All) == "insula")]
names_col <- c("clusterID", "Age", names_brain)
All_age <- All[, names_col]

asd.1 <- subset(All_age, clusterID == 1)
asd.2 <- subset(All_age, clusterID == 2)


############################### Part 1: try P-splines morph ########################################


# define distribution family
disfam <- c("GB2", "GG")

# save all aic
aic_pb <- data.frame(matrix(nrow = length(names_brain), ncol = 2))
rownames(aic_pb) <- names_brain
colnames(aic_pb) <- c("cluster1", "cluster2")

for (f in disfam) {
  for (n in 1:length(names_brain)) {
    for (s in 1:2) {
      
      # 自变量固定为age
      eval(parse(text = paste0("x <- asd.", s, "$Age")))
      
      # 循环定义因变量
      yname <- names_brain[n]
      eval(parse(text = paste0("y <- as.numeric(asd.", s, "[, yname])")))
      # # for log
      # y <- (-1)*log(y) #做以e为底的对数变换
      
      data <- data.frame(x, y)
      
      eval(parse(text = paste0("result <- try(model_pb.", s,
                               " <- gamlss(y ~ pb(x), data = data, family = ", f, "))")))
      
      if ("try-error" %in% class(result)) {
        aic_pb[n, s] <- Inf
      } else {
        eval(parse(text = paste0("aic_pb[n, s] <- model_pb.", s, "$aic")))
      }
    }
    
  }
  name <- paste0("abide_A_asd_male_dev_Spectral_Cluster_pb_", f, "_aic_", resDate, ".csv")
  write.csv(aic_pb, file.path(statiDir, name), row.names = T)
}

# 经过比较，用raw~age建模时，GG的AIC都小，因此选择GG



#############################################

for (n in 1:length(names_brain)) {
  yname <- names_brain[n]
  
  # cluster 1
  x.1 <- asd.1$AGE_AT_SCAN
  y.1 <- as.numeric(asd.1[, yname])
  data.1 <- data.frame(x.1, y.1)
  model.1 <- gamlss(y.1 ~ pb(x.1), data = data.1, family = GG)
  
  df.1 <- data.frame(x = x.1, y = y.1, fit = fitted(model.1))
  fit1 <- df.1$fit
  x1 <- df.1$x
  y1 <- df.1$y
  
  # cluster 2
  x.2 <- asd.2$AGE_AT_SCAN
  y.2 <- as.numeric(asd.2[, yname])
  data.2 <- data.frame(x.2, y.2)
  model.2 <- gamlss(y.2 ~ pb(x.2), data = data.2, family = GG)
  df.2 <- data.frame(x = x.2, y = y.2, fit = fitted(model.2))
  fit2 <- df.2$fit
  x2 <- df.2$x
  y2 <- df.2$y
  
  
  df.1$cluster <- "1"
  df.2$cluster <- "2"
  df <- rbind(df.1, df.2)
  
  # set age and color
  ageTicks <- seq(6, 18, 2)
  ageLimits <- c(6, 18)
  colorTable <- c("#4682B4","#FFA07A")
  
  yTicks <- c(0, 2.5, 5, 7.5, 10)
  yLimits <- c(0, 10)
  
  # plot
  ggplot(df, aes(x = x, y = y, color = Group)) +
    geom_point(alpha = .3) +
    geom_line(aes(x = x, y = fit, color = Group), lwd = 2) +
    geom_vline(xintercept = max(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最大值
    geom_vline(xintercept = min(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最小值
    scale_x_continuous(limits = ageLimits, breaks = ageTicks,
                       label = c("5 yr","10 yr","20 yr","30 yr","50 yr","70 yr")) +
    scale_y_continuous(limits = yLimits, breaks = yTicks) +
    coord_fixed(ratio = 0.15) +
    theme_cowplot() +
    xlab("") +
    ylab("") +
    ggtitle(yname) +
    scale_color_manual(values = colorTable) +
    theme(axis.ticks.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text = element_text(size = 10),
          plot.title = element_text(hjust = 0.5, vjust = 1, size = 15))
  eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'asd_gamlss.log_", yname,
                                      "_log_230525.pdf')")))
  ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
  eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'PNG/asd_gamlss.log_", yname,
                                      "_log_230525.png')")))
  ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
  
  
  
  
}