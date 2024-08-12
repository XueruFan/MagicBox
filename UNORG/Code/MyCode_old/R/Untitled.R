rm(list=ls())
library(R.matlab)
library(ggraph)
library(igraph)
library(tidyverse)

filepath <- "/Volumes/Xueru/"
setwd(filepath)

mn <-"explore2.mat"
data <- readMat(mn)
data <- data[['X']]

data <- as.data.frame(data)
colnames(data) <- c('level1', 'level2', 'level3')

# transform it to a edge list!
edges_level1_2 <- data %>% select(level1, level2) %>% unique %>% rename(from=level1, to=level2)
edges_level2_3 <- data %>% select(level2, level3) %>% unique %>% rename(from=level2, to=level3)
edge_list=rbind(edges_level1_2, edges_level2_3)
colnames(edge_list) <- c('Source', 'Target')
write.table (edge_list, file ="explore2.csv", sep=",", row.names = F, col.names = T, quote = F)

#####
dimnames(data) <- list(c(1:400))
colnames(data) <- c(1:400)

link = data.frame(from = rep(rownames(data), times = ncol(data)), #起始对象
                  to = rep(colnames(data), each = nrow(data)), #终止对象
                  value = as.vector(data),#起始对象与终止对象之间的相互作用强度
                  stringsAsFactors = FALSE);
del <- which(link$value == 0)
link <- link[-del,]

write.table (link, file ="explore.csv", sep=",", row.names = F, col.names = T, quote = F)