# 本代码用来统计绘图旅行者们每次MRI扫描的情况
# 范雪如 Xue-Ru Fan 2024/5/28 @ Beijing Normal University

############################## 加载必要的包和数据文件 ##############################################
rm(list=ls())
library(ggplot2)
library(dplyr)
library(lubridate)
library(patchwork)
library(do)

filefolder <- "E:/PhDproject/3RB2/DataAnalysis"
setwd(filefolder)
TestDate <- read.csv("TestDate.csv")
BasicInfo <- read.csv("BasicInfo.csv")

############################## 整理原始数据信息 ####################################################

colnames(TestDate)[2] <- "TT" # 列名不能是T，T有特殊含义
# 重新排序TestDate的扫描次序
TestDate_clean <- TestDate %>%
  filter(Site != "H") %>% # 删去H机器的信息
  filter(!(P == 22 & Site == "J" & Date == "20240108")) %>% # 删去P22的第一次J扫描信息
  arrange(P, TT) %>%
  group_by(P) %>%
  mutate(MT = row_number()) %>% # MT是第几次扫描
  ungroup()
TestDate_clean <- subset(TestDate_clean, select = -TT)

# 按出生日期排序并生成新的被试编号
BasicInfo_new <- BasicInfo %>%
  arrange(desc(BirthDate)) %>%
  mutate(NP = row_number())

# 合并两个数据框
MergedData <- TestDate_clean %>%
  left_join(BasicInfo_new, by = "P")


# 计算年龄并添加Age列
MergedData <- MergedData %>%
  mutate(BirthDate = ymd(BirthDate),
         Date = ymd(Date),
         Age = round(interval(BirthDate, Date) / years(1), 2))

# 添加Interval_days列，计算每次测试和第一次测试之间的年龄差距（天数）
MergedData <- MergedData %>%
  group_by(P) %>%
  mutate(Interval_days = time_length(interval(first(Date), Date), "days")) %>%
  ungroup()

# 添加Interval_gap列，计算每次测试和上一次测试之间的年龄差距（天数）
MergedData <- MergedData %>%
  group_by(P) %>%
  mutate(Interval_gap = time_length(interval(lag(Date), Date), "days")) %>%
  ungroup()

# 添加AgeBase列，表示每个被试在MT=1时的年龄
MergedData <- MergedData %>%
  group_by(NP) %>%
  mutate(AgeBase = first(Age)) %>%
  ungroup()

# 根据每个被试的测试次数多-少、测试总天数、第一次测试年龄小-大，给被试生成排序编号Rank
MergedData <- MergedData %>%
  group_by(P) %>%
  mutate(
    Total_Test = last(MT), # 总测试次数
    Total_Interval = last(Interval_days),  # 测试总天数
  ) %>%
  ungroup() %>%
  arrange(AgeBase, Total_Test, Total_Interval) %>%
  mutate(Rank = dense_rank(interaction(AgeBase, Total_Test, Total_Interval))) %>%
  arrange(P)  # 按被试编号和测试日期恢复原始顺序

##### 本研究去掉了只有一次扫描的被试
MergedData_claen <- MergedData %>%
  filter(!Total_Test == 1)


############################## 画扫描时间间隔图 ####################################################

# ####### 按照第一次扫描的年龄排序
# ggplot(MergedData, aes(x = Interval_days, y = AgeBase, color = Site, group = P)) +
#   coord_fixed(ratio = 12, xlim = c(0, 160), ylim = c(20, 35)) +
#   geom_line(color = "lightgray", size = 1.5, alpha = 0.5) +
#   geom_point(size = 3) +
#   scale_color_manual(values = c("#86b5a1", "#e47159", "#7976a2", "#b95a58", "#3d5c6f", "#f9ae78",
#                                 "#963f5e", "#4282c6", "#00a391")) +
#   labs(x = "", y = "", color = "Scanner Index") +
#   scale_x_continuous(breaks = seq(0, 160, 40)) +
#   scale_y_continuous(breaks = seq(20, 35, 5)) +
#   theme_minimal() +
#   theme(panel.grid.minor = element_blank(),
#         legend.key.size = unit(1.5, 'lines'),  # 调整图例键的大小
#         legend.text = element_text(size = 12),  # 调整图例文本的大小
#         legend.title = element_text(size = 14), # 调整图例标题的大小
#         axis.text = element_text(size = 14)) + # 调整坐标轴刻度文字的大小
#   guides(color = guide_legend(override.aes = list(size = 4)))  # 调整图例中点的大小
# 
# filename <- 'E:/Documents/Work/文章投稿/3RB/Figure/elements/MRIscanInterval_byAge.png'
# ggsave(filename, width = 8, height = 8, units = "in", dpi = 300)


####### 按照每个被试的测试次数多-少、被试年龄大-小的顺序
ggplot(MergedData_claen, aes(x = Interval_days, y = Rank, color = Site, group = P)) +
  # coord_fixed(ratio = 5, xlim = c(0, 160), ylim = c(0, 40)) +
  coord_fixed(ratio = 5, xlim = c(0, 160), ylim = c(6, 40)) +
  geom_line(color = "lightgray", size = 2, alpha = 0.5) +
  geom_point(size = 5, alpha = 0.9) +
  scale_color_manual(values = c("#86b5a1", "#e47159", "#7976a2", "#b95a58", "#3d5c6f", "#f9ae78",
                                "#963f5e", "#4282c6", "#00a391")) +
  labs(x = "", y = "", color = "") +
  scale_x_continuous(breaks = seq(0, 160, 40)) + 
  scale_y_continuous(breaks = seq(6, 40, 10)) +
  theme_minimal() +
  theme(panel.grid.minor = element_line(linewidth = 0.3),
        panel.grid.major = element_line(linewidth = 0.7),  # 设置主要网格线粗细
        legend.key.size = unit(1.5, 'lines'),  # 调整图例键的大小
        legend.text = element_text(size = 14),  # 调整图例文本的大小
        legend.title = element_text(size = 18), # 调整图例标题的大小
        # legend.position = c(.65,.11),  # 将图例放在下方
        # legend.direction = "horizontal",  # 水平排列图例
        legend.position = c(.9, .4),
        axis.title = element_text(size = 14),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size = 18)) + # 调整坐标轴刻度文字的大小
  guides(color = guide_legend(override.aes = list(size = 4)))  # 调整图例中点的大小

filename <- 'E:/Documents/Work/文章投稿/3RB/Figure/elements/MRIscanInterval_byInterval.png'
ggsave(filename, width = 8, height = 8, units = "in", dpi = 300)



############################## 画志愿者第一次扫描时的年龄图 ################################

# # 过滤出 MT = 1 时的 AgeBase 数据
# # MergedData$MT <- as.character(MergedData$MT)
# age_base_data <- subset(MergedData, MT == 1)
# age_base_data <- age_base_data[, c("AgeBase", "Sex")]
# age_base_data$AgeBase <- floor(age_base_data$AgeBase)
# 
# ggplot(age_base_data, aes(x = AgeBase, fill = Sex)) +
#   coord_fixed(ratio = .5, xlim = c(19.5, 33.5), ylim = c(0, 10)) + 
#   geom_histogram(binwidth = 1, position = "stack", color = "lightgray", size = 1, alpha = 0.8) +
#   scale_x_continuous(breaks = seq(20, 34, 2)) +
#   scale_y_continuous(breaks = seq(0, 10, 2)) +
#   scale_fill_manual(values = c("Male" = "#3d5c6f", "Female" = "#b95a58")) +  # 自定义颜色
#   theme_minimal() +
#   labs(x = "", y = "") +
#   theme(legend.position = c(0.88, .83),  # 调整图例位置
#         legend.background = element_rect(fill = alpha(NA, 0.5), color = NA),  # 设置图例背景透明度并去掉黑框
#         axis.title = element_blank(),
#         axis.text.y = element_text(size = 14),
#         axis.text.x = element_text(size = 14),
#         # panel.grid.minor.y = element_blank(),
#         # panel.grid.minor.x = element_blank(),
#         panel.grid.major = element_line(linewidth = 0.2),  # 设置主要网格线粗细
#         panel.grid.minor = element_blank(),  # 保持次要网格线为空白
#         legend.key.size = unit(1.5, 'lines'),  # 调整图例键的大小
#         legend.text = element_text(size = 16),  # 调整图例文本的大小
#         legend.title = element_blank() # 调整图例标题的大小
#   )
# 
# filename <- 'E:/Documents/Work/文章投稿/3RB/Figure/elements/MRIparticipant_1stScan.png'
# ggsave(filename, width = 8, height = 4, units = "in", dpi = 300)



############################## 画志愿者的性别饼图 ################################

age_base_data <- subset(MergedData_claen, MT == 1)
age_base_data <- age_base_data[, c("AgeBase", "Sex")]
# age_base_data$AgeBase <- floor(age_base_data$AgeBase)
sex_data <- age_base_data[, "Sex"]

gender_counts <- as.data.frame(table(sex_data))
colnames(gender_counts) <- c("Sex", "Count")

ggplot(gender_counts, aes(x = "", y = Count, fill = Sex)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar("y", start = 0) +
  scale_fill_manual(values = c("Male" = "#3a7c63", "Female" = "#ea593b")) +
  # geom_text(aes(label = paste0(Sex, "\nN = ", Count, " (", round(Count/sum(Count)*100, 1), "%)")),
  #           color = "white", 
  #           size = 5,  # 适当减小字号
  #           fontface = "bold",
  #           lineheight = 1,  # 调整行间距
  #           nudge_x = ifelse(gender_counts$Sex == "Male", 0.1, -0.05),  # 水平偏移
  #           nudge_y = ifelse(gender_counts$Sex == "Male", -6.5, -0.1)) +   # 垂直偏移 
  theme_void() +
  theme(legend.position = "none")

filename <- 'E:/Documents/Work/文章投稿/3RB/Figure/elements/MRIparticipant_Sex.png'
ggsave(filename, width = 4, height = 4, units = "in", dpi = 300)



############################## 计算 AgeBase 的平均数和标准差 #######################################

age_base_summary <- age_base_data %>%
  summarize(
    mean_AgeBase = round(mean(AgeBase, na.rm = TRUE), 2),
    sd_AgeBase = round(sd(AgeBase, na.rm = TRUE), 2)
  )



############################## 画教育水平的饼图 ################################

Edu <- read.csv("Education.csv")
MergedData_claen <- subset(MergedData_claen, MT == 1)
MergedData_claen <- merge(MergedData_claen, Edu, by = "P", all.x = T)
Edu_data <- data.frame(MergedData_claen[, c("Level")])
Edu_counts <- as.data.frame(table(Edu_data))
colnames(Edu_counts) <- c("EduLev", "Count")

Edu <- data.frame("EduLev" = c("Undergraduate", "Graduate"), "Count" = c(12, 23))
Edu <- Edu %>%
  mutate(EduLev = factor(EduLev, levels = c("Undergraduate", "Graduate")))

ggplot(Edu, aes(x = "", y = Count, fill = EduLev)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar("y", start = 0) +
  scale_fill_manual(values = c("Undergraduate" = "#e59e03", "Graduate" = "#4977ba")) +
  theme_void() +
  theme(legend.position = "none")

filename <- 'E:/Documents/Work/文章投稿/3RB/Figure/elements/MRIparticipant_Edu.png'
ggsave(filename, width = 4, height = 4, units = "in", dpi = 300)



############################## 画两次扫描间隔的图 ##########################################

interval_days <- MergedData %>%
  filter(!is.na(Interval_gap))
interval_days <- interval_days[, "Interval_gap"]

ggplot(interval_days, aes(x = Interval_gap)) +
  coord_fixed(ratio = 1.5, xlim = c(2, 73), ylim = c(0, 30)) + 
  geom_histogram(binwidth = 1, fill = "#4977ba", color = "lightgray", size = .5, alpha = 1) +
  scale_x_continuous(breaks = seq(2, 74, 12)) +
  scale_y_continuous(breaks = seq(0, 30, 15)) +
  theme_minimal() +
  labs(x = "", y = "") +
  theme(axis.title = element_blank(),
        axis.text.y = element_text(size = 14),
        axis.text.x = element_text(size = 14),
        panel.grid.major = element_line(linewidth = 0.7),  # 设置主要网格线粗细
        panel.grid.minor = element_line(linewidth = 0.3))  # 保持次要网格线为空白

filename <- 'E:/Documents/Work/文章投稿/3RB/Figure/elements/MRIparticipant_ScanInterval.png'
ggsave(filename, width = 6, height = 4, units = "in", dpi = 300)



############################## 保存处理好的表格 ####################################################
write.csv(MergedData, file.path(filefolder, "MRIdetailInfo.csv"), row.names = F)
