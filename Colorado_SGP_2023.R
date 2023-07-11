##############################################################################
###                                                                        ###
###             Colorado 2023 Cohort and Baseline SGP analyses             ###
###                                                                        ###
##############################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data
load("Data/Colorado_SGP.Rdata")

###   Add baseline matrices to `SGPstateData`
SGPstateData <- SGPmatrices::addBaselineMatrices("CO", "2021")
SGPstateData[["CO"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

##    Required for different number of priors in some progressions:
SGPstateData[["CO"]][["SGP_Configuration"]][[
    "sgp.projections.use.only.complete.matrices"]] <- FALSE

###   2023 Cohort and Baseline SGP Analyses

###   Load data
load("Data/Colorado_Data_LONG_2023.Rdata")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2023/ELA.R")
source("SGP_CONFIG/2023/MATHEMATICS.R")

CO_Config_2023 <- c(
  ELA_2023.config,
#   ELA_PSAT_9_2023.config,
#   ELA_PSAT_10_2023.config,
#   ELA_SAT_2023.config,

  MATHEMATICS_2023.config#,
#   MATHEMATICS_PSAT_9_2023.config,
#   MATHEMATICS_PSAT_10_2023.config,
#   MATHEMATICS_SAT_2023.config
)

###   Parallel Config
parallel.config <-
    list(BACKEND = "PARALLEL",
         WORKERS = list(
            PERCENTILES = 12, BASELINE_PERCENTILES = 12,
            PROJECTIONS = 12, LAGGED_PROJECTIONS = 12)
        )

###   Run updateSGP analysis
Colorado_SGP <-
    updateSGP(
        what_sgp_object = Colorado_SGP,
        with_sgp_data_LONG = Colorado_Data_LONG_2023,
        years = "2023",
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = CO_Config_2023,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        sgp.target.scale.scores = TRUE,
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
    )

###   Save results

##    Don't save until PSAT/SAT data is available
save(Colorado_SGP, file = "Data/Colorado_SGP.Rdata")
