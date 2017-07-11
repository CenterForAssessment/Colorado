#############################################################################################
###
### Prep file for 2017 Colorado LONG data
###
#############################################################################################

### Load Packages

require(data.table)
require(SGP)

### Load Data

Colorado_Data_LONG_2017 <- fread("Data/Base_Files/PARCC17_Growth_readin.csv", sep=',', header=TRUE, colClasses=rep("character", 24))


### Tidy up data

# Rename YR
setnames(Colorado_Data_LONG_2017, "YR", "YEAR")

# Fix CONTENT_AREA

Colorado_Data_LONG_2017[,CONTENT_AREA:=as.factor(CONTENT_AREA)]
setattr(Colorado_Data_LONG_2017$CONTENT_AREA, "levels", c("ALGEBRA_I", "ALGEBRA_II", "ELA", "ELA", "GEOMETRY", "MATHEMATICS", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3"))
Colorado_Data_LONG_2017[,CONTENT_AREA:=as.character(CONTENT_AREA)]

# Create CONTENT variable

Colorado_Data_LONG_2017[CONTENT_AREA=="ELA", CONTENT:="ELA"]
Colorado_Data_LONG_2017[is.na(CONTENT), CONTENT:="MATHEMATICS"]

#  Convert EOCT Grade levels to "EOCT"
Colorado_Data_LONG_2017[, GRADE_REPORTED:=GRADE]
Colorado_Data_LONG_2017[which(CONTENT_AREA %in% c("ALGEBRA_I", "ALGEBRA_II", "GEOMETRY", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3")), GRADE := "EOCT"]

#  Convert SCALE_SCORE variable to numeric
Colorado_Data_LONG_2017[, SCALE_SCORE:=as.numeric(SCALE_SCORE)]
Colorado_Data_LONG_2017[, SCALE_SCORE_ADJUSTED:=SCALE_SCORE]

#  Convert YEAR to match PARCC conventions
Colorado_Data_LONG_2017[which(YEAR=="2017"), YEAR := "2016_2017.2"]

#  Convert CONTENT_AREA to match PARCC conventions
Colorado_Data_LONG_2017[, CONTENT_AREA := paste0(CONTENT_AREA, "_SS")]

#  Convert names to factors (temporary to change levels vs values for time/memory saving)
Colorado_Data_LONG_2017[, DISTRICT_NAME:=factor(DISTRICT_NAME)]
Colorado_Data_LONG_2017[, SCHOOL_NAME:=factor(SCHOOL_NAME)]
Colorado_Data_LONG_2017[, FIRST_NAME:=factor(FIRST_NAME)]
Colorado_Data_LONG_2017[, LAST_NAME:=factor(LAST_NAME)]
Colorado_Data_LONG_2017[, ETHNICITY:=factor(ETHNICITY)]

## Clean up LAST_NAME and FIRST_NAME
setattr(Colorado_Data_LONG_2017$LAST_NAME, "levels", sapply(levels(Colorado_Data_LONG_2017$LAST_NAME), capwords))
setattr(Colorado_Data_LONG_2017$FIRST_NAME, "levels", sapply(levels(Colorado_Data_LONG_2017$FIRST_NAME), capwords))

## Clean up SCHOOL_NAME and DISTRICT_NAME
setattr(Colorado_Data_LONG_2017$SCHOOL_NAME, "levels", sapply(levels(Colorado_Data_LONG_2017$SCHOOL_NAME), capwords))
setattr(Colorado_Data_LONG_2017$DISTRICT_NAME, "levels", sapply(levels(Colorado_Data_LONG_2017$DISTRICT_NAME), capwords))

## Clean Up duplicate ETHNICITY levels
levels(Colorado_Data_LONG_2017$ETHNICITY)[6] <- "Native Hawaiian or Pacific Islander"

## Resolve duplicates

setkey(Colorado_Data_LONG_2017, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Colorado_Data_LONG_2017, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
# dups <- data.table(Colorado_Data_LONG_2017[unique(c(which(duplicated(Colorado_Data_LONG_2017, by=key(Colorado_Data_LONG_2017)))-1, which(duplicated(Colorado_Data_LONG_2017, by=key(Colorado_Data_LONG_2017))))), ], key=key(Colorado_Data_LONG_2017))
Colorado_Data_LONG_2017[which(duplicated(Colorado_Data_LONG_2017, by=key(Colorado_Data_LONG_2017))), VALID_CASE:="INVALID_CASE"]

#  Save 2017 Data
save(Colorado_Data_LONG_2017, file="Data/Colorado_Data_LONG_2017.Rdata")
