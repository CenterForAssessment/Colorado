
#############################################################################################
###
### Prep file for 2014 Colorado LONG data
###
#############################################################################################

###    Load Packages

require(data.table)
require(SGP)

###    Load Data

Colorado_Data_LONG_2015 <- fread("Data/Base_Files/PARCC_2015_Longfile.csv", 
					sep=',', header=TRUE, colClasses=rep("character", 26))
setkey(Colorado_Data_LONG_2015, FPRC_SUMM_SCORE_REC_UUID)

thetas <- fread("Data/Base_Files/Summ UUID & Thetas.csv", 
					sep=',', header=TRUE, colClasses=c("character", "numeric"))
setnames(thetas, 1, "FPRC_SUMM_SCORE_REC_UUID")
setkey(thetas, FPRC_SUMM_SCORE_REC_UUID)

Colorado_Data_LONG_2015 <- Colorado_Data_LONG_2015[thetas]
table(is.na(Colorado_Data_LONG_2015$ThetaScore), is.na(Colorado_Data_LONG_2015$SCALE_SCORE)) #  All should match up

###    Tidy up data

#  Convert SCALE_SCORE variable to numeric and change names making IRT Theta the score to be used.
Colorado_Data_LONG_2015[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
setnames(Colorado_Data_LONG_2015, c("ThetaScore", "SCALE_SCORE"), c("SCALE_SCORE", "SCALE_SCORE_ACTUAL")) #  Follow naming convention used in New Jersey

#  Convert CONTENT_AREA from test name to human readible levels
Colorado_Data_LONG_2015[, CONTENT_AREA := factor(CONTENT_AREA)]
levels(Colorado_Data_LONG_2015$CONTENT_AREA) <- 
	c("ALGEBRA_I", "ALGEBRA_II", "ELA", "GEOMETRY", "MATHEMATICS", 
	  "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")
Colorado_Data_LONG_2015[, CONTENT_AREA := as.character(CONTENT_AREA)]


Colorado_Data_LONG_2015[, GRADE_REPORTED := GRADE]
Colorado_Data_LONG_2015[which(CONTENT_AREA %in% c("ALGEBRA_I", "ALGEBRA_II", "GEOMETRY", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")), GRADE := "EOCT"]

#  Convert EOCT Grade levels to "EOCT"
Colorado_Data_LONG_2015[, GRADE_REPORTED := GRADE]
Colorado_Data_LONG_2015[which(CONTENT_AREA %in% c("ALGEBRA_I", "ALGEBRA_II", "GEOMETRY", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")), GRADE := "EOCT"]

#  Convert names to factors (temporary to change levels vs values for time/memory saving)
Colorado_Data_LONG_2015[, DISTRICT_NAME := factor(DISTRICT_NAME)]
Colorado_Data_LONG_2015[, SCHOOL_NAME := factor(SCHOOL_NAME)]
Colorado_Data_LONG_2015[, FIRST_NAME := factor(FIRST_NAME)]
Colorado_Data_LONG_2015[, LAST_NAME := factor(LAST_NAME)]
Colorado_Data_LONG_2015[, ETHNICITY := factor(ETHNICITY)]

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
# sum(duplicated(Colorado_Data_LONG_2015[VALID_CASE != "INVALID_CASE"])) # 1
# dups <- data.table(Colorado_Data_LONG_2015[unique(c(which(duplicated(Colorado_Data_LONG_2015))-1, which(duplicated(Colorado_Data_LONG_2015)))), ], key=key(Colorado_Data_LONG_2015))
Colorado_Data_LONG_2015[which(duplicated(Colorado_Data_LONG_2015)), VALID_CASE := "INVALID_CASE"]

#  Save 2015 Data
save(Colorado_Data_LONG_2015, file="Data/Colorado_Data_LONG_2015.Rdata")

###
###		Create New Colorado SGP object with TCAP Priors for PARCC analyses
###

#  Use @Data from outputSGP in 2014 TCAP analyses as the base for the new object
load("Data/Archive/February_2016/Colorado_SGP_LONG_Data.Rdata")

#  Invalidate Schools from cheating incidents (via Marie 3/17/2016)
Colorado_SGP_LONG_Data[which(YEAR=='2012' & SCHOOL_NUMBER=='4836' & DISTRICT_NUMBER=='0550'), VALID_CASE := "INVALID_CASE"]
Colorado_SGP_LONG_Data[which(YEAR=='2013' & SCHOOL_NUMBER=='5896' & DISTRICT_NUMBER=='3110'), VALID_CASE := "INVALID_CASE"]

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
