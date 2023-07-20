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

#####
###   2023 CMAS SGP Analyses
#####

###   Load data
load("Data/Colorado_CMAS_Data_2023.Rdata")

###   Read in SGP configuration scripts and combine
source("SGP_CONFIG/2023/ELA.R")
source("SGP_CONFIG/2023/MATHEMATICS.R")
source("SGP_CONFIG/2023/CO_Proj_Sequences_2023.R")

CO_Config_2023 <- c(
    ELA_2023.config,
    MATHEMATICS_2023.config
)

###   Parallel Config
parallel.config <-
    list(
        BACKEND = "PARALLEL",
        WORKERS = list(
            PERCENTILES = 10, BASELINE_PERCENTILES = 10,
            PROJECTIONS = 8, LAGGED_PROJECTIONS = 8)
    )

###   Run updateSGP analysis
Colorado_SGP <-
    updateSGP(
        what_sgp_object = Colorado_SGP,
        with_sgp_data_LONG = Colorado_CMAS_Data_2023,
        # years = "2023",
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"), # "outputSGP"),
        sgp.config = CO_Config_2023,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        sgp.target.scale.scores = TRUE,
        # outputSGP.output.type = "LONG_Data", # for verification & ISRs
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
    )


#####
###   2023 PSAT/SAT SGP Analyses
#####

###   Load data
load("Data/Colorado_PSAT_Data_2023.Rdata")

###   Combine P/SAT SGP configuration scripts
CO_Config_2023 <- c(
    # ELA_PSAT_9_2023.config,
    ELA_PSAT_10_2023.config,
    ELA_SAT_2023.config,

    MATHEMATICS_PSAT_9_2023.config,
    MATHEMATICS_PSAT_10_2023.config,
    MATHEMATICS_SAT_2023.config
)

###   Run updateSGP analysis
Colorado_SGP <-
    updateSGP(
        what_sgp_object = Colorado_SGP,
        with_sgp_data_LONG = Colorado_PSAT_Data_2023,
        overwrite.existing.data = FALSE,
        # output.updated.data = FALSE,
        # years = "2023",
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = CO_Config_2023,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = TRUE, # requested for on-track-growth research
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
    )


###   Save results with all CMAS and PSAT/SAT results
save(Colorado_SGP, file = "Data/Colorado_SGP.Rdata")
