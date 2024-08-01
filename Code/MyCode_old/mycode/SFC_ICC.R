rm(list=ls())

library(lme4)

#load csv file

workdir <- '/Users/fanxueru/Library/Mobile Documents/com~apple~CloudDocs/project/hcp/20p/8run/CSV/'
setwd(workdir)
fname <- paste0(workdir,'v2t1t2S4.csv')
v2t1t2S4 <- read.csv(fname,header = FALSE)

mydata <- t(v2t1t2S4);    
colnames(mydata)=mydata[1,];
mydata <- mydata[-1,-1];
mydata2 <- as.data.frame(mydata);
colnames(mydata2)[6:79805] <- c(1:79800);

idnew <- as.character(mydata2$idnew);
age <- as.numeric(as.character(mydata2$age));
gender <- as.factor(mydata2$gender);
#TestRetestInterval <- as.numeric(as.character(mydata2$TestRetestInterval));

ICC_V2_S4 <- matrix(0,nrow=79800,ncol=1);

for (i in 6:79806){
  i <- as.character(i-5);
  sfc <- mydata2[, i];
  #newdata <- data.frame(idnew, age, gender, TestRetestInterval,sfc);
  newdata <- data.frame(idnew, age, gender, sfc);
  newdata$sfc <- as.numeric(as.character(newdata$sfc));
  #find outliers
  outliers <- newdata$sfc %in% boxplot.stats(newdata$sfc)$out
  #exclude outliers
  newdata <- newdata[!outliers,]
  #try({ mymodel <- lmer(sfc ~ age * gender + TestRetestInterval + (1|idnew) ,data=newdata, REML=FALSE);
  try({ mymodel <- lmer(sfc ~ age * gender + (1|idnew) ,data=newdata, REML=FALSE);
  output <- summary(mymodel);
  df_var <- data.frame(output$varcor);
  a <- df_var[1,4];
  b <- df_var[1,4]+df_var[2,4];
  icc <- a/b;
  i <- as.numeric(i);
  ICC_V2_S4[i,1] <- icc;
  })
}

ICC_V2_S4 <- data.frame(ICC_V2_S4)
write.csv (ICC_V2_S4, file ="/Users/fanxueru/Library/Mobile Documents/com~apple~CloudDocs/project/hcp/20p/8run/ICC/V2S4.csv", row.names = FALSE, col.names = FALSE)

