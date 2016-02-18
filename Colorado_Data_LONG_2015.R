
#############################################################################################
###
### Prep file for 2014 Colorado LONG data
###
#############################################################################################

###    Load Packages

require(data.table)
require(SGP)

setwd('/media/Data/Dropbox/SGP/Colorado')

###    Load Data

Colorado_Data_LONG_2015 <- fread("Data/Base_Files/PARCC_2015_Longfile.csv", 
					sep=',', header=TRUE, colClasses=rep("character", 26))

###    Tidy up data

#  Convert SCALE_SCORE variable to numeric
Colorado_Data_LONG_2015[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

#  Convert CONTENT_AREA from test name to human readible levels
Colorado_Data_LONG_2015[, CONTENT_AREA := factor(CONTENT_AREA)]
levels(Colorado_Data_LONG_2015$CONTENT_AREA) <- 
	c("ALGEBRA_I", "ALGEBRA_II", "ELA", "GEOMETRY", "MATHEMATICS", 
	  "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")
Colorado_Data_LONG_2015[, CONTENT_AREA := as.character(CONTENT_AREA)]

#  Convert names to factors (temporary to change levels vs values for time/memory saving)
Colorado_Data_LONG_2015[, DISTRICT_NAME := factor(DISTRICT_NAME)]
Colorado_Data_LONG_2015[, SCHOOL_NAME := factor(SCHOOL_NAME)]
Colorado_Data_LONG_2015[, FIRST_NAME := factor(FIRST_NAME)]
Colorado_Data_LONG_2015[, LAST_NAME := factor(LAST_NAME)]
Colorado_Data_LONG_2015[, ETHNICITY := factor(ETHNICITY)]

Colorado_Data_LONG_2015[, GRADE_REPORTED := GRADE]
Colorado_Data_LONG_2015[which(CONTENT_AREA %in% c("ALGEBRA_I", "ALGEBRA_II", "GEOMETRY", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")), GRADE := "EOCT"]

## Clean up LAST_NAME and FIRST_NAME
levels(Colorado_Data_LONG_2015$LAST_NAME) <- sapply(levels(Colorado_Data_LONG_2015$LAST_NAME), capwords)
levels(Colorado_Data_LONG_2015$FIRST_NAME) <- sapply(levels(Colorado_Data_LONG_2015$FIRST_NAME), capwords)

## Clean up SCHOOL_NAME and DISTRICT_NAME
levels(Colorado_Data_LONG_2015$SCHOOL_NAME) <- sapply(levels(Colorado_Data_LONG_2015$SCHOOL_NAME), capwords)
levels(Colorado_Data_LONG_2015$DISTRICT_NAME) <- sapply(levels(Colorado_Data_LONG_2015$DISTRICT_NAME), capwords)

## Clean Up duplicate ETHNICITY levels
levels(Colorado_Data_LONG_2015$ETHNICITY)[6] <- "Native Hawaiian or Pacific Islander"

#  Clean up YEAR
setnames(Colorado_Data_LONG_2015, "YR", "YEAR")

###  Invalidate duplicated case 
#      Only one kid - different grades.  Invalidate 3rd grade, keep 6th since enrolled in a middle school and has 6th grade math scores ...
setkey(Colorado_Data_LONG_2015, VALID_CASE, CONTENT_AREA, YEAR, ID, SCALE_SCORE)
setkey(Colorado_Data_LONG_2015, VALID_CASE, CONTENT_AREA, YEAR, ID)
# sum(duplicated(Colorado_Data_LONG_2015[VALID_CASE != "INVALID_CASE"])) # 10 duplicates with valid SSIDs -- all have same SSID and esID, so appear valid - take the highest score
# dups <- data.table(Colorado_Data_LONG_2015[unique(c(which(duplicated(Colorado_Data_LONG_2015))-1, which(duplicated(Colorado_Data_LONG_2015)))), ], key=key(Colorado_Data_LONG_2015))
Colorado_Data_LONG_2015[which(duplicated(Colorado_Data_LONG_2015)), VALID_CASE := "INVALID_CASE"]


#  Save 2015 Data
save(Colorado_Data_LONG_2015, file="Data/Colorado_Data_LONG_2015.Rdata")

###
###		Create New Colorado SGP object with TCAP Priors for PARCC analyses
###

#  Use @Data from outputSGP in 2014 TCAP analyses as the base for the new object
load("Data/Archive/February_2016/Colorado_SGP_LONG_Data.Rdata")

Colorado_LONG_Data <- Colorado_SGP_LONG_Data[VALID_CASE == "VALID_CASE" & YEAR %in% 2012:2014]

#  Remove all BASELINE SGP related variables
Colorado_LONG_Data[, grep("BASELINE", names(Colorado_LONG_Data)) := NULL]

#  Fix @Data 'Mixed' and 'Pac Islander' ethnicities
levels(Colorado_LONG_Data$ETHNICITY)[6] <- "Two or more races"
levels(Colorado_LONG_Data$ETHNICITY)[8] <- "Native Hawaiian or Pacific Islander"

#  Create New Colorado_SGP object via prepareSGP
Colorado_SGP <- prepareSGP(Colorado_LONG_Data)


###  Save new SGP class object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")