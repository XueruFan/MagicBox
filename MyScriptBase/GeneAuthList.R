# this demo is used. to generate author list from excel
# for LBCC
# Xur-Ru Fan @Bryup, Denmark, Fri Jul 7 2023

rm(list=ls())

# load packages
packages <- c("stringi", "mgsub", "do")
# sapply(packages, install.packages, character.only = TRUE)
sapply(packages, require, character.only = TRUE)

# define filefolder
dataDir <- '/Users/xuerufan/Desktop'
dataFile <- file.path(dataDir, "authorofLBCC.xlsx")

# get data
setwd(dataDir)
authInfo <- read_xlsx("authorofLBCC.xlsx")

# Author Name
authInfo$Name <- NA
for (n in 1:nrow(authInfo)) {
  if (is.na(authInfo$Middle[n]) == 1){
    authInfo$Name[n] = paste0(authInfo$Firstname[n], " ", authInfo$Surname[n])
  } else {
    authInfo$Name[n] = paste0(authInfo$Firstname[n], " ", authInfo$Middle[n], " ", authInfo$Surname[n])
  }
}

# Affiliations
# transfer to long data
Affi <- authInfo[, c(8, 4:7)]
Affi$order <- seq(1, nrow(Affi))
Affi <- gather(Affi, key = "all", value = "Affiliation", Affiliation1:AdditionalAffiliations, na.rm = TRUE,
               factor_key = TRUE)
Affi <- Affi[order(Affi$order),]
# delete duplicates 
Affi <- Affi[!duplicated(Affi$Affiliation),]
Affi$Number <- seq(1+25, nrow(Affi)+25)

# replace names
authInfo$Affiliation1 <- mgsub(authInfo$Affiliation1, Affi$Affiliation, Affi$Number)
authInfo$Affiliation2 <- mgsub(authInfo$Affiliation2, Affi$Affiliation, Affi$Number)
authInfo$Affiliation3 <- mgsub(authInfo$Affiliation3, Affi$Affiliation, Affi$Number)
authInfo$AdditionalAffiliations <- mgsub(authInfo$AdditionalAffiliations, Affi$Affiliation, Affi$Number)

#save result for now
write.csv(Affi, "Affi.csv", row.names = F)

# format for overleaf auth
auths <- paste0(authInfo$Name, "$^{", authInfo$Affiliation1, ",", 
                authInfo$Affiliation2, ",", authInfo$Affiliation3, ",",
                authInfo$AdditionalAffiliations, "}$, ")
auths <- Replace(auths,",NA", "")
authall <- NA
for(n in 1:length(auths)){
  authall <- paste0(authall, auths[n])
}
write.csv(authall, "authall.csv", row.names = F)

#format for overleaf affi
Affi$Affiliation <- Replace(Affi$Affiliation, "XXXXXXX", "(")
Affi$Affiliation <- Replace(Affi$Affiliation, "YYYYYYY", ")")
affis <- data.frame(paste0("$^{", Affi$Number, "}$", Affi$Affiliation, "\\"))
write.csv(affis, "affiall.csv", row.names = F)
