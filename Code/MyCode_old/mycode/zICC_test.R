rm(list = ls())
threshold <- "OMST";

filefolder <- print(paste("/Users/fanxueru/Library/Mobile Documents/com~apple~CloudDocs/project/hcp/",threshold,"/8run/",sep = ""));
workdir <- print(paste(filefolder,'ICC/',sep = ""));
setwd(workdir)

seed_node <- c("AR","AL","SR","SL","VR","VL")
scheme <- c("ST1","LT2")

for ( sn in seed_node ) {
  for ( s in scheme ){
    
    ziccfile <- print(paste(sn,"_zICC_",s,".csv",sep = ""))
    zICC <- read.csv(ziccfile,header = FALSE)

    s1 <- zICC[,1]
    s2 <- zICC[,2]
    s3 <- zICC[,3]
    s4 <- zICC[,4]
    s5 <- zICC[,5]
    s6 <- zICC[,6]
    s7 <- zICC[,7]
    
    output1 <- t.test(s1,s2,paired = T);
    output2 <- t.test(s2,s3,paired = T);
    output3 <- t.test(s3,s4,paired = T);
    output4 <- t.test(s4,s5,paired = T);
    output5 <- t.test(s5,s6,paired = T);
    output6 <- t.test(s6,s7,paired = T);
    View(output1)
    View(output2)
    View(output3)
    View(output4)
    View(output5)
    View(output6)
    
    test_zicc = matrix(0,nrow=6,ncol=6)
    
    test_zicc[1,1] <- output1[["p.value"]];
    test_zicc[1,2] <- abs(output1[["statistic"]][["t"]]);
    test_zicc[1,3] <- -sin(test_zicc[1,2])*log((test_zicc[1,1]),10);
    test_zicc[1,4] <- output1[["estimate"]][["mean of the differences"]];
    test_zicc[1,c(5,6)] <- output1[["conf.int"]]

    test_zicc[2,1] <- output2[["p.value"]];
    test_zicc[2,2] <- abs(output2[["statistic"]][["t"]]);
    test_zicc[2,3] <- -sin(test_zicc[2,2])*log((test_zicc[2,1]),10);
    test_zicc[2,4] <- output2[["estimate"]][["mean of the differences"]];
    test_zicc[2,c(5,6)] <- output2[["conf.int"]]
    
    test_zicc[3,1] <- output3[["p.value"]];
    test_zicc[3,2] <- abs(output3[["statistic"]][["t"]]);
    test_zicc[3,3] <- -sin(test_zicc[3,2])*log((test_zicc[3,1]),10);
    test_zicc[3,4] <- output3[["estimate"]][["mean of the differences"]];
    test_zicc[3,c(5,6)] <- output3[["conf.int"]]
    
    test_zicc[4,1] <- output4[["p.value"]];
    test_zicc[4,2] <- abs(output4[["statistic"]][["t"]]);
    test_zicc[4,3] <- -sin(test_zicc[4,2])*log((test_zicc[4,1]),10);
    test_zicc[4,4] <- output4[["estimate"]][["mean of the differences"]];
    test_zicc[4,c(5,6)] <- output4[["conf.int"]]
    
    test_zicc[5,1] <- output5[["p.value"]];
    test_zicc[5,2] <- abs(output5[["statistic"]][["t"]]);
    test_zicc[5,3] <- -sin(test_zicc[5,2])*log((test_zicc[5,1]),10);
    test_zicc[5,4] <- output5[["estimate"]][["mean of the differences"]];
    test_zicc[5,c(5,6)] <- output5[["conf.int"]]
    
    test_zicc[6,1] <- output6[["p.value"]];
    test_zicc[6,2] <- abs(output6[["statistic"]][["t"]]);
    test_zicc[6,3] <- -sin(test_zicc[6,2])*log((test_zicc[6,1]),10);
    test_zicc[6,4] <- output6[["estimate"]][["mean of the differences"]];
    test_zicc[6,c(5,6)] <- output6[["conf.int"]]
    
    zicc_test <- as.data.frame(test_zicc);
    colnames(zicc_test) <- c("p value","t value"," ","mean of diff","conf inf"," ");
    rownames(zicc_test) <- c("s1_s2","s2_s3","s3_s4","s4_s5","s5_s6","s6_s7");
    View(zicc_test)
    testfile <- print(paste(filefolder,"ICC/zICC_test_",sn,s,".csv",sep = ""));
    write.csv (zicc_test, file =testfile, row.names = FALSE, col.names = FALSE)
    
  }
  
}
