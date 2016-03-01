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


###  Read in 2015 SGP Configuration Scripts and Combine

source("/media/Data/Dropbox/Github_Repos/Projects/Colorado/SGP_CONFIG/2015/ELA.R")
source("/media/Data/Dropbox/Github_Repos/Projects/Colorado/SGP_CONFIG/2015/MATHEMATICS.R")

COLO_2015.config <- c(
		MATHEMATICS_2015.config,
		ELA_2015.config)

SGPstateData[["CO"]][["SGP_Configuration"]][["return.norm.group.scale.scores"]] <- TRUE

### updateSGP

Colorado_SGP <- updateSGP(
		what_sgp_object=Colorado_SGP,
		with_sgp_data_LONG=Colorado_Data_LONG_2015,
		sgp.config = COLO_2015.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"),
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


###  Save 2015 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")
