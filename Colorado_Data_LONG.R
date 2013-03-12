####################################################################################
###
### Code to prepare Colorado Data Long Data
###
####################################################################################

### Load SGP Package

library(SGP)


### Load data

load("Data/Colorado_Data_LONG_CDE_BASE_FILE_082011.Rdata")



#################################################################
###
### Tidy up data
###
#################################################################

### Get extra spaces out of IDs

levels(Colorado_Data_LONG$ID) <- sub(' +$', '', levels(Colorado_Data_LONG$ID))
levels(Colorado_Data_LONG$ID) <- sub('^ .', '', levels(Colorado_Data_LONG$ID))
Colorado_Data_LONG$ID <- as.character(Colorado_Data_LONG$ID)

Colorado_Data_LONG$SCHOOL_NUMBER <- as.factor(Colorado_Data_LONG$SCHOOL_NUMBER)
levels(Colorado_Data_LONG$SCHOOL_NUMBER) <- as.character(sapply(lapply(sapply(paste("0000", levels(Colorado_Data_LONG$SCHOOL_NUMBER), sep=""), strsplit, ""), tail, 4), paste, collapse=""))
Colorado_Data_LONG$SCHOOL_NUMBER <- as.character(Colorado_Data_LONG$SCHOOL_NUMBER)

Colorado_Data_LONG$DISTRICT_NUMBER_NEW <- as.factor(Colorado_Data_LONG$DISTRICT_NUMBER)
levels(Colorado_Data_LONG$DISTRICT_NUMBER_NEW) <- as.character(sapply(lapply(sapply(paste("0000", levels(Colorado_Data_LONG$DISTRICT_NUMBER_NEW), sep=""), strsplit, ""), tail, 4), paste, collapse=""))
Colorado_Data_LONG$DISTRICT_NUMBER_NEW <- as.character(Colorado_Data_LONG$DISTRICT_NUMBER_NEW)


Colorado_Data_LONG$VALID_CASE <- as.character(Colorado_Data_LONG$VALID_CASE)


### Save the result

save(Colorado_Data_LONG, file="Data/Colorado_Data_LONG.Rdata")
