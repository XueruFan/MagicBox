# this script is used to try analysis ABIDE subgroup using GAMLSS P-splines model

# 用log值建模后plot为原始值

# Xue-Ru Fan 24 May 2023 @BNU

rm(list=ls())

# load packages
library(gamlss)
library(ggplot2)
library(cowplot)


# define filefolder
abideDir <- 'E:/研究课题/ABIDE'
dataDir <- file.path(abideDir, "Preprocessed")
analDir <- file.path(abideDir, "Analysis")
plotDir <- file.path(analDir, "Plot/gamlss/PB.GG")

# load in model
setwd(analDir)

################################## Part10: get ready for gamlss ####################################

# get source
volume <- read.csv("abide_pam0625.csv") # 34 regional
ynames <- names(volume)[3:43]

setwd(dataDir)
abide <- read.csv("abide_all.csv") # pheno
asd <- subset(abide, DX_GROUP == 1)
colnames(volume)[2] <- "Participant"
asd_all <- merge(volume, asd, by = "Participant", all.x = TRUE)

# add age transfer
age_trans <- read.csv("E:/研究课题/ABIDE/Centile/bankssts.csv")[, 1:2]
colnames(age_trans)[1] <- "Participant"

asd_all <- merge(asd_all, age_trans, by = "Participant", all.x = TRUE)

asd.1 <- subset(asd_all, clusterID == 1)
asd.2 <- subset(asd_all, clusterID == 2)


################################## Part11:  full age #########################################


# group-wise
for (n in 1:length(ynames)) {
  
  for (s in 1:2) {
    
    # 自变量固定为age
    eval(parse(text = paste0("x <- asd.", s, "$AgeTransformed")))
    
    # 循环定义因变量
    yname <- ynames[n]
    eval(parse(text = paste0("y <- as.numeric(asd.", s, "[, yname])")))
    
    data <- na.omit(data.frame(x, y))
    # y_ori <- data$y
    # y_log <- (-1)*log(y_ori)
    
    # for log
    data$y <- (-1)*log(data$y) #做以e为底的对数变换
    
    # # 去掉不满30岁的被试
    # data <- subset(data, x <= log((30*365.245)+280))
    
    
    # log 用GG
    eval(parse(text = paste0("model.", s, " <- gamlss(y ~ pb(x), data = data, family = GG)")))
    
    eval(parse(text = paste0("fit", s, " = fitted(model.", s, ")")))
    eval(parse(text = paste0("df.", s, " <- cbind(data, fit", s, ")")))
    
    eval(parse(text = paste0("colnames(df.", s, ") <- c('x', 'y', 'fit')")))
    
    eval(parse(text = paste0("fit", s, " <- df.", s, "$fit")))
    eval(parse(text = paste0("x", s, " <- df.", s, "$x")))
    eval(parse(text = paste0("y", s, " <- df.", s, "$y")))
  }
  
  #################################### plot
  
  df.1$Group <- "1"
  df.2$Group <- "2"
  df <- rbind(df.1, df.2)
  df$fit_ori <- exp(df$fit * (-1))
  df$y_ori <- exp(df$y * (-1))
  
  # set age and color
  ageTicks <- log((c(5,10,20,30, 50, 70)*365.245)+280)
  ageLimits <- log((c(5, 70)*365.245)+280)
  colorTable <- c("#4682B4","#FFA07A")

  # plot
  ggplot(df, aes(x = x, y = y_ori, color = Group)) +
    geom_point(alpha = .3) +
    geom_line(aes(x = x, y = fit_ori, color = Group), lwd = 2) +
    geom_vline(xintercept = max(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最大值
    geom_vline(xintercept = min(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最小值
    scale_x_continuous(limits = ageLimits, breaks = ageTicks,
                       label = c("5 yr","10 yr","20 yr","30 yr","50 yr","70 yr")) +
    coord_fixed(ratio = 2) +
    theme_cowplot() +
    xlab("") +
    ylab("") +
    ggtitle(yname) +
    scale_color_manual(values = colorTable) +
    theme(axis.ticks.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text = element_text(size = 10),
          plot.title = element_text(hjust = 0.5, vjust = 1, size = 15))

  eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'asd_gamlss_", yname,
                                      "_230625.pdf')")))
  ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
  eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'PNG/asd_gamlss_", yname,
                                      "_230625.png')")))
  ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
  
  # # plot
  # # for log transfer
  # 
  # yTicks <- c(0, 2.5, 5, 7.5, 10)
  # yLimits <- c(0, 10)
  # 
  # # plot
  # ggplot(df, aes(x = x, y = y, color = Group)) +
  #   geom_point(alpha = .3) +
  #   geom_line(aes(x = x, y = fit, color = Group), lwd = 2) +
  #   geom_vline(xintercept = max(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最大值
  #   geom_vline(xintercept = min(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最小值
  #   scale_x_continuous(limits = ageLimits, breaks = ageTicks,
  #                      label = c("5 yr","10 yr","20 yr","30 yr","50 yr","70 yr")) +
  #   scale_y_continuous(limits = yLimits, breaks = yTicks) +
  #   coord_fixed(ratio = 0.2) +
  #   theme_cowplot() +
  #   xlab("") +
  #   ylab("") +
  #   ggtitle(yname) +
  #   scale_color_manual(values = colorTable) +
  #   theme(axis.ticks.x = element_blank(),
  #         axis.ticks.y = element_blank(),
  #         axis.text = element_text(size = 10),
  #         plot.title = element_text(hjust = 0.5, vjust = 1, size = 15))
  # eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'asd_gamlss.log_", yname,
  #                                     "_230525.pdf')")))
  # ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
  # eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'PNG/asd_gamlss.log_", yname,
  #                                     "_230525.png')")))
  # ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
  
}



################################## Part12:  below 30 #########################################


# group-wise
for (n in 1:length(ynames)) {
  
  for (s in 1:2) {
    
    # 自变量固定为age
    eval(parse(text = paste0("x <- asd.", s, "$AgeTransformed")))
    
    # 循环定义因变量
    yname <- ynames[n]
    eval(parse(text = paste0("y <- as.numeric(asd.", s, "[, yname])")))
    
    data <- na.omit(data.frame(x, y))
    # y_ori <- data$y
    # y_log <- (-1)*log(y_ori)
    
    # for log
    data$y <- (-1)*log(data$y) #做以e为底的对数变换
    
    # 去掉不满30岁的被试
    data <- subset(data, x <= log((30*365.245)+280))
    
    
    # log 用GG
    eval(parse(text = paste0("model.", s, " <- gamlss(y ~ pb(x), data = data, family = GG)")))
    
    eval(parse(text = paste0("fit", s, " = fitted(model.", s, ")")))
    eval(parse(text = paste0("df.", s, " <- cbind(data, fit", s, ")")))
    
    eval(parse(text = paste0("colnames(df.", s, ") <- c('x', 'y', 'fit')")))
    
    eval(parse(text = paste0("fit", s, " <- df.", s, "$fit")))
    eval(parse(text = paste0("x", s, " <- df.", s, "$x")))
    eval(parse(text = paste0("y", s, " <- df.", s, "$y")))
  }
  
  #################################### plot
  
  df.1$Group <- "1"
  df.2$Group <- "2"
  df <- rbind(df.1, df.2)
  df$fit_ori <- exp(df$fit * (-1))
  df$y_ori <- exp(df$y * (-1))
  
  # set age and color
  # ageTicks <- log((c(5,10,20,30, 50, 70)*365.245)+280)
  # ageLimits <- log((c(5, 70)*365.245)+280)
  ageTicks <- log((c(5,10,20,30)*365.245)+280)
  ageLimits <- log((c(5, 30)*365.245)+280)
  colorTable <- c("#4682B4","#FFA07A")
  
  # plot
  ggplot(df, aes(x = x, y = y_ori, color = Group)) +
    geom_point(alpha = .3) +
    geom_line(aes(x = x, y = fit_ori, color = Group), lwd = 2) +
    geom_vline(xintercept = max(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最大值
    geom_vline(xintercept = min(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最小值
    scale_x_continuous(limits = ageLimits, breaks = ageTicks,
                       label = c("5 yr","10 yr","20 yr","30 yr")) +
    coord_fixed(ratio = 1.5) +
    theme_cowplot() +
    xlab("") +
    ylab("") +
    ggtitle(yname) +
    scale_color_manual(values = colorTable) +
    theme(axis.ticks.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text = element_text(size = 10),
          plot.title = element_text(hjust = 0.5, vjust = 1, size = 15))
  
  eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'asd_gamlss_age30", yname,
                                      "_230625.pdf')")))
  ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
  eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'PNG/asd_gamlss_age30", yname,
                                      "_230625.png')")))
  ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
  
}



################################## Part2: cognitive ###################################################

rm(list=ls())

# load packages
library(gamlss)
library(ggplot2)
library(cowplot)


# define filefolder
abideDir <- 'E:/ABIDE'
dataDir <- file.path(abideDir, "Preprocessed")
analDir <- file.path(abideDir, "Analysis")
plotDir <- file.path(analDir, "Plot/gamlss/PB.GG")

# load in model
setwd(analDir)

# get source
volume <- read.csv("abide_pam.csv") # 34 regional

setwd(dataDir)
abide <- read.csv("abide_all.csv") # pheno
asd <- subset(abide, DX_GROUP == 1)
asd_all <- merge(volume, asd, by = "Participant", all.x = TRUE)

# add age transfer
age_trans <- read.csv("E:/ABIDE/Centile/bankssts.csv")[, 1:2]
colnames(age_trans)[1] <- "Participant"

asd_all <- merge(asd_all, age_trans, by = "Participant", all.x = TRUE)

asd.1 <- subset(asd_all, clusterID == 1)
asd.2 <- subset(asd_all, clusterID == 2)

# define
ynames <- names(asd_all)[c(53, 59:63, 85:90)]


# below 30
for (n in 1:length(ynames)) {
  
  for (s in 1:2) {
    
    # 自变量固定为age
    eval(parse(text = paste0("x <- asd.", s, "$AgeTransformed")))
    
    # 循环定义因变量
    yname <- ynames[n]
    eval(parse(text = paste0("y <- as.numeric(asd.", s, "[, yname])")))
    
    y <- scale(y) # 标准化
    
    data <- na.omit(data.frame(x, y))

    # 去掉不满30岁的被试
    data <- subset(data, x <= log((30*365.245)+280))
    
    # 正态分布
    eval(parse(text = paste0("model.", s, " <- gamlss(y ~ pb(x), data = data, family = NO)")))
    
    eval(parse(text = paste0("fit", s, " = fitted(model.", s, ")")))
    eval(parse(text = paste0("df.", s, " <- cbind(data, fit", s, ")")))
    
    eval(parse(text = paste0("colnames(df.", s, ") <- c('x', 'y', 'fit')")))
    
    eval(parse(text = paste0("fit", s, " <- df.", s, "$fit")))
    eval(parse(text = paste0("x", s, " <- df.", s, "$x")))
    eval(parse(text = paste0("y", s, " <- df.", s, "$y")))
  }
  
  #################################### plot
  
  df.1$Group <- "1"
  df.2$Group <- "2"
  df <- rbind(df.1, df.2)
  
  # set age and color
  ageTicks <- log((c(5,10,20,30)*365.245)+280)
  ageLimits <- log((c(5, 30)*365.245)+280)
  colorTable <- c("#4682B4","#FFA07A")
  
  # plot
  ggplot(df, aes(x = x, y = y, color = Group)) +
    geom_point(alpha = .3) +
    geom_line(aes(x = x, y = fit, color = Group), lwd = 2) +
    geom_vline(xintercept = max(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最大值
    geom_vline(xintercept = min(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最小值
    scale_x_continuous(limits = ageLimits, breaks = ageTicks,
                       label = c("5 yr","10 yr","20 yr","30 yr")) +
    coord_fixed(ratio = 0.3) +
    theme_cowplot() +
    xlab("") +
    ylab("") +
    ggtitle(yname) +
    scale_color_manual(values = colorTable) +
    theme(axis.ticks.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text = element_text(size = 10),
          plot.title = element_text(hjust = 0.5, vjust = 1, size = 15))
  
  # eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'asd_gamlss_age30", yname,
  #                                     "_230525.pdf')")))
  # ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
  eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'PNG/asd_gamlss_age30", yname,
                                      "_230525.jpg')")))
  ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
  
}


################################## Part3: cog~morph
rm(list=ls())

# load packages
library(gamlss)
library(ggplot2)
library(cowplot)


# define filefolder
abideDir <- 'E:/ABIDE'
dataDir <- file.path(abideDir, "Preprocessed")
analDir <- file.path(abideDir, "Analysis")
plotDir <- file.path(analDir, "Plot/gamlss/PB.GG")

# load in model
setwd(analDir)

# get source
volume <- read.csv("abide_pam.csv") # 34 regional

setwd(dataDir)
abide <- read.csv("abide_all.csv") # pheno
asd <- subset(abide, DX_GROUP == 1)
asd_all <- merge(volume, asd, by = "Participant", all.x = TRUE)

# add age transfer
age_trans <- read.csv("E:/ABIDE/Centile/bankssts.csv")[, 1:2]
colnames(age_trans)[1] <- "Participant"

asd_all <- merge(asd_all, age_trans, by = "Participant", all.x = TRUE)

asd.1 <- subset(asd_all, clusterID == 1)
asd.2 <- subset(asd_all, clusterID == 2)

# define
xnames <- names(asd_all)[3:43]
ynames <- names(asd_all)[c(53, 59:63, 85:90)]


# below 30
for (m in 1:length(xnames)) {
  for (n in 1:length(ynames)) {
    for (s in 1:2) {
   
      # 自变量
      xname <- xnames[m]
      eval(parse(text = paste0("x <- asd.", s, "$", xname)))
      
      # 循环定义因变量
      yname <- ynames[n]
      eval(parse(text = paste0("y <- as.numeric(asd.", s, "[, yname])")))
      
      y <- scale(y) # 标准化
      
      data <- na.omit(data.frame(x, y))
      
      # 正态分布
      eval(parse(text = paste0("model.", s, " <- gamlss(y ~ pb(x), data = data, family = NO)")))
      
      eval(parse(text = paste0("fit", s, " = fitted(model.", s, ")")))
      eval(parse(text = paste0("df.", s, " <- cbind(data, fit", s, ")")))
      
      eval(parse(text = paste0("colnames(df.", s, ") <- c('x', 'y', 'fit')")))
      
      eval(parse(text = paste0("fit", s, " <- df.", s, "$fit")))
      eval(parse(text = paste0("x", s, " <- df.", s, "$x")))
      eval(parse(text = paste0("y", s, " <- df.", s, "$y")))
    }
    
    #################################### plot
    
    df.1$Group <- "1"
    df.2$Group <- "2"
    df <- rbind(df.1, df.2)
    
    # set age and color
    colorTable <- c("#4682B4","#FFA07A")
    
    # plot
    ggplot(df, aes(x = x, y = y, color = Group)) +
      geom_point(alpha = .3) +
      geom_line(aes(x = x, y = fit, color = Group), lwd = 2) +
      geom_vline(xintercept = max(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最大值
      geom_vline(xintercept = min(df$x), linetype = 2, lwd = 0.5, alpha = .3) + #年龄最小值
      coord_fixed(ratio = 0.18) +
      theme_cowplot() +
      xlab("") +
      ylab("") +
      ggtitle(paste0(yname, "~", xname)) +
      scale_color_manual(values = colorTable) +
      theme(axis.ticks.x = element_blank(),
            axis.ticks.y = element_blank(),
            axis.text = element_text(size = 10),
            plot.title = element_text(hjust = 0.5, vjust = 1, size = 15))

    eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'PNG/asd_gamlss_age30", yname,
                                        "_", xname, "_230525.jpg')")))
    ggsave(name, width = 6, height = 5, units = "in", dpi = 500)
    
  }
}
