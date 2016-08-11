#########################################################
###
### Calculate SGPs for Colorado - 2016
###
##########################################################

### Load required packages

require(SGP)
require(data.table)

###  Modify the SGPstateData - Different/Additional SGP_Configuration from PARCC defaults

SGPstateData[["CO"]][["SGP_Configuration"]][["sgp.cohort.size"]] <- 2000
SGPstateData[["CO"]][["SGP_Configuration"]][["return.norm.group.scale.scores"]] <- TRUE


###  Load Colorado PARCC 2015 and 2016 data

load("Data/Colorado_Data_LONG_2016.Rdata")


###  Read in 2016 SGP Configuration Scripts and Combine

source("SGP_CONFIG/2016/ELA.R")
source("SGP_CONFIG/2016/MATHEMATICS.R")

COLO_2016.config <- c(
		MATHEMATICS_2016.config,
		ELA_2016.config)

###
###    abcSGP - Two step process to produce SGPs for Adjusted and Unadjusted Scale Scores
###

###  First run analyses using the "Original" Scale Score
Colorado_SGP <- abcSGP(
		sgp_object=Colorado_Data_LONG_2016,
		sgp.config = COLO_2016.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP"), # "summarizeSGP", "outputSGP"
		sgp.percentiles = TRUE,
		sgp.projections = FALSE,
		sgp.projections.lagged = FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		save.intermediate.results=FALSE,
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data", "WIDE_Data"),
		parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=20, PROJECTIONS=10, LAGGED_PROJECTIONS=10, SUMMARY=20))) # Ubuntu/Linux

###  Rename First set of SGPs / SGP related variables
setnames(Colorado_SGP@Data, gsub("SGP", "SGP_ORIG", names(Colorado_SGP@Data)))

###  Rename SCALE_SCORE
setnames(Colorado_SGP@Data, c("SCALE_SCORE", "SCALE_SCORE_ADJUSTED"), c("SCALE_SCORE_ORIGINAL", "SCALE_SCORE"))

###  Re-run abcSGP using Colorado_SGP object

Colorado_SGP <- abcSGP(
		sgp_object=Colorado_SGP,
		sgp.config = COLO_2016.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP"), # "summarizeSGP", "outputSGP"
		sgp.percentiles = TRUE,
		sgp.projections = FALSE,
		sgp.projections.lagged = FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		save.intermediate.results=FALSE,
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data", "WIDE_Data"),
		parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=20))) # Ubuntu/Linux

table(Colorado_SGP@Data[, is.na(SGP), is.na(SGP_ORIG)])
Colorado_SGP@Data[!is.na(SGP), list(R=cor(SGP, SGP_ORIG, use='complete')), keyby=c("CONTENT_AREA", "GRADE")]

###  Save 2016 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")


###
###    analyzeSGP to create SGP projections
###


###
###    Summarize Results
###

Colorado_SGP <- summarizeSGP(
	Colorado_SGP,
	parallel.config=list(
		BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, 
		WORKERS=list(SUMMARY=12))
)



###
###    Visualize Results
###

visualizeSGP(Colorado_SGP,
	plot.types = "bubblePlot",
	bPlot.years=  "2016",
	bPlot.content_areas=c("ELA", "MATHEMATICS"),
	bPlot.anonymize=TRUE)

