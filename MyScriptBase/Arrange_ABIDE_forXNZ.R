rm(list=ls())
packages <- c("plyr", "dplyr")
#sapply(packages,install.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

# define filefolder
abideDir <- 'E:/PhDproject/ABIDE'

# load pheno
abide1_pheno <- read.csv(file.path(abideDir, "ABIDE_info", "Phenotypic_V1_0b.csv"))
colnames(abide1_pheno)[2] <- "SID_ORIG"
abide2_pheno <- read.csv(file.path(abideDir, "ABIDE_info", "ABIDEII_Composite_Phenotypic.csv"))
colnames(abide2_pheno)[2] <- "SID_ORIG"

abide_list <- read.csv("C:/Users/xueru/Downloads/abide_sample_ids.csv")


abide1_all <- merge(abide_list, abide1_pheno, by = "SID_ORIG")
abide2_all <- merge(abide_list, abide2_pheno, by = "SID_ORIG")

abide1_all <- abide1_all %>% rename(PDD_DSM_IV_TR = DSM_IV_TR)
abide1_all <- abide1_all %>% rename(ADOS_G_TOTAL = ADOS_TOTAL)
abide1_all <- abide1_all %>% rename(ADOS_G_COMM = ADOS_COMM)
abide1_all <- abide1_all %>% rename(ADOS_G_SOCIAL = ADOS_SOCIAL)
abide1_all <- abide1_all %>% rename(ADOS_G_STEREO_BEHAV = ADOS_STEREO_BEHAV)
abide1_all <- abide1_all %>% rename(ADOS_2_SOCAFFECT = ADOS_GOTHAM_SOCAFFECT)
abide1_all <- abide1_all %>% rename(ADOS_2_RRB = ADOS_GOTHAM_RRB)
abide1_all <- abide1_all %>% rename(ADOS_2_TOTAL = ADOS_GOTHAM_TOTAL)
abide1_all <- abide1_all %>% rename(ADOS_2_SEVERITY_TOTAL = ADOS_GOTHAM_SEVERITY)
abide1_all <- abide1_all %>% rename(SRS_TOTAL_RAW = SRS_RAW_TOTAL)
abide1_all <- abide1_all %>% rename(SRS_AWARENESS_RAW = SRS_AWARENESS)
abide1_all <- abide1_all %>% rename(SRS_COGNITION_RAW = SRS_COGNITION)
abide1_all <- abide1_all %>% rename(SRS_COMMUNICATION_RAW = SRS_COMMUNICATION)
abide1_all <- abide1_all %>% rename(SRS_MOTIVATION_RAW = SRS_MOTIVATION)
abide1_all <- abide1_all %>% rename(SRS_MANNERISMS_RAW = SRS_MANNERISMS)
abide1_all <- abide1_all %>% rename(NONASD_PSYDX_LABEL = COMORBIDITY)
abide1_all <- abide1_all %>% rename(CURRENT_MEDICATION_NAME = MEDICATION_NAME)
abide1_all <- abide1_all %>% rename(ADI_R_RRB_TOTAL_C = ADI_RRB_TOTAL_C)
abide1_all <- abide1_all %>% rename(VINELAND_DAILYLIVING_STANDARD = VINELAND_DAILYLVNG_STANDARD)
abide1_all <- abide1_all %>% rename(VINELAND_ABC_Standard = VINELAND_ABC_STANDARD)

abide_all <- rbind.fill(abide2_all, abide1_all)

write.csv(abide_all, "C:/Users/xueru/Downloads/abide_sample_ids_forXNZ.csv", row.names = F)
