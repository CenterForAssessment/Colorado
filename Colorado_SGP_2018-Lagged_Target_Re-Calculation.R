################################################################################
###                                                                          ###
###   Re-Calculate Lagged Projections for Colorado (CMAS/PSAT/SAT) -  2018   ###
###                                                                          ###
################################################################################

###   Load required packages
require(SGP)
require(data.table)

###   Load data
load("Data/Colorado_Data_LONG.Rdata")

###   Read in 2018 SGP Configuration Scripts and Combine
source("SGP_CONFIG/2018/ELA.R")
source("SGP_CONFIG/2018/MATHEMATICS.R")

COLO_2018.config <- c(
	ELA.2018.config,
	ELA_PSAT_9.2018.config,
	ELA_PSAT_10.2018.config,

	MATHEMATICS.2018.config,
	MATHEMATICS_PSAT_9.2018.config
	MATHEMATICS_PSAT_10.2018.config,
)

###   Remove old LAGGED Targets from Colorado_SGP object
###   NOTE:  Can't get PSAT 10 lagged targets in 2018 - no 2017 PSAT 9 to use in calculations for 2018

Colorado_SGP@SGP$SGProjections <- Colorado_SGP@SGP$SGProjections[-grep("LAGGED", names(Colorado_SGP@SGP$SGProjections))]
# Colorado_SGP@SGP$SGProjections <- NULL  #  Use this to remove all Targets (LAGGED and Straight)


###   Modify SGPstateData with revised (equipercentile) Cutscore levels
###   For 5 Levels of CMAS/PSAT/SAT there will be 4 cuts needed (lowest score for Levels 2-5)

SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["ELA_PSAT_9"]] <- list(GRADE_9 = c(340, 390, 460, 580))
SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["ELA_PSAT_10"]]<- list(GRADE_10= c(360, 410, 490, 600))
SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["ELA_SAT"]] <- list(GRADE_11= c(390, 440, 520, 640))
SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["MATHEMATICS_PSAT_9"]] <- list(GRADE_9 = c(350, 410, 490, 610))
SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["MATHEMATICS_PSAT_10"]]<- list(GRADE_10= c(370, 430, 500, 640))
SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["MATHEMATICS_SAT"]] <- list(GRADE_11= c(380, 460, 540, 710))

# SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]]
# SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_PSAT_10"]] #  Can't get lagged targets in 2018 - no 2017 PSAT 9

###
###    analyzeSGP - To (re) produce SG Projections
###

Colorado_SGP <- analyzeSGP(
		Colorado_SGP,
		sgp.config = COLO_2018.config,
		sgp.percentiles = FALSE,
		sgp.projections = FALSE,
		sgp.projections.lagged = TRUE, #  Only LAGGED projections re-calculated.
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		parallel.config = list(
			BACKEND="PARALLEL", WORKERS=list(LAGGED_PROJECTIONS=4)))
