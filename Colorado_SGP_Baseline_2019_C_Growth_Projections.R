################################################################################
###                                                                          ###
###   Colorado Learning Loss Analyses -- 2019 Baseline Growth Projections    ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)

###   Load data from baseline SGP analyses
load("Data/Colorado_SGP.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
load("Data/CO_Baseline_Matrices.Rdata")
SGPstateData[["CO"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- CO_Baseline_Matrices

###   Read in BASELINE projections configuration scripts and combine
source("SGP_CONFIG/2019/BASELINE/Projections/ELA.R")
source("SGP_CONFIG/2019/BASELINE/Projections/MATHEMATICS.R")

CO_2019_Baseline_Config <- c(
	ELA_2019.config,
	MATHEMATICS_2019.config
)

#####
###   Run projections analysis - run abcSGP on object from BASELINE SGP analysis
#####

###   Update SGPstateData with grade/course/lag progression information
source("SGP_CONFIG/2019/BASELINE/Projections/Skip_Year_Projections_MetaData.R")

Colorado_SGP <- abcSGP(
        sgp_object = Colorado_SGP,
        steps = c("prepareSGP", "analyzeSGP"), # no changes to @Data - don't combine or output
        sgp.config = CO_2019_Baseline_Config,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = TRUE, # Need P50_PROJ_YEAR_1_CURRENT for Ho's Fair Trend/Equity Check metrics
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
					BACKEND = "PARALLEL",
          WORKERS=list(PROJECTIONS=8))
)

###   Save results
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")
