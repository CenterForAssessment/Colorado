#########################################################
###
### Calculate SGPs for Colorado - 2015
###
##########################################################

### Load required packages

require(SGP)
require(data.table)


###  Load NEW Colorado SGP object and 2015 data (if starting new session after data cleaning and new object creation)

load("Data/Colorado_SGP.Rdata")
load("Data/Colorado_Data_LONG_2015.Rdata")

###  Use PARCC Scale Score as "official" Score/SGP per Marie 3/21/16
setnames(Colorado_Data_LONG_2015, c("SCALE_SCORE", "SCALE_SCORE_ACTUAL"), c("THETA_SCORE", "SCALE_SCORE"))


###  Read in 2015 SGP Configuration Scripts and Combine

source("/media/Data/Dropbox/Github_Repos/Projects/Colorado/SGP_CONFIG/2015/ELA.R")
source("/media/Data/Dropbox/Github_Repos/Projects/Colorado/SGP_CONFIG/2015/MATHEMATICS.R")

COLO_2015.config <- c(
		MATHEMATICS_2015.config,
		ELA_2015.config)

###  Winnow out all course progressions with fewer than 2,000 kids (per discussion on 3/14/16)
SGPstateData[["CO"]][["SGP_Configuration"]][["sgp.cohort.size"]] <- 2000

SGPstateData[["CO"]][["SGP_Configuration"]][["return.norm.group.scale.scores"]] <- TRUE

### updateSGP

Colorado_SGP <- updateSGP(
		what_sgp_object=Colorado_SGP,
		with_sgp_data_LONG=Colorado_Data_LONG_2015,
		sgp.config = COLO_2015.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		sgp.percentiles = TRUE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		sgp.percentiles.equated = TRUE,
		simulate.sgps = FALSE,
		goodness.of.fit.print=TRUE,
		save.intermediate.results=FALSE,
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data", "WIDE_Data"),
		parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=20, PROJECTIONS=10, LAGGED_PROJECTIONS=10, SUMMARY=20))) # Ubuntu/Linux


### Fill in ACHIEVEMENT_LEVEL_PRIOR for ELA -- WRITING was the test specified as first prior...
for (pg in 3:10) {
	Colorado_SGP@Data[which(CONTENT_AREA=="ELA" & YEAR=='2015' & GRADE==pg+1 & VALID_CASE=="VALID_CASE"), 
		ACHIEVEMENT_LEVEL_PRIOR := ordered(findInterval(as.numeric(SCALE_SCORE_PRIOR), 
			SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["WRITING"]][[paste("GRADE", pg, sep="_")]]), 
			labels=c("Unsatisfactory", "Partially Proficient", "Proficient", "Advanced"))]
}

# Colorado_SGP@Data[YEAR=='2015' & VALID_CASE=="VALID_CASE" & !is.na(ACHIEVEMENT_LEVEL_PRIOR)][, as.list(summary(SCALE_SCORE_PRIOR)), keyby=list(GRADE, ACHIEVEMENT_LEVEL_PRIOR)]
# Colorado_SGP@Data[YEAR=='2015' & VALID_CASE=="VALID_CASE" & !is.na(ACHIEVEMENT_LEVEL_PRIOR)][, as.list(summary(SCALE_SCORE_PRIOR)), keyby=list(CONTENT_AREA, GRADE, ACHIEVEMENT_LEVEL_PRIOR)]



###  Summarize Results
Colorado_SGP <- summarizeSGP(
	Colorado_SGP,
	parallel.config=list(
		BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, 
		WORKERS=list(SUMMARY=12))
)


visualizeSGP(Colorado_SGP,
	plot.types = "bubblePlot",
	bPlot.years=  "2015",
	bPlot.content_areas=c("ELA", "MATHEMATICS"),
	bPlot.anonymize=TRUE)

###  Save 2015 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")

