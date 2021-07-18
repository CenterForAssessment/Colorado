######################################################################
###                                                                ###
###               Calculate SGPs for Colorado - 2017               ###
###                                                                ###
######################################################################

### Load required packages
require(SGP)
require(data.table)

###  Load data
load("Data/SAT_Data_LONG_2017.Rdata")

###  Create SGPstateData metadata
SGPstateData[["SAT"]][["Achievement"]][["Knots_Boundaries"]] <- createKnotsBoundaries(SAT_Data_LONG_2017)
SGPstateData[["SAT"]][["Growth"]] <- list(System_Type = "Cohort Referenced")
SGPstateData[["SAT"]][["SGP_Configuration"]] <- list(rq.method="fn")

###
###    abcSGP - To produce SG Percentiles
###

my.workers <- 12  #  Number of CPU cores for parallel calculations.
my.sgp.summaries <- list(
    MEAN_SGP="mean_na(SGP, WEIGHT)",
    MEDIAN_SGP="median_na(SGP, WEIGHT)",
    MEDIAN_SGP_COUNT="num_non_missing(SGP)",
    MEAN_SGP_STANDARD_ERROR="sgp_standard_error(SGP)",
    MEDIAN_SGP_STANDARD_ERROR="sgp_standard_error(SGP, 1.253)")

Colorado_SAT_SGP <- abcSGP(state="SAT",
		SAT_Data_LONG_2017,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"),
		sgp.projections = FALSE,
		sgp.projections.lagged = FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		sgp.summaries=my.sgp.summaries,
		save.intermediate.results=FALSE,
		parallel.config = list(
			BACKEND="PARALLEL", WORKERS=list(PERCENTILES=my.workers, SUMMARY = my.workers)))

# table(Colorado_SAT_SGP@Data[grep("2015_2016.2/MATHEMATICS_PSAT_10; 2016_2017.2/MATHEMATICS_SAT_11", SGP_NORM_GROUP), as.character(SGP_NORM_GROUP)])

#
# Colorado_SAT_SGP <- summarizeSGP(
# 	Colorado_SAT_SGP,
# 	sgp.summaries=my.sgp.summaries,
# 	parallel.config=list(
# 		BACKEND="PARALLEL",
# 		WORKERS=list(SUMMARY = my.workers))
# )

###  Save 2017 Colorado SGP object
save(Colorado_SAT_SGP, file="Data/Colorado_SAT_SGP.Rdata")
