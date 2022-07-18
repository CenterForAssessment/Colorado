##############################################################################
###                                                                        ###
###             Colorado 2022 Cohort and Baseline SGP analyses             ###
###              * Includes 2019 consecutive-year baselines *              ###
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
###   PART A -- 2019 Consecutive Year Baseline SGPs
#####

###   Rename the skip-year SGP variables and objects

##    We can simply rename the BASELINE variables. We only have 2019/21 skip yr
# table(Colorado_SGP@Data[!is.na(SGP_BASELINE),
#         .(CONTENT_AREA, YEAR), GRADE], exclude = NULL)
baseline.names <- grep("BASELINE", names(Colorado_SGP@Data), value = TRUE)
setnames(Colorado_SGP@Data,
         baseline.names,
         paste0(baseline.names, "_SKIP_YEAR"))

sgps.2019 <- grep(".2019.BASELINE", names(Colorado_SGP@SGP[["SGPercentiles"]]))
names(Colorado_SGP@SGP[["SGPercentiles"]])[sgps.2019] <-
    gsub(".2019.BASELINE",
         ".2019.SKIP_YEAR_BLINE",
         names(Colorado_SGP@SGP[["SGPercentiles"]])[sgps.2019])


###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2022/PART_A/ELA.R")
source("SGP_CONFIG/2022/PART_A/MATHEMATICS.R")

CO_Baseline_Config_2019 <- c(
  ELA.2019.config,
  ELA_PSAT_9.2019.config,
  ELA_PSAT_10.2019.config,
  ELA_SAT.2019.config,

  MATHEMATICS.2019.config,
  MATHEMATICS_PSAT_9.2019.config,
  MATHEMATICS_PSAT_10.2019.config,
  MATHEMATICS_SAT.2019.config
)

###   Parallel Config
parallel.config <- list(BACKEND = "PARALLEL",
                        WORKERS = list(
                            BASELINE_PERCENTILES = 12,
                            PROJECTIONS = 6, LAGGED_PROJECTIONS = 4))

###   Run abcSGP analysis
Colorado_SGP <-
    abcSGP(sgp_object = Colorado_SGP,
           years = "2019",
           steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
           sgp.config = CO_Baseline_Config_2019,
           sgp.percentiles = FALSE,
           sgp.projections = FALSE,
           sgp.projections.lagged = FALSE,
           sgp.percentiles.baseline = TRUE,
           sgp.projections.baseline = TRUE,
           sgp.projections.lagged.baseline = TRUE,
           simulate.sgps = FALSE,
           parallel.config = parallel.config)

##  Changed renaming of results above from '.2019.SKIP_YEAR_BASELINE' to .2019.SKIP_YEAR_BLINE
# table(Colorado_SGP@Data[YEAR == "2019" & is.na(SGP) & !is.na(SGP_BASELINE),
#                           as.character(SGP_NORM_GROUP_BASELINE)])

# table(Colorado_SGP@Data[YEAR == "2019" & is.na(SGP) & !is.na(SGP_BASELINE),
#                           SGP_BASELINE == SGP_BASELINE_SKIP_YEAR])

# Colorado_SGP@Data[YEAR == "2019" & is.na(SGP) & !is.na(SGP_BASELINE),
#                     SGP_BASELINE := NA]

#####
###   PART B -- 2022 Cohort and Baseline SGP Analyses
#####

###   Load data
load("Data/Colorado_Data_LONG_2022.Rdata")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2022/PART_B/ELA.R")
source("SGP_CONFIG/2022/PART_B/MATHEMATICS.R")

CO_Config_2022 <- c(
  ELA_2022.config,
  ELA_PSAT_9_2022.config,
  ELA_PSAT_10_2022.config,
  ELA_SAT_2022.config,

  MATHEMATICS_2022.config,
  MATHEMATICS_PSAT_9_2022.config,
  MATHEMATICS_PSAT_10_2022.config,
  MATHEMATICS_SAT_2022.config
)

###   Parallel Config
parallel.config <- list(BACKEND = "PARALLEL",
                        WORKERS = list(
                            PERCENTILES = 12, BASELINE_PERCENTILES = 12,
                            PROJECTIONS = 6, LAGGED_PROJECTIONS = 4))

###   Run updateSGP analysis
Colorado_SGP <-
  updateSGP(what_sgp_object = Colorado_SGP,
            with_sgp_data_LONG = Colorado_Data_LONG_2022,
            years = "2022",
            steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
            sgp.config = CO_Config_2022,
            sgp.percentiles = TRUE,
            sgp.projections = FALSE,  #  Only Baselines due to checkered priors
            sgp.projections.lagged = FALSE,
            sgp.percentiles.baseline = TRUE,
            sgp.projections.baseline = TRUE,
            sgp.projections.lagged.baseline = TRUE,
            sgp.target.scale.scores = FALSE, ## Fails due to checkered priors
            outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
            save.intermediate.results = FALSE,
            parallel.config = parallel.config)

###   Save results

##    Don't save until PSAT/SAT data is available
save(Colorado_SGP, file = "Data/Colorado_SGP.Rdata")
