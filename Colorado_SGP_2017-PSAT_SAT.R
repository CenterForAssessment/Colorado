############################################################
###                                                      ###
###          Calculate SGPs for Colorado - 2017          ###
###                                                      ###
############################################################

### Load required packages

require(SGP)
require(data.table)


###  Load data

load("Data/Colorado_SGP.Rdata")
load("Data/Colorado_Data_LONG_2017-PSAT_SAT.Rdata")

###  Read in 2017 SGP Configuration Scripts and Combine

source("SGP_CONFIG/2017/ELA_SS.R")
source("SGP_CONFIG/2017/MATHEMATICS_SS.R")

COLO_2017.config <- c(
	ELA_PSAT.2016_2017.2.config,
	ELA_SAT.2016_2017.2.config,

	MATHEMATICS_PSAT.2016_2017.2.config,
	MATHEMATICS_SAT.2016_2017.2.config
)


###  Edit SGPstateData metadata

###  Add in the single year data sample computed Knots and Boundaries (add to SGPstateData only after 2-3 years available)
kbs <- createKnotsBoundaries(Colorado_Data_LONG_2017)
SGPstateData[["CO"]][["Achievement"]][["Knots_Boundaries"]] <- c(SGPstateData[["CO"]][["Achievement"]][["Knots_Boundaries"]], kbs)

###  Remove the SGP_Configuration projections info.  This conflicts with the getKnotsBoundaries function.
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- NULL
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- NULL
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <- NULL

###
###    updateSGP - To produce SG Percentiles
###

my.workers <- 12  #  Number of CPU cores for parallel calculations.

Colorado_SGP <- updateSGP(
		Colorado_SGP,
		Colorado_Data_LONG_2017,
		sgp.config = COLO_2017.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"),
		sgp.projections = FALSE,
		sgp.projections.lagged = FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		save.intermediate.results=FALSE,
		overwrite.existing.data=FALSE,
		update.old.data.with.new=FALSE,
		output.updated.data=FALSE,
		parallel.config = list(
			BACKEND="PARALLEL", WORKERS=list(PERCENTILES=my.workers, SUMMARY = my.workers)))

# table(Colorado_SGP@Data[grep("2015_2016.2/MATHEMATICS_PSAT_10; 2016_2017.2/MATHEMATICS_SAT_11", SGP_NORM_GROUP), as.character(SGP_NORM_GROUP)])

###  Save 2017 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")
