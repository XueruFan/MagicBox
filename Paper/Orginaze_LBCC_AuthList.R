# this demo is used. to generate author list from excel
# for LBCC
# Xur-Ru Fan @Bryup, Denmark, Fri Jul 7 2023

rm(list=ls())

# load packages
packages <- c("stringi", "mgsub", "do", "readxl", "tidyr", "mgsub")
# sapply(packages, install.packages, character.only = TRUE)
sapply(packages, require, character.only = TRUE)

# define filefolder
dataDir <- 'E:/PhDproject/LBCC'
# dataFile <- file.path(dataDir, "Lifespan_Brainchart_Consortium.xlsx")

# get data
setwd(dataDir)
authInfo <- read_xlsx("Lifespan_Brainchart_Consortium.xlsx")
# 注意，这个文件是经过删减的，原始文件是带有raw后缀的那个。这里删掉了没有sign up LBCC的一位作者，
# 修改了表头，另外把和本文作者单位重复的“北师大国重实验室删掉了”

##################################### Author Name
authInfo$Name <- NA
for (n in 1:nrow(authInfo)) {
  if (is.na(authInfo$Middle[n]) == 1){
    authInfo$Name[n] = paste0(authInfo$Firstname[n], " ", authInfo$Surname[n])
  } else {
    authInfo$Name[n] = paste0(authInfo$Firstname[n], " ", authInfo$Middle[n], " ", authInfo$Surname[n])
  }
}

##################################### Affiliations
# transfer to long data
Affi <- authInfo[, c(8, 4:7)]
Affi$order <- seq(1, nrow(Affi))
Affi <- gather(Affi, key = "all", value = "Affiliation", Affiliation1:AdditionalAffiliations, na.rm = TRUE,
               factor_key = TRUE)
Affi <- Affi[order(Affi$order),]

# delete duplicates 
Affi <- Affi[!duplicated(Affi$Affiliation),]
Affi$Number <- seq(1+3, nrow(Affi)+3) # 这里需要修改从几开始编号

# save result for now
write.xlsx(Affi, "Affi_LBCC.xlsx", rowNames = F)

# replace names
authInfo$Affiliation1 <- mgsub(authInfo$Affiliation1, Affi$Affiliation, Affi$Number, fixed = TRUE)
authInfo$Affiliation2 <- mgsub(authInfo$Affiliation2, Affi$Affiliation, Affi$Number, fixed = TRUE)
authInfo$Affiliation3 <- mgsub(authInfo$Affiliation3, Affi$Affiliation, Affi$Number, fixed = TRUE)
authInfo$AdditionalAffiliations <- mgsub(authInfo$AdditionalAffiliations, Affi$Affiliation,
                                         Affi$Number, fixed = TRUE)



#################################### format for overleaf auth
auths <- paste0(authInfo$Name, "$^{", authInfo$Affiliation1, ",", 
                authInfo$Affiliation2, ",", authInfo$Affiliation3, ",",
                authInfo$AdditionalAffiliations, "}$, ")
auths <- Replace(auths,",NA", "")
authall <- NA
for(n in 1:length(auths)){
  authall <- paste0(authall, auths[n])
}
write.xlsx(authall, "Auth_LBCC_overleaf.xlsx", rowNames = F)
# 把文件中的内容直接复制过去，然后删掉第一个NA，然后搜索一下“NA”，把本文作者的单位编号补上

#format for overleaf affi
Affi$Affiliation <- Replace(Affi$Affiliation, "XXXXXXX", "(")
Affi$Affiliation <- Replace(Affi$Affiliation, "YYYYYYY", ")")
affis <- data.frame(paste0("$^{", Affi$Number, "}$", Affi$Affiliation, "\\\\"))
write.xlsx(affis, "Affi_LBCC_overleaf.xlsx", rowNames = F)
# 先把&全部替换成\&，之后复制即可