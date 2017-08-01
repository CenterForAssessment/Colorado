#############################################################################################
###
### Prep file for 2017 Colorado LONG data
###
#############################################################################################

### Load Packages

require(data.table)
require(SGP)

### Load Data

read.zip <- function(file, fread.args=NULL) {
  if(!file.exists(file)) stop("File requested does not exist in path provided.")
	my.file <- gsub(".zip",  "", file)
	tmp.dir <- getwd()
	setwd(tempdir())
	system(paste0("unzip '", file.path(tmp.dir, paste0(my.file, ".zip")), "'"))

  if (substring(fread.args, 1, 1) != ",") fread.args <- paste(",", fread.args)
	TMP <-  eval(parse(text=paste0("data.table::fread('", grep(basename(my.file), list.files(), value=TRUE), "'", fread.args, ")")))
	unlink(grep(basename(my.file), list.files(), value=TRUE))
	setwd(tmp.dir)
	return(TMP)
}

Colorado_Data_LONG_2017 <- read.zip(file="Data/Base_Files/SAT_2016_2017_growth readin_EDWP_07_26_2017.zip", fread.args="colClasses=rep('character', 24)")


### Tidy up data

# Rename YR
setnames(Colorado_Data_LONG_2017, "YR", "YEAR")

# Create CONTENT variable
Colorado_Data_LONG_2017[CONTENT_AREA=="ELA", CONTENT:="ELA"]
Colorado_Data_LONG_2017[CONTENT_AREA=="MAT", CONTENT:="MATHEMATICS"]

# Fix CONTENT_AREA
Colorado_Data_LONG_2017[CONTENT_AREA=="ELA" & GRADE==10, CONTENT_AREA:="ELA_PSAT"]
Colorado_Data_LONG_2017[CONTENT_AREA=="ELA" & GRADE==11, CONTENT_AREA:="ELA_SAT"]
Colorado_Data_LONG_2017[CONTENT_AREA=="MAT" & GRADE==10, CONTENT_AREA:="MATHEMATICS_PSAT"]
Colorado_Data_LONG_2017[CONTENT_AREA=="MAT" & GRADE==11, CONTENT_AREA:="MATHEMATICS_SAT"]

#  Convert SCALE_SCORE variable to numeric
Colorado_Data_LONG_2017[, SCALE_SCORE:=as.numeric(SCALE_SCORE)]
Colorado_Data_LONG_2017[, SCALE_SCORE_ORIGINAL:=SCALE_SCORE]

#  Convert YEAR to match PARCC conventions
Colorado_Data_LONG_2017[which(YEAR=="2016"), YEAR := "2015_2016.2"]
Colorado_Data_LONG_2017[which(YEAR=="2017"), YEAR := "2016_2017.2"]

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
# # All 2017 duplicates within GRADE are already INVALID_CASEs - many with NA scores.
# Colorado_Data_LONG_2017[which(duplicated(Colorado_Data_LONG_2017, by=key(Colorado_Data_LONG_2017))), VALID_CASE:="INVALID_CASE"]

#  Save 2017 Data
save(Colorado_Data_LONG_2017, file="Data/Colorado_Data_LONG_2017-PSAT_SAT.Rdata")

kbs <- createKnotsBoundaries(Colorado_Data_LONG_2017)
SGPstateData[["CO"]][["Achievement"]][["Knots_Boundaries"]] <- c(SGPstateData[["CO"]][["Achievement"]][["Knots_Boundaries"]], kbs)
