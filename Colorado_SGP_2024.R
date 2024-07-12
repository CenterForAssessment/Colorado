##############################################################################
###                                                                        ###
###             Colorado 2024 Cohort and Baseline SGP analyses             ###
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

#####
###   2024 CMAS SGP Analyses
#####

###   Load data
load("Data/Colorado_CMAS_Data_2024.Rdata")

###   Read in SGP configuration scripts and combine
source("SGP_CONFIG/2024/ELA.R")
source("SGP_CONFIG/2024/MATHEMATICS.R")
source("SGP_CONFIG/2024/CO_Proj_Sequences_2024.R")

CO_Config_2024 <- c(
    ELA_2024.config,
    MATHEMATICS_2024.config
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
        with_sgp_data_LONG = Colorado_CMAS_Data_2024,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"), # "outputSGP"),
        sgp.config = CO_Config_2024,
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

###   Add R session Info & Save results (`cfaDocs` version 0.0-1.12 or later)
source(
    system.file(
        "rmarkdown", "shared_resources", "rmd", "R_Session_Info.R",
        package = "cfaDocs"
    )
)

Colorado_SGP@Version$session_platform <- list("2024" = session_platform)
Colorado_SGP@Version$attached_pkgs    <- list("2024" = attached_pkgs)
Colorado_SGP@Version$namespace_pkgs   <- list("2024" = namespace_pkgs)

###   Save results with all CMAS and PSAT/SAT results
save(Colorado_SGP, file = "Data/Colorado_SGP.Rdata")


#####
###   2024 PSAT/SAT SGP Analyses
#####

###   Load data
load("Data/Colorado_PSAT_Data_2024.Rdata")

###   Combine P/SAT SGP configuration scripts
CO_Config_2024 <- c(
    ELA_PSAT_9_2024.config,
    ELA_PSAT_10_2024.config,
    ELA_SAT_2024.config,

    MATHEMATICS_PSAT_9_2024.config,
    MATHEMATICS_PSAT_10_2024.config,
    MATHEMATICS_SAT_2024.config
)

###   Run updateSGP analysis
Colorado_SGP <-
    updateSGP(
        what_sgp_object = Colorado_SGP,
        with_sgp_data_LONG = Colorado_PSAT_Data_2024,
        overwrite.existing.data = FALSE,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = CO_Config_2024,
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


###   Add R session Info & Save results (`cfaDocs` version 0.0-1.12 or later)
source(
    system.file(
        "rmarkdown", "shared_resources", "rmd", "R_Session_Info.R",
        package = "cfaDocs"
    )
)
Colorado_SGP@Version$session_platform <- list("2024" = session_platform)
Colorado_SGP@Version$attached_pkgs    <- list("2024" = attached_pkgs)
Colorado_SGP@Version$namespace_pkgs   <- list("2024" = namespace_pkgs)

###   Save results with all CMAS and PSAT/SAT results
save(Colorado_SGP, file = "Data/Colorado_SGP.Rdata")
