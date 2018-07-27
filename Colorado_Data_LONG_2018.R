#########################################################################
###                                                                   ###
###               Prep file for 2018 Colorado LONG data               ###
###                                                                   ###
#########################################################################

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

  if (!is.null(fread.args)) if (substring(fread.args, 1, 1) != ",") fread.args <- paste(",", fread.args)
	TMP <-  eval(parse(text=paste0("data.table::fread('", grep(basename(my.file), list.files(), value=TRUE), "'", fread.args, ")")))
	unlink(grep(basename(my.file), list.files(), value=TRUE))
	setwd(tmp.dir)
	return(TMP)
}

Colorado_Data_LONG_2018 <- rbindlist(list(
  read.zip(file="Data/Base_Files/CMAS_2018_Growth_Readin_07.20.18.zip", fread.args="colClasses=rep('character', 25)"),
  read.zip(file="Data/Base_Files/PSAT&SAT_2018_Growth_Readin.zip", fread.args="colClasses=rep('character', 24)")), fill=TRUE)


### Tidy up data

# Rename YR
setnames(Colorado_Data_LONG_2018, "YR", "YEAR")

# Re-lable CONTENT_AREA values
Colorado_Data_LONG_2018[, CONTENT_AREA := factor(CONTENT_AREA)]
levels(Colorado_Data_LONG_2018$CONTENT_AREA) <- c("ALGEBRA_I", "ELA", "GEOMETRY", "MATHEMATICS", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "SLA")
Colorado_Data_LONG_2018[, CONTENT_AREA := as.character(CONTENT_AREA)]

Colorado_Data_LONG_2018[CONTENT_AREA=="ELA" & GRADE==9, CONTENT_AREA := "ELA_PSAT_9"]
Colorado_Data_LONG_2018[CONTENT_AREA=="ELA" & GRADE==10, CONTENT_AREA:= "ELA_PSAT_10"]
Colorado_Data_LONG_2018[CONTENT_AREA=="ELA" & GRADE==11, CONTENT_AREA:= "ELA_SAT"]
Colorado_Data_LONG_2018[CONTENT_AREA=="MATHEMATICS" & GRADE==9, CONTENT_AREA := "MATHEMATICS_PSAT_9"]
Colorado_Data_LONG_2018[CONTENT_AREA=="MATHEMATICS" & GRADE==10, CONTENT_AREA:= "MATHEMATICS_PSAT_10"]
Colorado_Data_LONG_2018[CONTENT_AREA=="MATHEMATICS" & GRADE==11, CONTENT_AREA:= "MATHEMATICS_SAT"]

#  Convert SCALE_SCORE variable to numeric
Colorado_Data_LONG_2018[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

#  Convert names to factors (temporary to change levels vs values for time/memory saving)
Colorado_Data_LONG_2018[, DISTRICT_NAME:=factor(DISTRICT_NAME)]
Colorado_Data_LONG_2018[, SCHOOL_NAME:=factor(SCHOOL_NAME)]
Colorado_Data_LONG_2018[, FIRST_NAME:=factor(FIRST_NAME)]
Colorado_Data_LONG_2018[, LAST_NAME:=factor(LAST_NAME)]

##  Clean up LAST_NAME and FIRST_NAME
setattr(Colorado_Data_LONG_2018$LAST_NAME, "levels", sapply(levels(Colorado_Data_LONG_2018$LAST_NAME), capwords))
setattr(Colorado_Data_LONG_2018$FIRST_NAME, "levels", sapply(levels(Colorado_Data_LONG_2018$FIRST_NAME), capwords))

##  Clean up SCHOOL_NAME and DISTRICT_NAME
setattr(Colorado_Data_LONG_2018$SCHOOL_NAME, "levels", sapply(levels(Colorado_Data_LONG_2018$SCHOOL_NAME), capwords))
setattr(Colorado_Data_LONG_2018$DISTRICT_NAME, "levels", sapply(levels(Colorado_Data_LONG_2018$DISTRICT_NAME), capwords))

##  Resolve duplicates
setkey(Colorado_Data_LONG_2018, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Colorado_Data_LONG_2018, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
# dups <- data.table(Colorado_Data_LONG_2018[unique(c(which(duplicated(Colorado_Data_LONG_2018, by=key(Colorado_Data_LONG_2018)))-1, which(duplicated(Colorado_Data_LONG_2018, by=key(Colorado_Data_LONG_2018))))), ], key=key(Colorado_Data_LONG_2018))
##  All 2018 duplicates within GRADE are already INVALID_CASEs - many with NA scores.
# Colorado_Data_LONG_2018[which(duplicated(Colorado_Data_LONG_2018, by=key(Colorado_Data_LONG_2018))), VALID_CASE:="INVALID_CASE"]

#  Save 2018 Data
save(Colorado_Data_LONG_2018, file="Data/Colorado_Data_LONG_2018.Rdata")
