#############################################

# calculate DC icc 
rm(list=ls())
library(lme4)
threshold <- "OMST";

# LongTerms
filefolder <- print(paste("/Users/fanxueru/Library/Mobile Documents/com~apple~CloudDocs/project/hcp/",threshold,"/8run/",sep = ""));
workdir <- print(paste(filefolder,'DC/CSV/',sep = ""));
setwd(workdir)

LT <- c(1:2);

for (t in LT){
  file <- print(paste("LT",t,"dc.csv",sep = ""))
  fname <- paste0(workdir, file)
  DC <- read.csv(fname,header = FALSE)
  
  mydata <- t(DC);    
  colnames(mydata)=mydata[1,];
  mydata <- mydata[-1,-1];
  mydata <- as.data.frame(mydata);
  colnames(mydata)[6:405] <- c(1:400);
  
  idnew <- as.character(mydata$idnew);
  age <- as.numeric(as.character(mydata$age));
  gender <- as.factor(mydata$gender);
  TestRetestInterval <- as.numeric(as.character(mydata$TestRetestInterval));
  
  ICC <- matrix(0,nrow=400,ncol=1);
  Vr <- matrix(0,nrow=400,ncol=1);
  sigmaP2 <- matrix(0,nrow=400,ncol=1);
  sigmaE2 <- matrix(0,nrow=400,ncol=1);
  sigmaP2_over_Vr <- matrix(0,nrow=400,ncol=1);
  sigmaE2_over_Vr <- matrix(0,nrow=400,ncol=1);
  
  for (i in 6:405){
    i <- as.character(i-5);
    DC <- mydata[, i];
    newdata <- data.frame(idnew, age, gender, TestRetestInterval,DC);
    newdata$DC <- as.numeric(as.character(newdata$DC));
    vr <- var(newdata$DC);
    #find outliers
    outliers <- newdata$DC %in% boxplot.stats(newdata$DC)$out
    #exclude outliers
    newdata <- newdata[!outliers,]
    try({ mymodel <- lmer(DC ~ age * gender + TestRetestInterval + (1|idnew) ,data=newdata, REML=FALSE);
    output <- summary(mymodel);
    df_var <- data.frame(output$varcor);
    a <- df_var[1,4];
    b <- df_var[2,4];
    c <- df_var[1,4]+df_var[2,4];
    icc <- a/c;
    i <- as.numeric(i);
    ICC[i,1] <- icc;
    Vr[i,1] <- vr;
    sigmaP2[i,1] <- a;
    sigmaE2[i,1] <- b;
    sigmaP2_over_Vr[i,1] <- a/vr;
    sigmaE2_over_Vr[i,1] <- b/vr;
    })
  }
  DCicc <- data.frame(ICC,Vr,sigmaP2,sigmaE2,sigmaP2_over_Vr,sigmaE2_over_Vr);
  iccfile <- print(paste(filefolder,'DC/ICC/dcICC_LT',t,".csv",sep = ""));
  write.csv (DCicc, file =iccfile, row.names = FALSE, col.names = FALSE)
}

# ShortTerms
filefolder <- print(paste("/Users/fanxueru/Library/Mobile Documents/com~apple~CloudDocs/project/hcp/",threshold,"/8run/",sep = ""));
workdir <- print(paste(filefolder,'DC/CSV/',sep = ""));
setwd(workdir)

ShortTerm <- c(1:2);

for (v in ShortTerm){
  file <- print(paste("ST",v,"dc.csv",sep = ""))
  fname <- paste0(workdir, file)
  DC <- read.csv(fname,header = FALSE)
  
  mydata <- t(DC);    
  colnames(mydata)=mydata[1,];
  mydata <- mydata[-1,-1];
  mydata <- as.data.frame(mydata);
  colnames(mydata)[6:405] <- c(1:400);
  
  idnew <- as.character(mydata$idnew);
  age <- as.numeric(as.character(mydata$age));
  gender <- as.factor(mydata$gender);
  
  ICC <- matrix(0,nrow=400,ncol=1);
  Vr <- matrix(0,nrow=400,ncol=1);
  sigmaP2 <- matrix(0,nrow=400,ncol=1);
  sigmaE2 <- matrix(0,nrow=400,ncol=1);
  sigmaP2_over_Vr <- matrix(0,nrow=400,ncol=1);
  sigmaE2_over_Vr <- matrix(0,nrow=400,ncol=1);
  
  for (i in 6:405){
    i <- as.character(i-5);
    DC <- mydata[, i];
    newdata <- data.frame(idnew, age, gender,DC);
    newdata$DC <- as.numeric(as.character(newdata$DC));
    vr <- var(newdata$DC);
    #find outliers
    outliers <- newdata$DC %in% boxplot.stats(newdata$DC)$out
    #exclude outliers
    newdata <- newdata[!outliers,]
    try({ mymodel <- lmer(DC ~ age * gender + (1|idnew) ,data=newdata, REML=FALSE);
    output <- summary(mymodel);
    df_var <- data.frame(output$varcor);
    a <- df_var[1,4];
    b <- df_var[2,4];
    c <- df_var[1,4]+df_var[2,4];
    icc <- a/c;
    i <- as.numeric(i);
    ICC[i,1] <- icc;
    Vr[i,1] <- vr;
    sigmaP2[i,1] <- a;
    sigmaE2[i,1] <- b;
    sigmaP2_over_Vr[i,1] <- a/vr;
    sigmaE2_over_Vr[i,1] <- b/vr;
    })
  }
  DCicc <- data.frame(ICC,Vr,sigmaP2,sigmaE2,sigmaP2_over_Vr,sigmaE2_over_Vr);
  iccfile <- print(paste(filefolder,'DC/ICC/dcICC_ST',v,".csv",sep = ""));
  write.csv (DCicc, file =iccfile, row.names = FALSE, col.names = FALSE)
}

###############################################################
# paired t-test of zDCicc

rm(list = ls())
threshold <- "OMST";

filefolder <- print(paste("/Users/fanxueru/Library/Mobile Documents/com~apple~CloudDocs/project/hcp/",threshold,"/8run/",sep = ""));
workdir <- print(paste(filefolder,'DC/ICC/',sep = ""));
setwd(workdir)
zICCdc <- read.csv("zICCdc.csv",header = FALSE)
test_dc <- matrix(0,nrow=6,ncol=6);

st1 <- zICCdc[,1];
st2 <- zICCdc[,2];
lt1 <- zICCdc[,3];
lt2 <- zICCdc[,4];

output <- t.test(st1,st2,paired = T);
test_dc[1,1] <- output[["p.value"]];
test_dc[1,2] <- abs(output[["statistic"]][["t"]]);
test_dc[1,3] <- -sin(test_dc[1,2])*log((test_dc[1,1]),10);
test_dc[1,4] <- output[["estimate"]][["mean of the differences"]];
test_dc[1,c(5,6)] <- output[["conf.int"]]

output <- t.test(lt1,lt2,paired = T);
test_dc[2,1] <- output[["p.value"]];
test_dc[2,2] <- abs(output[["statistic"]][["t"]]);
test_dc[2,3] <- -sin(test_dc[2,2])*log((test_dc[2,1]),10);
test_dc[2,4] <- output[["estimate"]][["mean of the differences"]];
test_dc[2,c(5,6)] <- output[["conf.int"]]

output <- t.test(st1,lt1,paired = T);
test_dc[3,1] <- output[["p.value"]];
test_dc[3,2] <- abs(output[["statistic"]][["t"]]);
test_dc[3,3] <- -sin(test_dc[3,2])*log((test_dc[3,1]),10);
test_dc[3,4] <- output[["estimate"]][["mean of the differences"]];
test_dc[3,c(5,6)] <- output[["conf.int"]]

output <- t.test(st2,lt2,paired = T);
test_dc[4,1] <- output[["p.value"]];
test_dc[4,2] <- abs(output[["statistic"]][["t"]]);
test_dc[4,3] <- -sin(test_dc[4,2])*log((test_dc[4,1]),10);
test_dc[4,4] <- output[["estimate"]][["mean of the differences"]];
test_dc[4,c(5,6)] <- output[["conf.int"]]

output <- t.test(st1,lt2,paired = T);
test_dc[5,1] <- output[["p.value"]];
test_dc[5,2] <- abs(output[["statistic"]][["t"]]);
test_dc[5,3] <- -sin(test_dc[5,2])*log((test_dc[5,1]),10);
test_dc[5,4] <- output[["estimate"]][["mean of the differences"]];
test_dc[5,c(5,6)] <- output[["conf.int"]]

output <- t.test(st2,lt1,paired = T);
test_dc[6,1] <- output[["p.value"]];
test_dc[6,2] <- abs(output[["statistic"]][["t"]]);
test_dc[6,3] <- -sin(test_dc[6,2])*log((test_dc[6,1]),10);
test_dc[6,4] <- output[["estimate"]][["mean of the differences"]];
test_dc[6,c(5,6)] <- output[["conf.int"]]

dc_test <- as.data.frame(test_dc);
colnames(dc_test) <- c("p value","t value"," ","mean of diff","conf inf"," ");
rownames(dc_test) <- c("st1_st2","lt1_lt2","st1_lt1","st2_lt2","st1_lt2","st2_lt1");
View(dc_test)
testfile <- print(paste(filefolder,'DC/ICC/zICCdc_test',sep = ""));
write.csv (dc_test, file =testfile, row.names = FALSE, col.names = FALSE)
