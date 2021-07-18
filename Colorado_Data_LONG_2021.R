#########################################################################
###                                                                   ###
###        Prep CMAS/PSAT/SAT data for 2021 Colorado LONG data        ###
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

Colorado_Data_LONG_CMAS_2021 <- read.zip(file="Data/Base_Files/CMAS 2021_Growth_ReadIn_07.03.19.csv.zip", fread.args="colClasses=rep('character', 24)")
Colorado_Data_LONG_PSAT_SAT_2021 <- read.zip("Data/Base_Files/PSAT_SAT_2021_GrowthReadin_Updated_08.03.19.csv.zip", fread.args="colClasses=rep('character', 25)")

###   Tidy up CMAS Data

#   Rename YR
setnames(Colorado_Data_LONG_CMAS_2021, "YR", "YEAR")

#   Re-lable CONTENT_AREA values
Colorado_Data_LONG_CMAS_2021[, CONTENT_AREA := factor(CONTENT_AREA)]
levels(Colorado_Data_LONG_CMAS_2021$CONTENT_AREA) <- c("ELA", "MATHEMATICS")
Colorado_Data_LONG_CMAS_2021[, CONTENT_AREA := as.character(CONTENT_AREA)]

#   Convert SCALE_SCORE variable to numeric
Colorado_Data_LONG_CMAS_2021[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

#   Convert names to factors (temporary to change levels vs values for time/memory saving)
Colorado_Data_LONG_CMAS_2021[, DISTRICT_NAME:=factor(DISTRICT_NAME)]
Colorado_Data_LONG_CMAS_2021[, SCHOOL_NAME:=factor(SCHOOL_NAME)]
Colorado_Data_LONG_CMAS_2021[, FIRST_NAME:=factor(FIRST_NAME)]
Colorado_Data_LONG_CMAS_2021[, LAST_NAME:=factor(LAST_NAME)]

#   Clean up LAST_NAME and FIRST_NAME
setattr(Colorado_Data_LONG_CMAS_2021$LAST_NAME, "levels", sapply(levels(Colorado_Data_LONG_CMAS_2021$LAST_NAME), SGP::capwords))
setattr(Colorado_Data_LONG_CMAS_2021$FIRST_NAME, "levels", sapply(levels(Colorado_Data_LONG_CMAS_2021$FIRST_NAME), SGP::capwords))

####
#   Clean up SCHOOL_NAME and DISTRICT_NAME
#   Check levels first to confirm special.words - Clean Well for ISRs
####

###  Schools
grep("  ", levels(Colorado_Data_LONG_CMAS_2021$SCHOOL_NAME), value=T)

new.sch.levs <- levels(Colorado_Data_LONG_CMAS_2021$SCHOOL_NAME)
new.sch.levs <- gsub("/", " / ", new.sch.levs)

new.sch.levs <- sapply(new.sch.levs, SGP::capwords, special.words = c('AIM', 'AXL', 'CCH', 'CMS', 'DC', 'DCIS', 'DSST', 'DSST:', 'ECE-8', 'GVR', 'IB', 'KIPP', 'PK', 'PK-8', 'PK-12', 'PSD', 'LEAP', 'MHCD', 'STEM', 'TCA', 'VSSA'), USE.NAMES=FALSE)
new.sch.levs <- gsub(" / ", "/", new.sch.levs)
new.sch.levs <- gsub("Prek", "PreK", new.sch.levs)
new.sch.levs <- gsub("Mcauliffe", "McAuliffe", new.sch.levs)
new.sch.levs <- gsub("Mcglone", "McGlone", new.sch.levs)
new.sch.levs <- gsub("Mcgraw", "McGraw", new.sch.levs)
new.sch.levs <- gsub("Mckinley", "McKinley", new.sch.levs)
new.sch.levs <- gsub("Mcmeen", "McMeen", new.sch.levs)
new.sch.levs <- gsub("Mc Clave", "McClave", new.sch.levs)
new.sch.levs <- gsub("Mc Elwain", "McElwain", new.sch.levs)
new.sch.levs <- gsub("Mc Ginnis", "McGinnis", new.sch.levs)
new.sch.levs <- gsub("Achieve Online", "ACHIEVE Online", new.sch.levs)
setattr(Colorado_Data_LONG_CMAS_2021$SCHOOL_NAME, "levels", new.sch.levs)

###  Districts
grep("J", levels(Colorado_Data_LONG_CMAS_2021$DISTRICT_NAME), value=T)
new.dst.levs <- levels(Colorado_Data_LONG_CMAS_2021$DISTRICT_NAME)
new.dst.levs <- gsub("/", " / ", new.dst.levs)
new.dst.levs <- gsub("[-]", " - ", new.dst.levs)

new.dst.levs <- sapply(new.dst.levs, SGP::capwords, special.words = c('1J', '2J', '3J', '4J', '5J', '6J', '11J', '22J', '27J', '28J', '29J', '31J', '33J', '100J', 'JT', '32J', 'RJ', '26J', '49JT', '4A', 'RD', 'RE', 'RE1J'), USE.NAMES=FALSE)
new.dst.levs <- gsub(" / ", "/", new.dst.levs)
new.dst.levs <- gsub(" - ", "-", new.dst.levs)
new.dst.levs <- gsub("Mc Clave", "McClave", new.dst.levs)
grep("j", new.dst.levs, value=T) # Should only leave * Conejos

setattr(Colorado_Data_LONG_CMAS_2021$DISTRICT_NAME, "levels", new.dst.levs)


#   Resolve duplicates
setkey(Colorado_Data_LONG_CMAS_2021, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Colorado_Data_LONG_CMAS_2021, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
# dups <- data.table(Colorado_Data_LONG_CMAS_2021[unique(c(which(duplicated(Colorado_Data_LONG_CMAS_2021, by=key(Colorado_Data_LONG_CMAS_2021)))-1, which(duplicated(Colorado_Data_LONG_CMAS_2021, by=key(Colorado_Data_LONG_CMAS_2021))))), ], key=key(Colorado_Data_LONG_CMAS_2021))
# table(dups$VALID_CASE) # All 2021 duplicates within GRADE are already INVALID_CASEs
# Colorado_Data_LONG_CMAS_2021[which(duplicated(Colorado_Data_LONG_CMAS_2021, by=key(Colorado_Data_LONG_CMAS_2021))), VALID_CASE:="INVALID_CASE"]

##  Save 2021 Data
save(Colorado_Data_LONG_CMAS_2021, file="Data/Colorado_Data_LONG_CMAS_2021.Rdata")

#############################################
###   PSAT/SAT
#############################################

Colorado_Data_LONG_PSAT_SAT_2021[,EDW_DATA_SOURCE:=NULL]

#   Rename YR
setnames(Colorado_Data_LONG_PSAT_SAT_2021, "YR", "YEAR")

Colorado_Data_LONG_PSAT_SAT_2021[CONTENT_AREA=="ELA" & GRADE==9, CONTENT_AREA := "ELA_PSAT_9"]
Colorado_Data_LONG_PSAT_SAT_2021[CONTENT_AREA=="ELA" & GRADE==10, CONTENT_AREA:= "ELA_PSAT_10"]
Colorado_Data_LONG_PSAT_SAT_2021[CONTENT_AREA=="ELA" & GRADE==11, CONTENT_AREA:= "ELA_SAT"]
Colorado_Data_LONG_PSAT_SAT_2021[CONTENT_AREA=="MAT" & GRADE==9, CONTENT_AREA := "MATHEMATICS_PSAT_9"]
Colorado_Data_LONG_PSAT_SAT_2021[CONTENT_AREA=="MAT" & GRADE==10, CONTENT_AREA:= "MATHEMATICS_PSAT_10"]
Colorado_Data_LONG_PSAT_SAT_2021[CONTENT_AREA=="MAT" & GRADE==11, CONTENT_AREA:= "MATHEMATICS_SAT"]

#   Convert names to factors (temporary to change levels vs values for time/memory saving)
Colorado_Data_LONG_PSAT_SAT_2021[, DISTRICT_NAME:=factor(DISTRICT_NAME)]
Colorado_Data_LONG_PSAT_SAT_2021[, SCHOOL_NAME:=factor(SCHOOL_NAME)]
Colorado_Data_LONG_PSAT_SAT_2021[, FIRST_NAME:=factor(FIRST_NAME)]
Colorado_Data_LONG_PSAT_SAT_2021[, LAST_NAME:=factor(LAST_NAME)]

#   Clean up LAST_NAME and FIRST_NAME
setattr(Colorado_Data_LONG_PSAT_SAT_2021$LAST_NAME, "levels", sapply(levels(Colorado_Data_LONG_PSAT_SAT_2021$LAST_NAME), SGP::capwords))
setattr(Colorado_Data_LONG_PSAT_SAT_2021$FIRST_NAME, "levels", sapply(levels(Colorado_Data_LONG_PSAT_SAT_2021$FIRST_NAME), SGP::capwords))

#   Clean up SCHOOL_NAME and DISTRICT_NAME
new.sch.levs <- toupper(levels(Colorado_Data_LONG_PSAT_SAT_2021$SCHOOL_NAME))
new.sch.levs <- gsub("/", " / ", new.sch.levs)

new.sch.levs <- sapply(new.sch.levs, SGP::capwords, special.words = c('AIM', 'AXL', 'CCH', 'CMS', 'DC', 'DCIS', 'DSST', 'DSST:', 'ECE-8', 'GVR', 'IB', 'KIPP', 'PK', 'PK-8', 'PK-12', 'PSD', 'LEAP', 'MHCD', 'STEM', 'TCA', 'VSSA', 'PSD', 'GOAL', 'EDCSD', 'COVA', 'GES'), USE.NAMES=FALSE)
new.sch.levs <- gsub(" / ", "/", new.sch.levs)
new.sch.levs <- gsub("Prek", "PreK", new.sch.levs)
new.sch.levs <- gsub("Jeffco", ", 'JeffCo'", new.sch.levs)
new.sch.levs <- gsub("Mcauliffe", "McAuliffe", new.sch.levs)
new.sch.levs <- gsub("Mcglone", "McGlone", new.sch.levs)
new.sch.levs <- gsub("Mcgraw", "McGraw", new.sch.levs)
new.sch.levs <- gsub("Mckinley", "McKinley", new.sch.levs)
new.sch.levs <- gsub("Mcmeen", "McMeen", new.sch.levs)
new.sch.levs <- gsub("Mc Clave", "McClave", new.sch.levs)
new.sch.levs <- gsub("Mc Elwain", "McElwain", new.sch.levs)
new.sch.levs <- gsub("Mc Ginnis", "McGinnis", new.sch.levs)
new.sch.levs <- gsub("Achieve Online", "ACHIEVE Online", new.sch.levs)
setattr(Colorado_Data_LONG_PSAT_SAT_2021$SCHOOL_NAME, "levels", new.sch.levs)

grep("J", levels(Colorado_Data_LONG_PSAT_SAT_2021$DISTRICT_NAME), value=T)
new.dst.levs <- toupper(levels(Colorado_Data_LONG_PSAT_SAT_2021$DISTRICT_NAME))
new.dst.levs <- gsub("/", " / ", new.dst.levs)
new.dst.levs <- gsub("[-]", " - ", new.dst.levs)

new.dst.levs <- sapply(new.dst.levs, SGP::capwords, special.words = c('1J', '2J', '3J', '4J', '5J', '6J', '11J', '22J', '27J', '28J', '29J', '31J', '33J', '100J', 'JT', '32J', 'RJ', '26J', '49JT', '4A', 'RD', 'RE', 'RE1J'), USE.NAMES=FALSE)
new.dst.levs <- gsub(" / ", "/", new.dst.levs)
new.dst.levs <- gsub(" - ", "-", new.dst.levs)
new.dst.levs <- gsub("Mc Clave", "McClave", new.dst.levs)
grep("j", new.dst.levs, value=T) # Should only leave * Conejos
setattr(Colorado_Data_LONG_PSAT_SAT_2021$DISTRICT_NAME, "levels", new.dst.levs)

#  Establish ACHIEVEMENT_LEVEL for PSAT/SAT
Colorado_Data_LONG_PSAT_SAT_2021 <- SGP:::getAchievementLevel(Colorado_Data_LONG_PSAT_SAT_2021, state="CO")
Colorado_Data_LONG_PSAT_SAT_2021[ACHIEVEMENT_LEVEL=='NA', ACHIEVEMENT_LEVEL := "No Score"]
table(Colorado_Data_LONG_PSAT_SAT_2021[, ACHIEVEMENT_LEVEL, VALID_CASE])

#   Resolve duplicates
# setkey(Colorado_Data_LONG_PSAT_SAT_2021, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
# setkey(Colorado_Data_LONG_PSAT_SAT_2021, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
# dups <- data.table(Colorado_Data_LONG_PSAT_SAT_2021[unique(c(which(duplicated(Colorado_Data_LONG_PSAT_SAT_2021, by=key(Colorado_Data_LONG_PSAT_SAT_2021)))-1, which(duplicated(Colorado_Data_LONG_PSAT_SAT_2021, by=key(Colorado_Data_LONG_PSAT_SAT_2021))))), ], key=key(Colorado_Data_LONG_PSAT_SAT_2021))
# table(dups$VALID_CASE) # All 2021 duplicates within GRADE are already INVALID_CASEs
# Colorado_Data_LONG_PSAT_SAT_2021[which(duplicated(Colorado_Data_LONG_PSAT_SAT_2021, by=key(Colorado_Data_LONG_PSAT_SAT_2021))), VALID_CASE:="INVALID_CASE"]

## Save 2021 PSAT_SAT Data
save(Colorado_Data_LONG_PSAT_SAT_2021, file="Data/Colorado_Data_LONG_PSAT_SAT_2021.Rdata")


###   Run CMAS and P/SAT seperately -- Not needed:

## rbind CMAS and PSAT_SAT data and save
# Colorado_Data_LONG_2021 <- rbindlist(list(Colorado_Data_LONG_CMAS_2021, Colorado_Data_LONG_PSAT_SAT_2021), fill=TRUE)
#
## Final tidying up
#
# Colorado_Data_LONG_2021[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
#
#
# setkey(Colorado_Data_LONG_2021, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
# save(Colorado_Data_LONG_2021, file="Data/Colorado_Data_LONG_2021.Rdata")
