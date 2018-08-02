################################################################################
###                                                                          ###
###           Calculate SGPs for Colorado (CMAS/PSAT/SAT)  -   2018          ###
###                                                                          ###
################################################################################

###   Load required packages

require(SGP)
require(data.table)


###   Load data
load("Data/Colorado_Data_LONG.Rdata")

###   Read in 2017 P/SAT and All 2018 SGP Configuration Scripts and Combine
source("SGP_CONFIG/2017/PSAT_SAT.R")
source("SGP_CONFIG/2018/ELA.R")
source("SGP_CONFIG/2018/MATHEMATICS.R")

COLO_2018.config <- c(
	# Run 2017 P/SAT SGPs for ISRs
	ELA_PSAT_10.2017.config,
	ELA_SAT.2017.config,

	MATHEMATICS_PSAT_10.2017.config,
	MATHEMATICS_SAT.2017.config,

	ELA.2018.config,
	ELA_PSAT_9.2018.config,
	ELA_PSAT_10.2018.config,
	ELA_SAT.2018.config,

	MATHEMATICS.2018.config,
	ALGEBRA_I.2018.config,
	GEOMETRY.2018.config,
	MATHEMATICS_PSAT_9.2018.config,
	MATHEMATICS_PSAT_10.2018.config,
	MATHEMATICS_SAT.2018.config
)


###
###    abcSGP - To produce SG Percentiles and Projections
###

Colorado_SGP <- abcSGP(
		Colorado_Data_LONG,
		sgp.config = COLO_2018.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP",  "summarizeSGP", "outputSGP"),
		sgp.percentiles = TRUE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		save.intermediate.results=FALSE,
		parallel.config = list(
			BACKEND="PARALLEL", WORKERS=list(PERCENTILES=14, PROJECTIONS=12, LAGGED_PROJECTIONS=10, SUMMARY=12)))

table(Colorado_SGP@Summary$SCHOOL_NUMBER$SCHOOL_NUMBER__CONTENT_AREA__YEAR__GRADE__SCHOOL_ENROLLMENT_STATUS[, YEAR, CONTENT_AREA])

###  Save 2017 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")
