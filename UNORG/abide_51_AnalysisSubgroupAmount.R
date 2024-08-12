# this script is used to analysis ABIDE subgroup
# Xue-Ru Fan 15 May 2023 @BNU

rm(list=ls())

# load packages
library(ggplot2)
library(reshape2)
library(ggridges)
library(colorspace)
library(dplyr)

# define filefolder
abideDir <- 'E:/研究课题/ABIDE'
dataDir <- file.path(abideDir, "Preprocessed")
analDir <- file.path(abideDir, "Analysis")
plotDir <- file.path(analDir, "Plot")


# get source
setwd(dataDir)
abide <- read.csv("abide_all.csv")
asd <- subset(abide, DX_GROUP == 1)
setwd(analDir)
pam <- read.csv("abide_pam0625.csv")
colnames(pam)[2] <- "Participant"
asd_all <- merge(pam, asd, by = "Participant", all.x = TRUE)

asd.1 <- subset(asd_all, clusterID == 1)
asd.2 <- subset(asd_all, clusterID == 2)

write.csv(asd_all, file.path(analDir, "abide_pam_all0625.csv"), row.names = F)


############################ Part 1: Plot sex distribution #########################################

# for (k in 1:2) {
#   eval(parse(text = paste0("female <- sum(asd.", k, "$SEX == 2)")))
#   eval(parse(text = paste0("male <- sum(asd.", k, "$SEX == 1)")))
#   
#   # 如果只画饼图
#   # sex <- data.frame(c("female", "male"), c(female.1, male.1))
#   # colnames(sex) <- c("Sex", "Number")
#   # ggplot(sex, aes(x = "", y = Number, fill = Sex))
#   
#   # 如果画环形图
#   sex <- data.frame(c("female", "male"), c(0, 0), c(female, male)) #加一列全部为0的假数据
#   colnames(sex) <- c("Sex", "fake", "Number")
#   sex_long <- melt(sex, id = "Sex") #变为长数据
#   per <- paste('(', round(sex$Number/sum(sex$Number) * 100, 1), '%)', sep = '') # 显示百分比
#   label <- paste0(sex$Sex, per, sep = '') # 百分比值对应到各个组
#   
#   sex.pie <- ggplot(sex_long, aes(x = variable, y = value, fill = Sex)) +
#     geom_bar(stat = 'identity', position = 'stack') +
#     coord_polar(theta = "y", start = 0, direction = 1) + # 把现有的柱形图变成饼图
#     xlab("") +
#     ylab("") +
#     theme_ridges() + 
#     theme(legend.position = "none", # without legend
#           axis.text = element_blank(),
#           axis.line = element_blank(),
#           axis.ticks = element_blank(),
#           panel.border = element_blank(),
#           panel.grid = element_blank()) +
#     scale_fill_manual(values = c("#808080", "#d3d3d3"))
#   
#   eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'asd_sub", k,
#                                       "_sex_pie_230526.png')")))
#   
#   ggsave(name, width = 4, height = 4, units = "in", dpi = 500)
#   
# }


############################ Part 2: Plot site distribution ########################################

# colors <- rev(diverging_hcl(17)) #输出n个对比明显的颜色代码

result.1 <- data.frame(table(asd.1$SITE_ID)) # 统计每个站点各有多少人
result.1$group <- "1"
result.2 <- data.frame(table(asd.2$SITE_ID))
result.2$group <- "2"

result.1$per <- (result.1$Freq)/(result.1$Freq+result.2$Freq)
result.2$per <- (result.2$Freq)/(result.1$Freq+result.2$Freq)

result <- rbind(result.1, result.2)
write.csv(result, file.path(analDir, "abide_site2group0625.csv"), row.names = F)

result <- result[, c(1, 3:4)]


# 根据 x 列的值从大到小排序
site <- result.2 %>%
  arrange(desc(result.2$per))

# plot

# modify data class
Per <- as.numeric(result$per)
Group <- as.factor(result$group)
Site <- factor(result$Var1, levels = site$Var1)


# 堆叠条形图
ggplot(result, aes(x = Site, y = Per, fill = Group)) +
  geom_col(position = "stack") +
  scale_y_continuous(label = c("0","25%","50%","75%", "100%")) +
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(legend.position = "none", # without legend
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 12, face = "bold")) +
  scale_fill_manual(values = c("#73A0C6", "#FFB79A"))
name <- file.path(plotDir,'asd_site_distribution_230625.png')
ggsave(name, width = 6, height = 4, units = "in", dpi = 500)



# 画饼状图
# for (k in 1:2) {
#   
#   eval(parse(text = paste0("result <- table(asd.", k, "$SITE_ID)"))) # 统计每个站点各有多少人
#   site <- data.frame(sort(result, decreasing = TRUE))
#   
#   # 如果画环形图
#   site$fake <- rep(0, nrow(site))
#   site <- data.frame(site[, 1], site[, 3], site[, 2])
#   colnames(site) <- c("Site", "fake", "Number")
#   
#   # per <- paste('(', round(site$Number/sum(site$Number) * 100, 1), '%)', sep = '') # 显示百分比
#   # label <- paste0(site$Site, per, sep = '') # 百分比值对应到各个组
#   
#   site_long <- melt(site, id = "Site") #变为长数据
#   
#   site.pie <- ggplot(site_long, aes(x = variable, y = value, fill = Site)) +
#     geom_bar(stat = 'identity', position = 'stack') +
#     coord_polar(theta = "y", start = 0, direction = 1) + # 把现有的柱形图变成饼图
#     xlab("") +
#     ylab("") +
#     theme_ridges() + 
#     theme(legend.position = "right", # without legend
#           axis.text = element_blank(),
#           axis.line = element_blank(),
#           axis.ticks = element_blank(),
#           panel.border = element_blank(),
#           panel.grid = element_blank()) +
#     scale_fill_manual(values = colors)
# 
#   eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'asd_sub", k,
#                                       "_site_pie_230523.pdf')")))
#   
#   ggsave(name, width = 6, height = 4, units = "in", dpi = 500)
#   
# }

############################ Part 3: 统计不同的机型 ################################################

#  添加机型信息
asd_scan <- asd_all[,c(1,2,43)]
# 机型
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-GU_1"), 'SITE_ID'] = "TriTim"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-IU_1"), 'SITE_ID'] = "TriTim"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-OHSU_1"), 'SITE_ID'] = "TriTim"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-UCD_1"), 'SITE_ID'] = "TriTim"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-UCLA_1"), 'SITE_ID'] = "TriTim"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-USM_1"), 'SITE_ID'] = "TriTim"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-NYU_1"), 'SITE_ID'] = "Allegra"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-NYU_2"), 'SITE_ID'] = "Allegra"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-OILH_2"), 'SITE_ID'] = "Skyra"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-EMC_1"), 'SITE_ID'] = "MR750"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-SDSU_1"), 'SITE_ID'] = "MR750"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-BNI_1"), 'SITE_ID'] = "Ingenia"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-ETH_1"), 'SITE_ID'] = "Achieva"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-IP_1"), 'SITE_ID'] = "Achieva"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-KKI_1"), 'SITE_ID'] = "Achieva"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-TCD_1"), 'SITE_ID'] = "Achieva"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-KUL_3"), 'SITE_ID'] = "Achieva Ds"
asd_scan[which(asd_scan$SITE_ID == "ABIDEII-U_MIA_1"), 'SITE_ID'] = "Healthcare"
# 厂家
asd_scan[which(asd_scan$SITE_ID == "TriTim"), 'Scanner'] = "Siemens"
asd_scan[which(asd_scan$SITE_ID == "Allegra"), 'Scanner'] = "Siemens"
asd_scan[which(asd_scan$SITE_ID == "Skyra"), 'Scanner'] = "Siemens"
asd_scan[which(asd_scan$SITE_ID == "MR750"), 'Scanner'] = "GE"
asd_scan[which(asd_scan$SITE_ID == "Ingenia"), 'Scanner'] = "Philips"
asd_scan[which(asd_scan$SITE_ID == "Achieva"), 'Scanner'] = "Philips"
asd_scan[which(asd_scan$SITE_ID == "Achieva Ds"), 'Scanner'] = "Philips"
asd_scan[which(asd_scan$SITE_ID == "Healthcare"), 'Scanner'] = "GE"


asd.1 <- subset(asd_scan, clusterID == 1)
asd.2 <- subset(asd_scan, clusterID == 2)

########## 统计每个机型各有多少人
result.1 <- data.frame(table(asd.1$SITE_ID)) 
result.1$group <- "1"
result.2 <- data.frame(table(asd.2$SITE_ID))
result.2$group <- "2"

result.1$per <- (result.1$Freq)/(result.1$Freq+result.2$Freq)
result.2$per <- (result.2$Freq)/(result.1$Freq+result.2$Freq)

result <- rbind(result.1, result.2)
result <- result[, c(1, 3:4)]


# 根据 x 列的值从大到小排序
site <- result.2 %>%
  arrange(desc(result.2$per))

# plot

# modify data class
Per <- as.numeric(result$per)
Group <- as.factor(result$group)
Site <- factor(result$Var1, levels = site$Var1)

# 堆叠条形图
ggplot(result, aes(x = Site, y = Per, fill = Group)) +
  geom_col(position = "stack") +
  scale_y_continuous(label = c("0","25%","50%","75%", "100%")) +
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(legend.position = "none", # without legend
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 12, face = "bold")) +
  scale_fill_manual(values = c("#73A0C6", "#FFB79A"))
name <- file.path(plotDir,'asd_scanmodel_distribution_230625.png')
ggsave(name, width = 6, height = 4, units = "in", dpi = 500)

##### 统计每个厂家各有多少人
result.1 <- data.frame(table(asd.1$Scanner)) 
result.1$group <- "1"
result.2 <- data.frame(table(asd.2$Scanner))
result.2$group <- "2"

result.1$per <- (result.1$Freq)/(result.1$Freq+result.2$Freq)
result.2$per <- (result.2$Freq)/(result.1$Freq+result.2$Freq)

result <- rbind(result.1, result.2)
result <- result[, c(1, 3:4)]


# 根据 x 列的值从大到小排序
site <- result.2 %>%
  arrange(desc(result.2$per))

# plot

# modify data class
Per <- as.numeric(result$per)
Group <- as.factor(result$group)
Site <- factor(result$Var1, levels = site$Var1)

# 堆叠条形图
ggplot(result, aes(x = Site, y = Per, fill = Group)) +
  geom_col(position = "stack") +
  scale_y_continuous(label = c("0","25%","50%","75%", "100%")) +
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(legend.position = "none", # without legend
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 12, face = "bold")) +
  scale_fill_manual(values = c("#73A0C6", "#FFB79A"))
name <- file.path(plotDir,'asd_scanner_distribution_230625.png')
ggsave(name, width = 6, height = 4, units = "in", dpi = 500)


############################ Part 3: Plot age distribution #########################################

age_long <- data.frame(asd_all$clusterID, asd_all$AGE_AT_SCAN)
colnames(age_long) <- c("Subgroup", "Age")

Age <- as.numeric(age_long$Age)
Subgroup <- as.factor(age_long$Subgroup)
age_long <- data.frame(Subgroup, Age)

age.density <- ggplot(age_long, aes(x = Age, y = Subgroup, fill = Subgroup)) +
  geom_density_ridges(scale = 1.5, alpha = 1) +
  scale_x_continuous(breaks = seq(4, 64, by = 10)) +
  scale_fill_manual(values = c("#4682b4", "#ffa07a")) +
  coord_fixed(ratio = 20) +
  xlab("") +
  ylab("") +
  theme_ridges() + 
  theme(legend.position = "none", # without legend
        axis.text.y = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 12, face = "bold"))

age.density

name <- file.path(plotDir,'asd_age_density_230625.png')
ggsave(name, width = 6, height = 4, units = "in", dpi = 500)

########## statistic analysis
age_analysis <- data.frame(asd_all$clusterID, asd_all$AGE_AT_SCAN)
colnames(age_analysis) <- c("Subgroup", "Age")
####### Shapiro–Wilk Test
g1 <- subset(age_analysis, Subgroup == 1)
g2 <- subset(age_analysis, Subgroup == 2)
g1.age <- shapiro.test(g1$Age)
g2.age <- shapiro.test(g2$Age)
###### Rank Sum Test
wt.g12 <- wilcox.test(g1$Age, g2$Age)


############################ Part 4: Plot IQ distribution #########################################

iq <- asd_all[, c(2, 52:54)]

# transfer to long data
iq_long <- melt(iq, id.vars = "clusterID", value.name = "Score", na.rm = TRUE)
iq_long <- tidyr::unite(iq_long, "Type", clusterID, variable)

Score <- as.numeric(iq_long$Score)
Type <- as.factor(iq_long$Type)
levels(Type)
Type <- ordered(Type, 
                 levels = c("1_FIQ", "2_FIQ", "1_PIQ", "2_PIQ", "1_VIQ","2_VIQ"))
levels(Type)

iq_long <- data.frame(Type, Score)

iq.density <- ggplot(iq_long, aes(x = Score, y = Type, fill = Type)) +
  geom_density_ridges(scale = 1.5, alpha = 1) +
  scale_x_continuous(breaks = seq(50, 160, by = 25)) +
  scale_fill_manual(values = c("#008b8b", "#008b8b", "#f0e68c", "#f0e68c", "#dda0dd", "#dda0dd")) +
  coord_fixed(ratio = 25) +
  xlab("") +
  ylab("") +
  theme_ridges() + 
  theme(legend.position = "none", # without legend
        axis.text.y = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 12, face = "bold"))

iq.density

name <- file.path(plotDir,'asd_iq_density_23625.png')
ggsave(name, width = 6, height = 4, units = "in", dpi = 500)

########## statistic analysis

g1 <- subset(iq, clusterID == 1)
g2 <- subset(iq, clusterID == 2)

###### 正态性检验
st.g1.v <- shapiro.test(na.omit(g1$VIQ))
st.g2.v <- shapiro.test(na.omit(g2$VIQ))
st.g1.p <- shapiro.test(na.omit(g1$PIQ))
st.g2.p <- shapiro.test(na.omit(g2$PIQ))
st.g1.f <- shapiro.test(na.omit(g1$FIQ))
st.g2.f <- shapiro.test(na.omit(g2$FIQ))

###### t Test
t.g12.f <- t.test(na.omit(g1$FIQ), na.omit(g2$FIQ))
t.g12.p <- t.test(na.omit(g1$PIQ), na.omit(g2$PIQ))
t.g12.v <- t.test(na.omit(g1$VIQ), na.omit(g2$VIQ))


############################ Part 5: Plot ADI_research distribution ################################
# 
# colors <- c("#d3d3d3", "#5f9ea0", "#ffa07a")
# 
# for (k in 1:2) {
#   eval(parse(text = paste0("adi.research <- asd.", k, "[, c(2, 57)]")))
#   
#   no <- nrow(subset(adi.research, ADI_R_RSRCH_RELIABLE == 0))
#   yes <- nrow(subset(adi.research, ADI_R_RSRCH_RELIABLE == 1))
#   na <- nrow(adi.research) - no - yes
# 
#   res <- data.frame(c("NA", "YES", "NO"), c(0, 0, 0), c(no, yes, na)) #加一列全部为0的假数据
#   colnames(res) <- c("Type", "fake", "Number")
#   res_long <- melt(res, id = "Type") #变为长数据
#   # per <- paste('(', round(res$Number/sum(res$Number) * 100, 1), '%)', sep = '') # 显示百分比
#   # label <- paste0(res$Type, per) # 百分比值对应到各个组
#   
#   res.pie <- ggplot(res_long, aes(x = variable, y = value, fill = Type)) +
#     geom_bar(stat = 'identity', position = 'stack') +
#     coord_polar(theta = "y", start = 0, direction = 1) + # 把现有的柱形图变成饼图
#     xlab("") +
#     ylab("") +
#     theme_ridges() + 
#     theme(legend.position = "right", # without legend
#           axis.text = element_blank(),
#           axis.line = element_blank(),
#           axis.ticks = element_blank(),
#           panel.border = element_blank(),
#           panel.grid = element_blank()) +
#     scale_fill_manual(values = colors)
#   res.pie
#   
#   eval(parse(text = com_str <- paste0("name <- file.path(plotDir,'asd_sub", k,
#                                       "_adr.research_pie_230523.pdf')")))
#   
#   ggsave(name, width = 6, height = 4, units = "in", dpi = 500)
#   
# }
# 
############################ Part 6: Plot ADI-R distribution #########################################

adr <- asd_all[, c(2, 58:61)]

# transfer to long data
adr_long <- melt(adr, id.vars = "clusterID", value.name = "Score", na.rm = TRUE)
adr_long <- tidyr::unite(adr_long, "Class", clusterID, variable)

Score <- scale(as.numeric(adr_long$Score))
Type <- as.factor(adr_long$Class)

# change order
levels(Type)
Type <- ordered(Type,
                levels = c("1_ADI_R_VERBAL_TOTAL_BV", "2_ADI_R_VERBAL_TOTAL_BV",
                           "1_ADI_R_NONVERBAL_TOTAL_BV", "2_ADI_R_NONVERBAL_TOTAL_BV",
                           "1_ADI_R_SOCIAL_TOTAL_A", "2_ADI_R_SOCIAL_TOTAL_A",
                           "1_ADI_R_RRB_TOTAL_C", "2_ADI_R_RRB_TOTAL_C"))
levels(Type)

adr_long <- data.frame(Type, Score)

adr.density <- ggplot(adr_long, aes(x = Score, y = Type, fill = Type)) +
  geom_density_ridges(scale = 1.5, alpha = 1) +
  # scale_x_continuous(breaks = seq(0, 30, by = 5)) +
  scale_fill_manual(values = c("#008b8b", "#008b8b", "#f0e68c", "#f0e68c", "#db7093", "#db7093",
                               "#4682b4", "#4682b4")) +
  coord_fixed(ratio = 1) +
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(legend.position = "none", # without legend
        axis.text.y = element_text(size = 8, face = "bold"),
        axis.text.x = element_text(size = 12, face = "bold"))
adr.density

name <- file.path(plotDir,'asd_adir_density_230625.png')
ggsave(name, width = 5, height = 4, units = "in", dpi = 500)

########## statistic analysis
g1 <- subset(adr, clusterID == 1)
g2 <- subset(adr, clusterID == 2)
####### Shapiro–Wilk Test
g1.v <- shapiro.test(g1$ADI_R_VERBAL_TOTAL_BV)
g1.n <- shapiro.test(g1$ADI_R_NONVERBAL_TOTAL_BV)
g1.s <- shapiro.test(g1$ADI_R_SOCIAL_TOTAL_A)
g1.r <- shapiro.test(g1$ADI_R_RRB_TOTAL_C)
g2.v <- shapiro.test(g2$ADI_R_VERBAL_TOTAL_BV)
g2.n <- shapiro.test(g2$ADI_R_NONVERBAL_TOTAL_BV)
g2.s <- shapiro.test(g2$ADI_R_SOCIAL_TOTAL_A)
g2.r <- shapiro.test(g2$ADI_R_RRB_TOTAL_C)
###### Rank Sum Test
wt.g12.v <- wilcox.test(na.omit(g1$ADI_R_VERBAL_TOTAL_BV), na.omit(g2$ADI_R_VERBAL_TOTAL_BV))
wt.g12.n <- wilcox.test(na.omit(g1$ADI_R_NONVERBAL_TOTAL_BV), na.omit(g2$ADI_R_NONVERBAL_TOTAL_BV))
wt.g12.s <- wilcox.test(na.omit(g1$ADI_R_SOCIAL_TOTAL_A), na.omit(g2$ADI_R_SOCIAL_TOTAL_A))
wt.g12.r <- wilcox.test(na.omit(g1$ADI_R_RRB_TOTAL_C), na.omit(g2$ADI_R_RRB_TOTAL_C))

############################ Part 7: Plot ADOS distribution #########################################

ados <- asd_all[, c(2, 66:74)]

# arrange 得分
ador_total <- ados[, c(1,2,9)]
ador_total$Total <- ador_total$ADOS_2_TOTAL
ador_total_na <- subset(ador_total, is.na(ador_total$Total) == T)
ador_total_na$Total <- ador_total_na$ADOS_G_TOTAL
x <- subset(ador_total, is.na(ador_total$Total) == F)
ador_total <- rbind(x, ador_total_na)
ador_total <- ador_total[, c(1,4)]

# arrange 得分
ador_soci <- ados[, c(1,4,7)]
ador_soci$Social <- ador_soci$ADOS_2_SOCAFFECT
ador_soci_na <- subset(ador_soci, is.na(ador_soci$Social) == T)
ador_soci_na$Social <- ador_soci_na$ADOS_G_SOCIAL
x <- subset(ador_soci, is.na(ador_soci$Social) == F)
ador_soci <- rbind(x, ador_soci_na)
ador_soci <- ador_soci[, c(1,4)]

# arrange 得分
ador_rrb <- ados[, c(1,5,8)]
ador_rrb$RRB <- ador_rrb$ADOS_2_RRB
ador_rrb_na <- subset(ador_rrb, is.na(ador_rrb$RRB) == T)
ador_rrb_na$RRB <- ador_rrb_na$ADOS_G_STEREO_BEHAV
x <- subset(ador_rrb, is.na(ador_rrb$RRB) == F)
ador_rrb <- rbind(x, ador_rrb_na)
ador_rrb <- ador_rrb[, c(1,4)]


ados <- data.frame(ador_total, ador_soci$Social, ador_rrb$RRB)
colnames(ados)[c(3,4)] <- c("Social", "RRB")


# transfer to long data
ados_long <- melt(ados, id.vars = "clusterID", value.name = "Score", na.rm = TRUE)
ados_long <- tidyr::unite(ados_long, "Class", clusterID, variable)

Score <- scale(as.numeric(ados_long$Score))
Type <- as.factor(ados_long$Class)

# change order
levels(Type)
Type <- ordered(Type,
                levels = c("1_Total", "2_Total", "1_Social", "2_Social", "1_RRB", "2_RRB"))
levels(Type)

ados_long <- data.frame(Type, Score)

ados.density <- ggplot(ados_long, aes(x = Score, y = Type, fill = Type)) +
  geom_density_ridges(scale = 1.5, alpha = 1) +
  # scale_x_continuous(breaks = seq(0, 30, by = 5)) +
  scale_fill_manual(values = c("#008b8b", "#008b8b", "#db7093", "#db7093", "#4682b4", "#4682b4")) +
  coord_fixed(ratio = 1) +
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(legend.position = "none", # without legend
        axis.text.y = element_text(size = 8, face = "bold"),
        axis.text.x = element_text(size = 12, face = "bold"))
ados.density

name <- file.path(plotDir,'asd_ados_density_230625.png')
ggsave(name, width = 5, height = 4, units = "in", dpi = 500)

########## statistic analysis
g1 <- subset(ados, clusterID == 1)
g2 <- subset(ados, clusterID == 2)
####### Shapiro–Wilk Test
g1.r <- shapiro.test(g1$RRB)
g1.s <- shapiro.test(g1$Social)
g1.t <- shapiro.test(g1$Total)
g2.r <- shapiro.test(g2$RRB)
g2.s <- shapiro.test(g2$Social)
g2.t <- shapiro.test(g2$Total)
###### Rank Sum Test
wt.g12.r <- wilcox.test(na.omit(g1$RRB), na.omit(g2$Social))
wt.g12.s <- wilcox.test(na.omit(g1$Social), na.omit(g2$Social))
wt.g12.t <- wilcox.test(na.omit(g1$Total), na.omit(g2$Total))


############################ Part 8: Plot SRS distribution #########################################

srs <- asd_all[, c(2, 84:89)]

# transfer to long data
srs_long <- melt(srs, id.vars = "clusterID", value.name = "Score", na.rm = TRUE)
srs_long <- tidyr::unite(srs_long, "Class", clusterID, variable)

Score <- scale(as.numeric(srs_long$Score))
Type <- as.factor(srs_long$Class)

# change order
levels(Type)
Type <- ordered(Type,
                levels = c("1_SRS_TOTAL_T", "2_SRS_TOTAL_T",
                           "1_SRS_AWARENESS_T", "2_SRS_AWARENESS_T",
                           "1_SRS_COGNITION_T", "2_SRS_COGNITION_T",
                           "1_SRS_COMMUNICATION_T", "2_SRS_COMMUNICATION_T",
                           "1_SRS_MOTIVATION_T", "2_SRS_MOTIVATION_T",
                           "1_SRS_MANNERISMS_T", "2_SRS_MANNERISMS_T"))
levels(Type)

srs_long <- data.frame(Type, Score)

srs.density <- ggplot(srs_long, aes(x = Score, y = Type, fill = Type)) +
  geom_density_ridges(scale = 1.5, alpha = 1) +
  # scale_x_continuous(breaks = seq(0, 30, by = 5)) +
  scale_fill_manual(values = c("#008b8b", "#008b8b", "#f0e68c", "#f0e68c", "#ffd077", "#ffd077",
                               "#ffa500", "#ffa500","#d2691e", "#d2691e", "#4682b4", "#4682b4")) +
  coord_fixed(ratio = 1) +
  xlab("") +
  ylab("") +
  theme_ridges() +
  theme(legend.position = "none", # without legend
        axis.text.y = element_text(size = 8, face = "bold"),
        axis.text.x = element_text(size = 12, face = "bold"))
srs.density

name <- file.path(plotDir,'asd_srs_density_230625.png')
ggsave(name, width = 5, height = 4, units = "in", dpi = 500)

########## statistic analysis
g1 <- subset(srs, clusterID == 1)
g2 <- subset(srs, clusterID == 2)
####### Shapiro–Wilk Test
g1.ma <- shapiro.test(g1$SRS_MANNERISMS_T)
g1.mo <- shapiro.test(g1$SRS_MOTIVATION_T)
g1.cm <- shapiro.test(g1$SRS_COMMUNICATION_T)
g1.cg <- shapiro.test(g1$SRS_COGNITION_T)
g1.aw <- shapiro.test(g1$SRS_AWARENESS_T)
g1.to <- shapiro.test(g1$SRS_TOTAL_T)
g2.ma <- shapiro.test(g2$SRS_MANNERISMS_T)
g2.mo <- shapiro.test(g2$SRS_MOTIVATION_T)
g2.cm <- shapiro.test(g2$SRS_COMMUNICATION_T)
g2.cg <- shapiro.test(g2$SRS_COGNITION_T)
g2.aw <- shapiro.test(g2$SRS_AWARENESS_T)
g2.to <- shapiro.test(g2$SRS_TOTAL_T)
###### Rank Sum Test
###### t Test
t.g12.ma <- t.test(na.omit(g1$SRS_MANNERISMS_T), na.omit(g2$SRS_MANNERISMS_T))
t.g12.mo <- t.test(na.omit(g1$SRS_MOTIVATION_T), na.omit(g2$SRS_MOTIVATION_T))
t.g12.cm <- t.test(na.omit(g1$SRS_COMMUNICATION_T), na.omit(g2$SRS_COMMUNICATION_T))
t.g12.cg <- t.test(na.omit(g1$SRS_COGNITION_T), na.omit(g2$SRS_COGNITION_T))
t.g12.aw <- t.test(na.omit(g1$SRS_AWARENESS_T), na.omit(g2$SRS_AWARENESS_T))
t.g12.to <- t.test(na.omit(g1$SRS_TOTAL_T), na.omit(g2$SRS_TOTAL_T))
