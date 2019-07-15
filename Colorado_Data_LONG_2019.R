#########################################################################
###                                                                   ###
###        Prep CMAS/PSAT/SAT data for 2019 Colorado LONG data        ###
###                                                                   ###
#########################################################################

### Load Packages
require(data.table)

#   Load Base Data
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

Colorado_Data_LONG_2019 <- read.zip(file="Data/Base_Files/CMAS 2019_Growth_ReadIn_07.03.19.csv.zip", fread.args="colClasses=rep('character', 24)")


###   Tidy up CMAS Data

#   Rename YR
setnames(Colorado_Data_LONG_2019, "YR", "YEAR")

#   Re-lable CONTENT_AREA values
Colorado_Data_LONG_2019[, CONTENT_AREA := factor(CONTENT_AREA)]
levels(Colorado_Data_LONG_2019$CONTENT_AREA) <- c("ELA", "MATHEMATICS")
Colorado_Data_LONG_2019[, CONTENT_AREA := as.character(CONTENT_AREA)]

#   Convert SCALE_SCORE variable to numeric
Colorado_Data_LONG_2019[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

#   Convert names to factors (temporary to change levels vs values for time/memory saving)
Colorado_Data_LONG_2019[, DISTRICT_NAME:=factor(DISTRICT_NAME)]
Colorado_Data_LONG_2019[, SCHOOL_NAME:=factor(SCHOOL_NAME)]
Colorado_Data_LONG_2019[, FIRST_NAME:=factor(FIRST_NAME)]
Colorado_Data_LONG_2019[, LAST_NAME:=factor(LAST_NAME)]

#   Clean up LAST_NAME and FIRST_NAME
setattr(Colorado_Data_LONG_2019$LAST_NAME, "levels", sapply(levels(Colorado_Data_LONG_2019$LAST_NAME), SGP::capwords))
setattr(Colorado_Data_LONG_2019$FIRST_NAME, "levels", sapply(levels(Colorado_Data_LONG_2019$FIRST_NAME), SGP::capwords))

#   Clean up SCHOOL_NAME and DISTRICT_NAME
setattr(Colorado_Data_LONG_2019$SCHOOL_NAME, "levels", sapply(levels(Colorado_Data_LONG_2019$SCHOOL_NAME), SGP::capwords))
setattr(Colorado_Data_LONG_2019$DISTRICT_NAME, "levels", sapply(levels(Colorado_Data_LONG_2019$DISTRICT_NAME), SGP::capwords))

#   Resolve duplicates
setkey(Colorado_Data_LONG_2019, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Colorado_Data_LONG_2019, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
# dups <- data.table(Colorado_Data_LONG_2019[unique(c(which(duplicated(Colorado_Data_LONG_2019, by=key(Colorado_Data_LONG_2019)))-1, which(duplicated(Colorado_Data_LONG_2019, by=key(Colorado_Data_LONG_2019))))), ], key=key(Colorado_Data_LONG_2019))
# table(dups$VALID_CASE) # All 2019 duplicates within GRADE are already INVALID_CASEs
# Colorado_Data_LONG_2019[which(duplicated(Colorado_Data_LONG_2019, by=key(Colorado_Data_LONG_2019))), VALID_CASE:="INVALID_CASE"]

##  Save 2019 Data
save(Colorado_Data_LONG_2019, file="Data/Colorado_Data_LONG_2019.Rdata")


###   PSAT/SAT

  ...

Colorado_Data_LONG_2019[CONTENT_AREA=="ELA" & GRADE==9, CONTENT_AREA := "ELA_PSAT_9"]
Colorado_Data_LONG_2019[CONTENT_AREA=="ELA" & GRADE==10, CONTENT_AREA:= "ELA_PSAT_10"]
Colorado_Data_LONG_2019[CONTENT_AREA=="ELA" & GRADE==11, CONTENT_AREA:= "ELA_SAT"]
Colorado_Data_LONG_2019[CONTENT_AREA=="MATHEMATICS" & GRADE==9, CONTENT_AREA := "MATHEMATICS_PSAT_9"]
Colorado_Data_LONG_2019[CONTENT_AREA=="MATHEMATICS" & GRADE==10, CONTENT_AREA:= "MATHEMATICS_PSAT_10"]
Colorado_Data_LONG_2019[CONTENT_AREA=="MATHEMATICS" & GRADE==11, CONTENT_AREA:= "MATHEMATICS_SAT"]

#   Set GRADE to 'EOCT' for ALG1 and GEOM.
Colorado_Data_LONG_2019[, GRADE_REPORTED := GRADE]
Colorado_Data_LONG_2019[CONTENT_AREA %in% c("ALGEBRA_I", "GEOMETRY", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2"), GRADE := "EOCT"]

table(Colorado_Data_LONG_2019[, GRADE, CONTENT_AREA])

#  Establish ACHIEVEMENT_LEVEL for PSAT/SAT
Colorado_Data_LONG_2019 <- SGP:::getAchievementLevel(Colorado_Data_LONG_2019, state="CO")
Colorado_Data_LONG_2019[ACHIEVEMENT_LEVEL=='NA', ACHIEVEMENT_LEVEL := "No Score"]
table(Colorado_Data_LONG_2019[, ACHIEVEMENT_LEVEL, VALID_CASE])
