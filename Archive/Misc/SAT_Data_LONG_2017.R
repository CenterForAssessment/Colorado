#########################################################################
###                                                                   ###
###               Prep file for 2017 Colorado LONG data               ###
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

  if (substring(fread.args, 1, 1) != ",") fread.args <- paste(",", fread.args)
	TMP <-  eval(parse(text=paste0("data.table::fread('", grep(basename(my.file), list.files(), value=TRUE), "'", fread.args, ")")))
	unlink(grep(basename(my.file), list.files(), value=TRUE))
	setwd(tmp.dir)
	return(TMP)
}

SAT_Data_LONG_2017 <- read.zip(file="Data/Base_Files/SAT_2016_2017_growth readin_EDWP_07_26_2017.zip", fread.args="colClasses=rep('character', 24)")


### Tidy up data

# Rename YR
setnames(SAT_Data_LONG_2017, "YR", "YEAR")

SAT_Data_LONG_2017[CONTENT_AREA=="MAT" & GRADE==10, CONTENT_AREA:="MATHEMATICS"]
SAT_Data_LONG_2017[CONTENT_AREA=="MAT" & GRADE==11, CONTENT_AREA:="MATHEMATICS"]

#  Convert SCALE_SCORE variable to numeric
SAT_Data_LONG_2017[, SCALE_SCORE:=as.numeric(SCALE_SCORE)]
SAT_Data_LONG_2017[, SCALE_SCORE_ORIGINAL:=SCALE_SCORE]

## Resolve duplicates
setkey(SAT_Data_LONG_2017, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(SAT_Data_LONG_2017, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
# dups <- data.table(SAT_Data_LONG_2017[unique(c(which(duplicated(SAT_Data_LONG_2017, by=key(SAT_Data_LONG_2017)))-1, which(duplicated(SAT_Data_LONG_2017, by=key(SAT_Data_LONG_2017))))), ], key=key(SAT_Data_LONG_2017))
# # All 2017 duplicates within GRADE are already INVALID_CASEs - many with NA scores.
# SAT_Data_LONG_2017[which(duplicated(SAT_Data_LONG_2017, by=key(SAT_Data_LONG_2017))), VALID_CASE:="INVALID_CASE"]

#  Save 2017 Data
save(SAT_Data_LONG_2017, file="Data/SAT_Data_LONG_2017.Rdata")
