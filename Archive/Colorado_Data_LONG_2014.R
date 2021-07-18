#############################################################################################
###
### Prep file for 2014 Colorado LONG data
###
#############################################################################################

### Load Packages

require(data.table)
require(SGP)


### Load Data

load("Data/Base_Files/Colorado_Data_LONG.Rdata")


### Tidy up data

# Convert variable to characters

Colorado_Data_LONG[,ID:=as.character(Colorado_Data_LONG$ID)]
Colorado_Data_LONG[,CONTENT_AREA:=as.character(Colorado_Data_LONG$CONTENT_AREA)]
Colorado_Data_LONG[,YEAR:=as.character(Colorado_Data_LONG$YEAR)]
Colorado_Data_LONG[,GRADE:=as.character(Colorado_Data_LONG$GRADE)]
Colorado_Data_LONG[,VALID_CASE:=as.character(Colorado_Data_LONG$VALID_CASE)]

# Clean up LAST_NAME and FIRST_NAME

levels(Colorado_Data_LONG$LAST_NAME) <- sapply(levels(Colorado_Data_LONG$LAST_NAME), capwords)
levels(Colorado_Data_LONG$FIRST_NAME) <- sapply(levels(Colorado_Data_LONG$FIRST_NAME), capwords)

# Clean up SCHOOL_NAME and DISTRICT_NAME

levels(Colorado_Data_LONG$SCHOOL_NAME) <- sapply(levels(Colorado_Data_LONG$SCHOOL_NAME), capwords)
levels(Colorado_Data_LONG$DISTRICT_NAME) <- sapply(levels(Colorado_Data_LONG$DISTRICT_NAME), capwords)


# Clean Up duplicate ETHNICITY levels

levels(Colorado_Data_LONG$ETHNICITY)[7] <- "Native Hawaiian or Pacific Islander"
levels(Colorado_Data_LONG$ETHNICITY)[8] <- "Two or more races"

# Clean up ACHIEVEMENT_LEVEL

Colorado_Data_LONG$ACHIEVEMENT_LEVEL <- ordered(Colorado_Data_LONG$ACHIEVEMENT_LEVEL, levels=c("Unsatisfactory", "Partially Proficient", "Proficient", "Advanced", "No Score"))


# Convert SCALE_SCORE to numeric

Colorado_Data_LONG[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]


### Save results

save(Colorado_Data_LONG, file="Data/Colorado_Data_LONG.Rdata")

