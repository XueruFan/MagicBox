# this demo is used. to generate author list from excel
# for CABIC
# Xur-Ru Fan @BNU office, China, Fri Feb 14 2025

rm(list=ls())

# load packages
packages <- c("stringi", "mgsub", "do", "readxl", "tidyr", "mgsub")
# sapply(packages, install.packages, character.only = TRUE)
sapply(packages, require, character.only = TRUE)

# define filefolder
dataDir <- 'E:/PhDproject/CABIC/Lilei'

# get data
setwd(dataDir)
authInfo <- read_xlsx("AuthorInformation.xlsx")
# 注意，这个文件是经过删减的，原始文件是带有raw后缀的那个。这里删掉了email，并且把有两个单位的分列，
# 修改了表头， 并且对姓名进行了排序处理
authInfo <- authInfo[, c(-1:-2)]

##################################### Affiliations
# transfer to long data
Affi <- authInfo
Affi$order <- seq(1, nrow(Affi))
Affi <- gather(Affi, key = "all", value = "Affiliation", Adress1:Adress2, na.rm = TRUE,
               factor_key = TRUE)
Affi <- Affi[order(Affi$order),]

# delete duplicates 
Affi <- Affi[!duplicated(Affi$Affiliation),]
Affi$Number <- seq(1+228, nrow(Affi)+228) # 这里需要修改从几开始编号

# save result for now
write.xlsx(Affi, "Affi_CABIC.xlsx", rowNames = F)

# replace names
authInfo$Adress1 <- mgsub(authInfo$Adress1, Affi$Affiliation, Affi$Number, fixed = TRUE)
authInfo$Adress2 <- mgsub(authInfo$Adress2, Affi$Affiliation, Affi$Number, fixed = TRUE)



#################################### format for overleaf auth
auths <- paste0(authInfo$Name, "$^{", authInfo$Adress1, ",", authInfo$Adress2, "}$, ")
auths <- Replace(auths,",NA", "")
authall <- NA
for(n in 1:length(auths)){
  authall <- paste0(authall, auths[n])
}
write.xlsx(authall, "Auth_CABIC_overleaf.xlsx", rowNames = F)
# 把文件中的内容直接复制过去，然后删掉第一个NA，然后搜索一下“NA”，把本文作者的单位编号补上

#format for overleaf affi
Affi$Affiliation <- Replace(Affi$Affiliation, "XXXXXXX", "(")
Affi$Affiliation <- Replace(Affi$Affiliation, "YYYYYYY", ")")
affis <- data.frame(paste0("$^{", Affi$Number, "}$", Affi$Affiliation, "\\\\"))
write.xlsx(affis, "Affi_CABIC_overleaf.xlsx", rowNames = F)
# 先把&全部替换成\&，之后复制即可
