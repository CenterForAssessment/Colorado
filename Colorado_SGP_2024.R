#+ include = FALSE, purl = FALSE, eval = FALSE
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
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
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


#####
###   2024 PSAT/SAT SGP Analyses
#####

###   Load data
load("Data/Colorado_PSAT_Data_2024.Rdata")

###   Combine P/SAT SGP configuration scripts
CO_SAT_Config_2024 <- c(
    # ELA_PSAT_9_2024.config,
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
        sgp.config = CO_SAT_Config_2024,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = TRUE,
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


#' ### Conduct SGP analyses
#'
#' Although Colorado currently uses cohort-referenced SGPs as the official
#' student growth metric, baseline-referenced SGPs were also calculated. All
#' SGPs were calculated concurrently using the [`R` Software Environment](http://www.r-project.org)
#' in conjunction with the [`SGP` package](http://sgp.io). Broadly, the Colorado
#' CMAS analyses were completed in five steps.
#'
#' 1. `prepareSGP`
#' 2. `analyzeSGP`
#' 3. `combineSGP`
#' 4. `outputSGP`
#' 5. `visualizeSGP`
#' 
#' Because these steps are almost always conducted simultaneously, the `SGP`
#' package has "wrapper" functions, `abcSGP` and `updateSGP`, that combine
#' the above steps into a single function call and simplify the source code
#' associated with the data analysis. Documentation for all SGP functions are
#' [available online.](https://cran.r-project.org/web/packages/SGP/SGP.pdf)
#' 
#' We use the [`updateSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-1.0/topics/updateSGP)
#' function to ***a)*** do the final preparation and addition of the cleaned and
#' formatted new annual data,
#' ([`prepareSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-1.0/topics/prepareSGP)
#' step), ***b)*** calculate SGP estimates
#' ([`analyzeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-1.0/topics/analyzeSGP)
#' step), ***c)*** merge the results into the master longitudinal data set
#' ([`combineSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-1.0/topics/combineSGP)
#' step) and ***d)*** output a pipe delimited version of the complete long data
#' ([`outputSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-1.0/topics/outputSGP)
#' step).
#' 
#' #### Visualize results
#' 
#' Once all analyses were completed via `updateSGP`, individual student growth
#' and English language proficiency reports were produced using the
#' [`visualizeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-1.0/topics/visualizeSGP)
#' function and a custom template designed for Colorado. English and Spanish
#' language versions of these reports were created, and individual reports and
#' school level catalogs were bundled according to CDE specifications.
