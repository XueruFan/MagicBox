#############################################

# calculate zSFC icc 

rm(list=ls())
library(lme4)

filefolder <- print("/Users/fanxueru/Library/Mobile Documents/com~apple~CloudDocs/project/hcp/MasterProject/HCP_2visits_400ptseries/zSFC/");

# 1 run without threshold
workdir <- print(paste(filefolder,'1r_10p_RL/',sep = ""));
setwd(workdir)

  step <- c(1:10);
  for (s in step){
    file <- print(paste("LT_S",s,".csv",sep = ""))
    fname <- paste0(workdir, file)
    zsfc <- read.csv(fname,header = FALSE)
    
    mydata <- t(zsfc);    
    #colnames(mydata)=mydata[1,];
    #mydata <- mydata[-1,-1];
    mydata <- as.data.frame(mydata);
    colnames(mydata)[1]<-print("idnew");
    colnames(mydata)[2]<-print("rest");
    colnames(mydata)[3]<-print("gender")
    colnames(mydata)[4]<-print("age")
    colnames(mydata)[5]<-print("TestRetestInterval")
    colnames(mydata)[6]<-print("visit")
    colnames(mydata)[7:1206] <- c(1:1200);
    
    idnew <- as.character(mydata$idnew);
    age <- as.numeric(as.character(mydata$age));
    gender <- as.factor(mydata$gender);
    TestRetestInterval <- as.numeric(as.character(mydata$TestRetestInterval));
    visit <- as.factor(mydata$visit);
    
    ICC <- matrix(0,nrow=1200,ncol=1);
    Vr <- matrix(0,nrow=1200,ncol=1);
    sigma_sub2 <- matrix(0,nrow=1200,ncol=1);
    sigma_sub_vis2 <- matrix(0,nrow=1200,ncol=1);
    sigma_err2 <- matrix(0,nrow=1200,ncol=1);
    sigma_sub2_over_Vr <- matrix(0,nrow=1200,ncol=1);
    sigma_sub_vis2_over_Vr <- matrix(0,nrow=1200,ncol=1);
    sigma_err2_over_Vr <- matrix(0,nrow=1200,ncol=1);
    
    for (i in 7:1206){
      i <- as.character(i-6);
      sfc <- mydata[, i];
      newdata <- data.frame(idnew, age, gender, TestRetestInterval, visit, sfc);
      newdata$sfc <- as.numeric(as.character(newdata$sfc));
      vr <- var(newdata$sfc);
      #find outliers
      outliers <- newdata$sfc %in% boxplot.stats(newdata$sfc)$out
      #exclude outliers
      newdata <- newdata[!outliers,]
      options(warn = 2)
      
      T <- try({ mymodel <- lmer(sfc ~ age * gender + TestRetestInterval + (1 | idnew/visit), data=newdata, REML=FALSE) });
      if ("try-error" %in% class(T))
      {
        next
      }
      
      output <- summary(mymodel);
      df_var <- data.frame(output$varcor);
      a <- df_var[1,4];
      b <- df_var[2,4];
      c <- df_var[3,4];
      d <- a + b + c;
      icc <- b/d;
      i <- as.numeric(i);
      ICC[i,1] <- icc;
      Vr[i,1] <- vr;
      sigma_sub2[i,1] <- b;
      sigma_sub_vis2[i,1] <- a;
      sigma_err2[i,1] <- c;
      sigma_sub2_over_Vr[i,1] <- b/vr;
      sigma_sub_vis2_over_Vr[i,1] <- a/vr;
      sigma_err2_over_Vr[i,1] <- c/vr;
      
    }
    
    zSFCicc <- data.frame(ICC,sigma_sub2,sigma_sub_vis2,sigma_err2,Vr,sigma_sub2_over_Vr,sigma_sub_vis2_over_Vr,sigma_err2_over_Vr);
    iccfile <- print(paste(filefolder,"1r_10p_RL/zSFC_ICC_LTs",s,".csv",sep = ""));
    write.csv (zSFCicc, file =iccfile)
  }
  