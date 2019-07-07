################################################################################
###                                                                          ###
###           Calculate SGPs for Colorado (CMAS/PSAT/SAT)  -   2019          ###
###                                                                          ###
################################################################################

###   Load required packages

require(SGP)
require(data.table)

###   Load data
load("Data/Colorado_SGP.Rdata")
load("Data/Colorado_Data_LONG_2019.Rdata")

###   Read in 2018 P/SAT and All 2019 SGP Configuration Scripts and Combine
source("SGP_CONFIG/2019/ELA.R")
source("SGP_CONFIG/2019/MATHEMATICS.R")

COLO_2019.config <- c(
	ELA.2019.config,
	MATHEMATICS.2019.config
)


###
###    updateSGP - To produce CMAS SG Percentiles
###

Colorado_SGP <- updateSGP(
		what_sgp_object=Colorado_SGP,
	  with_sgp_data_LONG=Colorado_Data_LONG_2019,
		sgp.config = COLO_2019.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"), # ,  "summarizeSGP"
		sgp.percentiles = TRUE,
		sgp.projections = FALSE,
		sgp.projections.lagged = FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		# goodness.of.fit.print = FALSE,
	  # sgp.test.cohort.size = 2500,
	  # return.sgp.test.results = TRUE,
	  outputSGP.directory="Data/Archive/2019_CMAS",
		save.intermediate.results=FALSE,
		parallel.config = list(
			BACKEND="PARALLEL", WORKERS=list(PERCENTILES=10)))

###  Save 2018 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")


###
###   PSAT/SAT
###

###   Load data
load("Data/Colorado_SGP.Rdata")

###   Read in 2018 P/SAT and All 2019 SGP Configuration Scripts and Combine
source("SGP_CONFIG/2019/ELA.R")
source("SGP_CONFIG/2019/MATHEMATICS.R")

COLO_2019.config <- c(
	ELA_PSAT_9.2019.config,
	ELA_PSAT_10.2019.config,
	ELA_SAT.2019.config,

	ALGEBRA_I.2019.config,
	GEOMETRY.2019.config,
	MATHEMATICS_PSAT_9.2019.config,
	MATHEMATICS_PSAT_10.2019.config,
	MATHEMATICS_SAT.2019.config
)

###
###    updateSGP - To produce P/SAT SG Percentiles
###

Colorado_SGP <- updateSGP(
		what_sgp_object=Colorado_SGP,
	  with_sgp_data_LONG=Colorado_SAT_Data_LONG_2019,
		sgp.config = COLO_2019.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"), # ,  "summarizeSGP"
		sgp.percentiles = TRUE,
		sgp.projections = FALSE,
		sgp.projections.lagged = FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		goodness.of.fit.print = FALSE,
	  sgp.test.cohort.size = 2500,
	  return.sgp.test.results = TRUE,
	  outputSGP.directory="Data/Archive/2019_SAT",
		save.intermediate.results=FALSE,
		parallel.config = list(
			BACKEND="PARALLEL", WORKERS=list(PERCENTILES=14)))

###
###    analyzeSGP - Calculate SG Projections for all students
###

COLO_2019.config <- c(
	ELA.2019.config,
	ELA_PSAT_9.2019.config,
	ELA_PSAT_10.2019.config,
	ELA_SAT.2019.config,

	MATHEMATICS.2019.config,
	MATHEMATICS_PSAT_9.2019.config,
	MATHEMATICS_PSAT_10.2019.config,
	MATHEMATICS_SAT.2019.config
)

Colorado_SGP <- analyzeSGP(
		Colorado_SGP,
		sgp.config = COLO_2018.config,
		sgp.percentiles = FALSE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		parallel.config = list(
			BACKEND="PARALLEL", WORKERS=list(PROJECTIONS=12, LAGGED_PROJECTIONS=10)))

###
###   summarizeSGP
###

Colorado_SGP <- summarizeSGP(
	Colorado_SGP,
	parallel.config=list(
		BACKEND="PARALLEL", WORKERS=list(SUMMARY=10))
)

###  Save 2018 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")

###  visualizeSGP for bubblePlot and growthAchievementPlot

visualizeSGP(Colorado_SGP,
		plot.types = c("bubblePlot", "growthAchievementPlot"),
		bPlot.years= "2019",
		bPlot.content_areas=c("ELA", "MATHEMATICS"),
		bPlot.anonymize=TRUE,
		gaPlot.years = "2019",
		gaPlot.max.order.for.progression=2,
		parallel.config=list(
			BACKEND='FOREACH', TYPE="doParallel",
			WORKERS=list(GA_PLOTS=5))
)
