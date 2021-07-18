#########################################################################
###                                                                   ###
###        Prep CMAS/PSAT/SAT data for 2018 Colorado LONG data        ###
###                                                                   ###
#########################################################################

### Load Packages
require(data.table)

### Load Data
load("Data/Archive/July 2018/Colorado_SGP_LONG_Data.Rdata")

#   Load Prior Year(s) PARCC Data
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


###   Tidy up data

##  Prior Years CMAS/PARCC Data

#   Remove PSAT/SAT scores (added in prelim analyses May 2018 - unofficial).
Colorado_SGP_LONG_Data <- Colorado_SGP_LONG_Data[!CONTENT_AREA %in% c("ELA_PSAT", "ELA_SAT", "MATHEMATICS_PSAT", "MATHEMATICS_SAT")]

#   Remove PARCC YEAR and CONTENT_AREA conventions
Colorado_SGP_LONG_Data[YEAR == "2014_2015.2", YEAR := "2015"] # Keep 2015 scores to re-run 2017 PSAT/SAT analyses with offical data.
Colorado_SGP_LONG_Data[YEAR == "2015_2016.2", YEAR := "2016"]
Colorado_SGP_LONG_Data[YEAR == "2016_2017.2", YEAR := "2017"]

Colorado_SGP_LONG_Data[, CONTENT_AREA := gsub("_SS", "", CONTENT_AREA)]

#   Remove unneccessary variables from PARCC, etc.
Colorado_SGP_LONG_Data[, CONTENT := NULL]
Colorado_SGP_LONG_Data[, FPRC_DDNT_CODE := NULL]
Colorado_SGP_LONG_Data[, SCALE_SCORE_ORIGINAL := NULL]

table(Colorado_SGP_LONG_Data[, CONTENT_AREA, YEAR])


##  CMAS and P/SAT Data

#   Rename YR
setnames(Colorado_Data_LONG_2018, "YR", "YEAR")

#   Re-lable CONTENT_AREA values
Colorado_Data_LONG_2018[, CONTENT_AREA := factor(CONTENT_AREA)]
levels(Colorado_Data_LONG_2018$CONTENT_AREA) <- c("ALGEBRA_I", "ELA", "GEOMETRY", "MATHEMATICS", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "SLA")
Colorado_Data_LONG_2018[, CONTENT_AREA := as.character(CONTENT_AREA)]

Colorado_Data_LONG_2018[CONTENT_AREA=="ELA" & GRADE==9, CONTENT_AREA := "ELA_PSAT_9"]
Colorado_Data_LONG_2018[CONTENT_AREA=="ELA" & GRADE==10, CONTENT_AREA:= "ELA_PSAT_10"]
Colorado_Data_LONG_2018[CONTENT_AREA=="ELA" & GRADE==11, CONTENT_AREA:= "ELA_SAT"]
Colorado_Data_LONG_2018[CONTENT_AREA=="MATHEMATICS" & GRADE==9, CONTENT_AREA := "MATHEMATICS_PSAT_9"]
Colorado_Data_LONG_2018[CONTENT_AREA=="MATHEMATICS" & GRADE==10, CONTENT_AREA:= "MATHEMATICS_PSAT_10"]
Colorado_Data_LONG_2018[CONTENT_AREA=="MATHEMATICS" & GRADE==11, CONTENT_AREA:= "MATHEMATICS_SAT"]

#   Set GRADE to 'EOCT' for ALG1 and GEOM.
Colorado_Data_LONG_2018[, GRADE_REPORTED := GRADE]
Colorado_Data_LONG_2018[CONTENT_AREA %in% c("ALGEBRA_I", "GEOMETRY", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2"), GRADE := "EOCT"]

table(Colorado_Data_LONG_2018[, GRADE, CONTENT_AREA])

#  Establish ACHIEVEMENT_LEVEL for PSAT/SAT
Colorado_Data_LONG_2018 <- SGP:::getAchievementLevel(Colorado_Data_LONG_2018, state="CO")
Colorado_Data_LONG_2018[ACHIEVEMENT_LEVEL=='NA', ACHIEVEMENT_LEVEL := "No Score"]
table(Colorado_Data_LONG_2018[, ACHIEVEMENT_LEVEL, VALID_CASE])

#   Convert SCALE_SCORE variable to numeric
Colorado_Data_LONG_2018[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

#   Convert names to factors (temporary to change levels vs values for time/memory saving)
Colorado_Data_LONG_2018[, DISTRICT_NAME:=factor(DISTRICT_NAME)]
Colorado_Data_LONG_2018[, SCHOOL_NAME:=factor(SCHOOL_NAME)]
Colorado_Data_LONG_2018[, FIRST_NAME:=factor(FIRST_NAME)]
Colorado_Data_LONG_2018[, LAST_NAME:=factor(LAST_NAME)]

#   Clean up LAST_NAME and FIRST_NAME
setattr(Colorado_Data_LONG_2018$LAST_NAME, "levels", sapply(levels(Colorado_Data_LONG_2018$LAST_NAME), SGP::capwords))
setattr(Colorado_Data_LONG_2018$FIRST_NAME, "levels", sapply(levels(Colorado_Data_LONG_2018$FIRST_NAME), SGP::capwords))

#   Clean up SCHOOL_NAME and DISTRICT_NAME
setattr(Colorado_Data_LONG_2018$SCHOOL_NAME, "levels", sapply(levels(Colorado_Data_LONG_2018$SCHOOL_NAME), SGP::capwords))
setattr(Colorado_Data_LONG_2018$DISTRICT_NAME, "levels", sapply(levels(Colorado_Data_LONG_2018$DISTRICT_NAME), SGP::capwords))

#   Resolve duplicates
setkey(Colorado_Data_LONG_2018, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Colorado_Data_LONG_2018, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
# dups <- data.table(Colorado_Data_LONG_2018[unique(c(which(duplicated(Colorado_Data_LONG_2018, by=key(Colorado_Data_LONG_2018)))-1, which(duplicated(Colorado_Data_LONG_2018, by=key(Colorado_Data_LONG_2018))))), ], key=key(Colorado_Data_LONG_2018))
# table(dups$VALID_CASE) # All 2018 duplicates within GRADE are already INVALID_CASEs
# Colorado_Data_LONG_2018[which(duplicated(Colorado_Data_LONG_2018, by=key(Colorado_Data_LONG_2018))), VALID_CASE:="INVALID_CASE"]


##  Combine Prior and Current Data Sets
Colorado_Data_LONG <- rbindlist(list(Colorado_SGP_LONG_Data, Colorado_Data_LONG_2018), fill=TRUE)

##  Save 2018 Data
save(Colorado_Data_LONG, file="Data/Colorado_Data_LONG.Rdata")


###   Create Knots and Boundaries for CO CMAS/PSAT/SAT

CO_CMAS_Knots_Boundaries <- SGP::createKnotsBoundaries(Colorado_Data_LONG)
save(CO_CMAS_Knots_Boundaries, file="/Users/avi/Dropbox (SGP)/Github_Repos/Packages/SGPstateData/Knots_Boundaries/CO_CMAS_Knots_Boundaries.Rdata")
