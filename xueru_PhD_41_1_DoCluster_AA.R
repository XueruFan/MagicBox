# this script is used to do ABIDE cluster (age 6-17.9 only)
# Xue-Ru Fan 25 April 2023 @BNU

rm(list=ls())

packages <- c("randomForest")
# sapply(packages,install.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

# abideDir <- '/Volumes/Xueru/PhDproject/ABIDE' # MAC
abideDir <- 'E:/PhDproject/ABIDE' # Windows
dataDir <- file.path(abideDir, "Preprocessed")
resDir <- file.path(abideDir, "Analysis/Cluster")
plotDir <- file.path(abideDir, "Plot/RankK2_Male")
date <- "240225"

abide_centile <- read.csv(file.path(dataDir, paste0("abide_centile_dev_", date, ".csv")))

set.seed(12345)

dx_group <- "ASD"
sex_group <- "Male"
# k <- 2 # 确定分2类

######################## Part 1: Cluster for male ##############################################
# 根据脑形态测量指标对两组人进行聚类分析

for (dx in dx_group){
  # dx <- "ASD"
  eval(parse(text = paste0(dx, "_centile <- subset(abide_centile, dx == '", dx, "')")))
  
  for (sex in sex_group){
    # sex <- "Male"
    eval(parse(text = paste0(dx, "_centile_", sex, " <- subset(", dx, "_centile, sex == '", sex,
                             "')")))
    # 有4个ASD男性被去掉了，找到他们
    # rows_with_na <- apply(ASD_centile_Male, 1, function(x) any(is.na(x)))
    # na_rows <- ASD_centile_Male[rows_with_na, ]
    # 去掉他们
    eval(parse(text = paste0(dx, "_centile_", sex, " <- na.omit(", dx, "_centile_", sex,
                             "[, -2:-6])")))

    eval(parse(text = paste0("data <- ", dx, "_centile_", sex, "[, -1]")))
    
    
    ############## do cluster for choosing k
    
    # dis_type <- "euclidean"
    # 
    # # # set up for pam analysis
    # set.seed(date)
    # max <- 50
    # 
    # # empty dataframe to save data later
    # pam_result <- data.frame(c(2:max))
    # colnames(pam_result) <- "NumberOfClusters"
    # 
    # for (k in 2:max) {
    #   result <- pam(data, k, keep.diss = TRUE, metric = dis_type, stand = FALSE)
    # 
    #   # check result
    #   cluster.group <- result$clustering # 数据点所属的簇编号
    #   # centers.group <- result$medoids # 聚类质心
    #   distance.group <- result$diss #距离矩阵
    # 
    #   # inside evaluation
    #   # 平均轮廓系数(高轮廓值的对象被认为分到了理想的聚类，低的对象可能是离群值)
    #   silhouette.group <- summary(silhouette(cluster.group, distance.group))$avg.width
    # 
    #   # Dunn指数（簇内样本之间距离与簇间距离之间比，越大越好）
    #   dunn.group <- dunn(distance = distance.group, clusters = cluster.group)
    # 
    #   # save result
    #   pam_result[k-1, 2] = silhouette.group
    #   pam_result[k-1, 3] = dunn.group
    # 
    # }
    # 
    # colnames(pam_result)[2:3] <- c("silhouette", "dunn")
    # 
    # 
    # ############## pam_result
    # 
    # # transfer to long data
    # pam_result_long <- gather(pam_result, key = "Index", value = "Value", silhouette:dunn,
    #                           factor_key = TRUE)
    # 
    # # plot
    # ggplot(data = pam_result_long, mapping = aes(x = NumberOfClusters, y = Value, color = Index)) +
    #   geom_line()
    
    # 
    # # do cluster
    # result <- pam(data, k, keep.diss = TRUE, metric = "euclidean", stand = FALSE)
    

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
    name <- file.path(plotDir, paste0(dx, "_pamK2_", sex, "_dev_Rank_", date, ".png"))
    ggsave(name, width = 8, height = 8, units = "in", dpi = 500)
    
    # save rank
    eval(parse(text = paste0("write.csv(sorted_feature_importance, file.path(resDir, '", dx,
                             "_pamK2_", sex, "_dev_Rank_", date, ".csv'))")))
    
    # save result
    cluster.group <- result$clustering # 数据点所属的簇编号
    eval(parse(text = paste0("pam_group <- cbind(cluster.group, ", dx, "_centile_", sex, ")")))
    colnames(pam_group)[1] <- "clusterID"
    eval(parse(text = paste0("write.csv(pam_group, file.path(resDir, '", dx, "_pamK2_", sex,
                             "_dev_Cluster_", date, ".csv'), row.names = F)")))
  }
}
