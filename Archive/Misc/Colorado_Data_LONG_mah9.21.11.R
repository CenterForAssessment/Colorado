#######################################################
###
### Syntax to read in and create long data file
###
#######################################################

### Load SGP Package

require(SGP)
require(foreign)


### Utility functions

trimWhiteSpace <- function(line) gsub("(^ +)|( +$)", "", line)



### Load data

Colorado_Data_LONG <- read.spss("CSAP_02_11.sav", to.data.frame=TRUE, use.value.labels=FALSE)


### tidy up cases

Colorado_Data_LONG$YEAR <- as.character(Colorado_Data_LONG$YEAR)
Colorado_Data_LONG$YEAR[Colorado_Data_LONG$YEAR==20022003] <- "2002_2003"
Colorado_Data_LONG$YEAR[Colorado_Data_LONG$YEAR==20032004] <- "2003_2004"
Colorado_Data_LONG$YEAR[Colorado_Data_LONG$YEAR==20042005] <- "2004_2005"
Colorado_Data_LONG$YEAR[Colorado_Data_LONG$YEAR==20052006] <- "2005_2006"
Colorado_Data_LONG$YEAR[Colorado_Data_LONG$YEAR==20062007] <- "2006_2007"
Colorado_Data_LONG$YEAR[Colorado_Data_LONG$YEAR==20072008] <- "2007_2008"
Colorado_Data_LONG$YEAR[Colorado_Data_LONG$YEAR==20082009] <- "2008_2009"
Colorado_Data_LONG$YEAR[Colorado_Data_LONG$YEAR==20092010] <- "2009_2010"
Colorado_Data_LONG$YEAR[Colorado_Data_LONG$YEAR==20102011] <- "2010_2011"
Colorado_Data_LONG$YEAR <- factor(Colorado_Data_LONG$YEAR)

names(Colorado_Data_LONG)[9] <- "SCHOOL_NAME"


names(Colorado_Data_LONG)[2] <- "CONTENT_AREA"
Colorado_Data_LONG$CONTENT_AREA <- factor(Colorado_Data_LONG$CONTENT_AREA, levels=1:3, labels=c("READING", "WRITING", "MATHEMATICS"))

Colorado_Data_LONG$ID <- factor(Colorado_Data_LONG$ID)

Colorado_Data_LONG$DISTRICT_NUMBER <- as.integer(Colorado_Data_LONG$DISTRICT_NUMBER)
Colorado_Data_LONG$SCHOOL_NUMBER <- as.integer(Colorado_Data_LONG$SCHOOL_NUMBER)

levels(Colorado_Data_LONG$ETHNICITY) <- trimWhiteSpace(levels(Colorado_Data_LONG$ETHNICITY))
Colorado_Data_LONG$ETHNICITY[Colorado_Data_LONG$ETHNICITY==0] <- NA
Colorado_Data_LONG$ETHNICITY[Colorado_Data_LONG$ETHNICITY=="00"] <- NA
Colorado_Data_LONG$ETHNICITY <- factor(Colorado_Data_LONG$ETHNICITY)

levels(Colorado_Data_LONG$GENDER) <- trimWhiteSpace(levels(Colorado_Data_LONG$GENDER))
Colorado_Data_LONG$GENDER[Colorado_Data_LONG$GENDER=="U"] <- NA
Colorado_Data_LONG$GENDER <- factor(Colorado_Data_LONG$GENDER)
levels(Colorado_Data_LONG$GENDER) <- c("Female", "Male")

levels(Colorado_Data_LONG$IEP_STATUS) <- trimWhiteSpace(levels(Colorado_Data_LONG$IEP_STATUS))
Colorado_Data_LONG$IEP_STATUS[Colorado_Data_LONG$IEP_STATUS %in% c("UUU", "U")] <- NA
Colorado_Data_LONG$IEP_STATUS <- factor(Colorado_Data_LONG$IEP_STATUS)
levels(Colorado_Data_LONG$IEP_STATUS) <- c("IEP: No", "IEP: Yes") 

Colorado_Data_LONG$FREE_REDUCED_LUNCH_STATUS[Colorado_Data_LONG$FREE_REDUCED_LUNCH_STATUS=="U"] <- NA
Colorado_Data_LONG$FREE_REDUCED_LUNCH_STATUS <- factor(Colorado_Data_LONG$FREE_REDUCED_LUNCH_STATUS)
levels(Colorado_Data_LONG$FREE_REDUCED_LUNCH_STATUS) <- c("Free Reduced Lunch: Yes", "Free Reduced Lunch: No")


Colorado_Data_LONG$GIFTED_TALENTED_PROGRAM_STATUS[Colorado_Data_LONG$GIFTED_TALENTED_PROGRAM_STATUS=="U"] <- NA
Colorado_Data_LONG$GIFTED_TALENTED_PROGRAM_STATUS[Colorado_Data_LONG$GIFTED_TALENTED_PROGRAM_STATUS==" "] <- NA
Colorado_Data_LONG$GIFTED_TALENTED_PROGRAM_STATUS <- factor(Colorado_Data_LONG$GIFTED_TALENTED_PROGRAM_STATUS, levels=0:1, 
	labels=c("Gifted Talented Program: No", "Gifted Talented Program: Yes"))


Colorado_Data_LONG$ACHIEVEMENT_LEVEL <- factor(Colorado_Data_LONG$ACHIEVEMENT_LEVEL, levels=1:5, 
	labels=c("Unsatisfactory", "Partially Proficient", "Proficient", "Advanced", "No Score"))



levels(Colorado_Data_LONG$EMH_LEVEL) <- trimWhiteSpace(levels(Colorado_Data_LONG$EMH_LEVEL))
Colorado_Data_LONG$EMH_LEVEL[Colorado_Data_LONG$EMH_LEVEL==""] <- NA
Colorado_Data_LONG$EMH_LEVEL <- factor(Colorado_Data_LONG$EMH_LEVEL)
levels(Colorado_Data_LONG$EMH_LEVEL) <- c("Elementary", "High", "Middle")

is.factor(Colorado_Data_LONG$SCHOOL_NAME)
levels(Colorado_Data_LONG$SCHOOL_NAME) <- trimWhiteSpace(levels(Colorado_Data_LONG$SCHOOL_NAME))

is.factor(Colorado_Data_LONG$DITRICT_NAME)
levels(Colorado_Data_LONG$DISTRICT_NAME) <- trimWhiteSpace(levels(Colorado_Data_LONG$DISTRICT_NAME))

is.factor(Colorado_Data_LONG$LAST_NAME)
levels(Colorado_Data_LONG$LAST_NAME) <- trimWhiteSpace(levels(Colorado_Data_LONG$LAST_NAME))

is.factor(Colorado_Data_LONG$FIRST_NAME)
levels(Colorado_Data_LONG$FIRST_NAME) <- trimWhiteSpace(levels(Colorado_Data_LONG$FIRST_NAME))

is.factor(Colorado_Data_LONG$SCHOOL_ENROLLMENT_STATUS)
levels(Colorado_Data_LONG$SCHOOL_ENROLLMENT_STATUS) <- trimWhiteSpace(levels(Colorado_Data_LONG$SCHOOL_ENROLLMENT_STATUS))

is.factor(Colorado_Data_LONG$DISTRICT_ENROLLMENT_STATUS)
levels(Colorado_Data_LONG$DISTRICT_ENROLLMENT_STATUS) <- trimWhiteSpace(levels(Colorado_Data_LONG$DISTRICT_ENROLLMENT_STATUS))

is.factor(Colorado_Data_LONG$STATE_ENROLLMENT_STATUS)
levels(Colorado_Data_LONG$STATE_ENROLLMENT_STATUS) <- trimWhiteSpace(levels(Colorado_Data_LONG$STATE_ENROLLMENT_STATUS))

is.factor(Colorado_Data_LONG$VALID_CASE)
levels(Colorado_Data_LONG$VALID_CASE) <- trimWhiteSpace(levels(Colorado_Data_LONG$VALID_CASE))


### Save results

save(Colorado_Data_LONG, file="Colorado_Data_LONG.Rdata")


###prepare data

levels(Colorado_Data_LONG$CONTENT_AREA) <-c("MATHEMATICS", "READING", "WRITING")
prepareSGP(Colorado_Data_LONG) -> CSAP_SGP
save(CSAP_SGP, file="Colorado/Data/CSAP_SGP.Rdata")
rm(Colorado_Data_LONG)
gc()

CSAP_SGP <- analyzeSGP(CSAP_SGP,year=2011,simulate.sgps=FALSE,state="CO", 
   sgp.percentiles.baseline = FALSE,
   sgp.projections.baseline = FALSE,
   sgp.projections.lagged.baseline = FALSE,
   parallel.config=list(
      BACKEND="PARALLEL", 
      WORKERS=list(PERCENTILES=4, PROJECTIONS=2, LAGGED_PROJECTIONS=2, BASELINE_PERCENTILES=4)))


save(CSAP_SGP, file="Colorado/Data/CSAP_SGP.Rdata", compress="bzip2")
















