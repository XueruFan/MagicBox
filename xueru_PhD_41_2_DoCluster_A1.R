# this script is used to do ABIDE 1 cluster (age 6-17.9 asd male only)
# Xue-Ru Fan 25 April 2023 @BNU

rm(list=ls())

packages <- c("cluster", "clValid", "fpc", "tidyr", "ggplot2", "randomForest")
# sapply(packages,install.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

# abideDir <- '/Volumes/Xueru/PhDproject/ABIDE' # MAC
abideDir <- 'E:/PhDproject/ABIDE' # Windows
dataDir <- file.path(abideDir, "Preprocessed")
resDir <- file.path(abideDir, "Analysis/Cluster")
plotDir <- file.path(abideDir, "Plot/RankK2_Male")
date <- "240225"

abide_centile <- read.csv(file.path(dataDir, paste0("abide_1_centile_dev_", date, ".csv")))

set.seed(12345)

dx_group <- "ASD"
sex_group <- "Male"
k <- 2 # 确定分2类

for (dx in dx_group){
  eval(parse(text = paste0(dx, "_centile <- subset(abide_centile, dx == '", dx, "')")))
  
  for (sex in sex_group){
    eval(parse(text = paste0(dx, "_centile_", sex, " <- subset(", dx, "_centile, sex == '", sex,
                             "')")))
    # 有4个ASD男性被去掉了，找到他们
    # rows_with_na <- apply(ASD_centile_Male, 1, function(x) any(is.na(x)))
    # na_rows <- ASD_centile_Male[rows_with_na, ]
    # 去掉他们
    eval(parse(text = paste0(dx, "_centile_", sex, " <- na.omit(", dx, "_centile_", sex,
                             "[, -2:-6])")))

    eval(parse(text = paste0("data <- ", dx, "_centile_", sex, "[, -1]")))
    
    
    # do cluster
    result <- pam(data, k, keep.diss = TRUE, metric = "euclidean", stand = FALSE)
    
    # 使用随机森林评估特征重要性
    # 准备数据，聚类结果作为因变量
    data$cluster = as.factor(result$clustering)
    set.seed(123) # 为了可重现性
    rf_model = randomForest(x = data[, -ncol(data)], y = data$cluster, importance = TRUE)
    feature_importance <- importance(rf_model) # 获取特征重要性
    # 对特征重要性得分进行降序排列
    # 注意：importance() 函数返回的是一个矩阵，其中行表示特征，列表示不同类型的重要性度量（比如平均准确率下降等）
    # 这里假设我们关注的是 MeanDecreaseAccuracy（平均准确度降低），这通常是默认的重要性度量
    sorted_indices <- order(feature_importance[, "MeanDecreaseAccuracy"], decreasing = TRUE)
    # 使用排序后的索引来获取排序后的特征和它们的重要性得分
    sorted_feature_importance <- feature_importance[sorted_indices, ]
    # 将特征重要性数据框转换为长格式，适用于ggplot2
    feature_importance_long <- data.frame(Feature = rownames(sorted_feature_importance),
                                          Importance = sorted_feature_importance[, "MeanDecreaseAccuracy"])
    
    # 使用ggplot2绘制条形图
    plot_imoport <- ggplot(feature_importance_long, aes(x = reorder(Feature, Importance), y = Importance)) +
      geom_bar(stat = "identity", fill = "#66cdaa") +
      coord_flip() +  # 翻转坐标轴，使特征名称更容易阅读
      theme_minimal() +  # 使用简洁的主题
      labs(title = "使用随机森林模型进行特征重要性评估",
           x = "分类特征",
           y = "特征重要性得分") +
      theme(plot.title = element_text(hjust = 0.5), # 标题居中
            axis.title.x = element_text(size = 12, face = "bold"),
            axis.title.y = element_text(size = 12, face = "bold"),
            axis.text.x = element_text(angle = 45, hjust = 1))  # x轴标签倾斜，以防重叠
    
    # save plot
    name <- file.path(plotDir, paste0("abide_1_", dx, "_pamK2_", sex, "_dev_Rank_", date, ".png"))
    ggsave(name, width = 8, height = 8, units = "in", dpi = 500)
    
    # save rank
    eval(parse(text = paste0("write.csv(sorted_feature_importance, file.path(resDir, 'abide_1_", dx,
                             "_pamK2_", sex, "_dev_Rank_", date, ".csv'))")))
  
    cluster.group <- result$clustering
    eval(parse(text = paste0("pam_group <- cbind(cluster.group, ", dx, "_centile_", sex, ")")))
    colnames(pam_group)[1] <- "clusterID"
    eval(parse(text = paste0("write.csv(pam_group, file.path(resDir, 'abide_1_", dx, "_pamK2_", sex,
                             "_dev_Cluster_", date, ".csv'), row.names = F)")))
  }
}