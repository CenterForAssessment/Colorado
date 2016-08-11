
#############################################################################################
###
### Prep file for 2016 Colorado LONG data
###
#############################################################################################

###    Load Packages

require(data.table)
require(SGP)

###    Load Data
    
Colorado_Data_2016_Adj <- fread("Data/Base_Files/Colorado_SGP_LONG_Data_2015-16 AdjustedSS.csv", 
					sep=',', header=TRUE, colClasses=rep("character", 28))
setkey(Colorado_Data_2016_Adj, VALID_CASE, ID, FPRC_SUMM_SCORE_REC_UUID, CONTENT_AREA, YEAR)
setnames(Colorado_Data_2016_Adj, "SCALE_SCORE", "SCALE_SCORE_ADJUSTED")

Colorado_Data_2016_Orig <- fread("Data/Base_Files/Colorado_SGP_LONG_Data_2015-16 OriginalSS.csv", 
					sep=',', header=TRUE, colClasses=rep("character", 28))
setkey(Colorado_Data_2016_Orig, VALID_CASE, ID, FPRC_SUMM_SCORE_REC_UUID, CONTENT_AREA, YEAR)

Colorado_Data_LONG_2016 <- Colorado_Data_2016_Orig[Colorado_Data_2016_Adj[, list(VALID_CASE, ID, FPRC_SUMM_SCORE_REC_UUID, CONTENT_AREA, YEAR, SCALE_SCORE_ADJUSTED)]]

###    Tidy up data

#  Convert SCALE_SCORE variable to numeric
Colorado_Data_LONG_2016[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

#  Convert YEAR to match PARCC conventions
Colorado_Data_LONG_2016[which(YEAR=="2015"), YEAR := "2014_2015.2"]
Colorado_Data_LONG_2016[which(YEAR=="2016"), YEAR := "2015_2016.2"]

#  Convert CONTENT_AREA to match PARCC conventions
Colorado_Data_LONG_2016[, CONTENT_AREA := paste0(CONTENT_AREA, "_SS")]

#  Convert EOCT Grade levels to "EOCT"
Colorado_Data_LONG_2016[, GRADE_REPORTED := GRADE]
Colorado_Data_LONG_2016[which(CONTENT_AREA %in% c("ALGEBRA_I", "ALGEBRA_II", "GEOMETRY", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")), GRADE := "EOCT"]

#  Convert names to factors (temporary to change levels vs values for time/memory saving)
Colorado_Data_LONG_2016[, DISTRICT_NAME := factor(DISTRICT_NAME)]
Colorado_Data_LONG_2016[, SCHOOL_NAME := factor(SCHOOL_NAME)]
Colorado_Data_LONG_2016[, FIRST_NAME := factor(FIRST_NAME)]
Colorado_Data_LONG_2016[, LAST_NAME := factor(LAST_NAME)]
Colorado_Data_LONG_2016[, ETHNICITY := factor(ETHNICITY)]

## Clean up LAST_NAME and FIRST_NAME
levels(Colorado_Data_LONG_2016$LAST_NAME) <- sapply(levels(Colorado_Data_LONG_2016$LAST_NAME), capwords)
levels(Colorado_Data_LONG_2016$FIRST_NAME) <- sapply(levels(Colorado_Data_LONG_2016$FIRST_NAME), capwords)

## Clean up SCHOOL_NAME and DISTRICT_NAME
levels(Colorado_Data_LONG_2016$SCHOOL_NAME) <- sapply(levels(Colorado_Data_LONG_2016$SCHOOL_NAME), capwords)
levels(Colorado_Data_LONG_2016$DISTRICT_NAME) <- sapply(levels(Colorado_Data_LONG_2016$DISTRICT_NAME), capwords)

## Clean Up duplicate ETHNICITY levels
levels(Colorado_Data_LONG_2016$ETHNICITY)[7] <- "Native Hawaiian or Pacific Islander"

#  Save 2016 Data
save(Colorado_Data_LONG_2016, file="Data/Colorado_Data_LONG_2016.Rdata")
