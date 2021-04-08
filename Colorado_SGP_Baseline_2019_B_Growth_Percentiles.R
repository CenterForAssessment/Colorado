################################################################################
###                                                                          ###
###   Colorado Learning Loss Analyses -- 2019 Baseline Growth Percentiles    ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)

###   Load data and remove years that will not be used.
load("Data/Archive/2019_PreCOVID/Colorado_SGP_LONG_Data.Rdata")
# Colorado_Data_LONG <- data.table::data.table(Colorado_SGP_LONG_Data[YEAR > 2015, ]) # Keep all years for now

###   Add single-cohort baseline matrices to SGPstateData
load("Data/CO_Baseline_Matrices.Rdata")
SGPstateData[["CO"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- CO_Baseline_Matrices

###   Read in BASELINE percentiles configuration scripts and combine
source("SGP_CONFIG/2019/BASELINE/Percentiles/ELA.R")
source("SGP_CONFIG/2019/BASELINE/Percentiles/MATHEMATICS.R")

CO_2019_Baseline_Config <- c(
	ELA_2019.config,
	ELA_PSAT_9_2019.config,
	ELA_PSAT_10_2019.config,

	MATHEMATICS_2019.config,
	MATHEMATICS_PSAT_9_2019.config,
	MATHEMATICS_PSAT_10_2019.config
)

#####
###   Run BASELINE SGP analysis - create new Colorado_SGP object with historical data
#####

###   Temporarily set names of prior scores from sequential/cohort analyses
data.table::setnames(Colorado_SGP_LONG_Data,
	c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"),
	c("SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"))

SGPstateData[["CO"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

Colorado_SGP <- abcSGP(
        sgp_object = Colorado_SGP_LONG_Data,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = CO_2019_Baseline_Config,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,  #  Skip year SGPs for 2021 comparisons
        sgp.projections.baseline = FALSE, #  Calculated in next step
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
					BACKEND = "PARALLEL",
					WORKERS=list(BASELINE_PERCENTILES=8))
)

###   Re-set and rename prior scores (one set for sequential/cohort, another for skip-year/baseline)
data.table::setnames(Colorado_SGP@Data,
  c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"),
  c("SCALE_SCORE_PRIOR_BASELINE", "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"))

###   Save results
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")
