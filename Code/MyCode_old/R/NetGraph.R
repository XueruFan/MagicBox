rm(list=ls())
library(R.matlab)
library(dplyr)

filepath <- "/Volumes/Xueru/group";
setwd(filepath)

parcel <- 400; # number of parcels
t <- "neg"; # type of EC

mn <- print(paste(parcel, "p_EC_groupmean.mat", sep = ""));
databag <- readMat(mn);

fn <- print(paste("mean.EC.", t, ".threshold", sep = ""));
data <- databag[[fn]];

dimnames(data) <- list(c(1:parcel));
colnames(data) <- c(1:parcel);

link = data.frame(from = rep(rownames(data), times = ncol(data)), #起始对象
                  to = rep(colnames(data), each = nrow(data)), #终止对象
                  value = as.vector(data),#起始对象与终止对象之间的相互作用强度
                  stringsAsFactors = FALSE);
# 挑选出列名为value中元素为0的行数
del <- which(link$value == 0)
# 删除这些行
link <- link[-del,]

write.table (link, file ="400p_neg_EC_threshold_edge.csv", sep=",", row.names = F, col.names = T, quote = F)

vi = c(1:31,201:230);
so = c(32:68,231:270);
do = c(69:91,271:293);
ve = c(92:113,294:318);
li = c(114:126,319:331);
fr = c(127:148,332:361);
de = c(149:200,362:400);

# 挑选出列名为from中元素为x的分区行数
link$Type <- 0

for (n in vi){ 
  link$Type[link$from == n] = "Visual"
}

for (n in so){ 
  link$Type[link$from == n] = "Somatomotor"
}

for (n in do){ 
  link$Type[link$from == n] = "DorsalAttention"
}
for (n in ve){ 
  link$Type[link$from == n] = "VentralAttention"
}
for (n in li){ 
  link$Type[link$from == n] = "Limbic"
}
for (n in fr){ 
  link$Type[link$from == n] = "Frotoparietal"
}
for (n in de){ 
  link$Type[link$from == n] = "Default"
}

node <- data.frame(link$from, link$from, link$Type)
colnames(node) <- c("Id", "Label", "Type")

write.table (node, file ="400p_pos_EC_threshold_node.csv", sep=",", row.names = F, col.names = T, quote = F)
