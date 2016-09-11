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
# SGPstateData[["CO"]][["SGP_Configuration"]][["rq.method"]] <- 'br' # Leave as 'fn' per Marie 9/9/16


###  Load Colorado PARCC 2015 and 2016 data

load("Data/Colorado_Data_LONG_2016.Rdata")

###  Rename SCALE_SCORE
setnames(Colorado_Data_LONG_2016, c("SCALE_SCORE", "SCALE_SCORE_ADJUSTED"), c("SCALE_SCORE_ORIGINAL", "SCALE_SCORE"))


###  Read in 2016 SGP Configuration Scripts and Combine

source("SGP_CONFIG/2016/ELA.R")
source("SGP_CONFIG/2016/MATHEMATICS.R")

COLO_2016.config <- c(
		MATHEMATICS_2016.config,
		ELA_2016.config)

###
###    abcSGP - Two step process to produce SGPs for Adjusted and Unadjusted Scale Scores
###

Colorado_SGP <- abcSGP(
		sgp_object=Colorado_Data_LONG_2016,
		sgp.config = COLO_2016.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"), # "summarizeSGP", "outputSGP"
		sgp.percentiles = TRUE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		save.intermediate.results=FALSE,
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data", "WIDE_Data"),
		parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=8, PROJECTIONS=8, LAGGED_PROJECTIONS=8))) # Ubuntu/Linux


###  Save 2016 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")


###
###    Summarize Results
###

Colorado_SGP <- summarizeSGP(
	Colorado_SGP,
	parallel.config=list(
		BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, 
		WORKERS=list(SUMMARY=6))
)



###
###    Visualize Results
###

visualizeSGP(Colorado_SGP,
	plot.types = "bubblePlot",
	bPlot.years=  "2015_2016.2",
	# bPlot.content_areas=c("ELA_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
	bPlot.anonymize=TRUE)

