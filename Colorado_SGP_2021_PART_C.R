################################################################################
###                                                                          ###
###        SGP LAGGED projections for skip year SGP analyses for 2021        ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Colorado_SGP.Rdata")

###   Load configurations
source("SGP_CONFIG/2021/PART_C/ELA.R")
source("SGP_CONFIG/2021/PART_C/MATHEMATICS.R")

CO_CONFIG <- c(
    ELA_2021.config,
    ELA_PSAT_2021.config,

    MATHEMATICS_2021.config,
    MATHEMATICS_PSAT_2021.config
)

###   Parallel Config
parallel.config <- list(BACKEND="PARALLEL",
                        WORKERS=list(LAGGED_PROJECTIONS=8)) # SGP_SCALE_SCORE_TARGETS=8

###   Setup SGPstateData with baseline coefficient matrices grade specific projection sequences

###   Add Baseline matrices to SGPstateData and update SGPstateData
SGPstateData <- addBaselineMatrices("CO", "2021")
SGPstateData[["CO"]][["Growth"]][["System_Type"]] <- "Baseline Referenced"
# SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL

#  Establish required meta-data for LAGGED projection sequences
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    ELA_GRADE_3=c(3, 4, 5, 6, 7, 8, 9, 10),
    ELA_GRADE_4=c(3, 4, 5, 6, 7, 8, 9, 10),
    ELA_GRADE_5=c(3, 5, 6, 7, 8, 9, 10),
    ELA_GRADE_6=c(3, 4, 6, 7, 8, 9, 10),
    ELA_GRADE_7=c(3, 4, 5, 7, 8, 9, 10),
    ELA_GRADE_8=c(3, 4, 5, 6, 8, 9, 10),
    ELA_PSAT_9= c(6, 7, 9, 10),
    ELA_PSAT_10=c(7, 8, 10),
    MATHEMATICS_GRADE_3=c(3, 4, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_GRADE_4=c(3, 4, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_GRADE_5=c(3, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_GRADE_6=c(3, 4, 6, 7, 8, 9, 10),
    MATHEMATICS_GRADE_7=c(3, 4, 5, 7, 8, 9, 10),
    MATHEMATICS_GRADE_8=c(3, 4, 5, 6, 8, 9, 10),
    MATHEMATICS_PSAT_9= c(6, 7, 9, 10),
    MATHEMATICS_PSAT_10=c(7, 8, 10))
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    ELA_GRADE_3=c(rep("ELA", 6), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_GRADE_4=c(rep("ELA", 6), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_GRADE_5=c(rep("ELA", 5), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_GRADE_6=c(rep("ELA", 5), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_GRADE_7=c(rep("ELA", 5), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_GRADE_8=c(rep("ELA", 5), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_PSAT_9= c(rep("ELA", 2), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_PSAT_10=c(rep("ELA", 2), "ELA_PSAT_10"),
    MATHEMATICS_GRADE_3=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_GRADE_4=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_GRADE_5=c(rep("MATHEMATICS", 5), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_GRADE_6=c(rep("MATHEMATICS", 5), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_GRADE_7=c(rep("MATHEMATICS", 5), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_GRADE_8=c(rep("MATHEMATICS", 5), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_PSAT_9= c(rep("MATHEMATICS", 2), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_PSAT_10=c(rep("MATHEMATICS", 2), "MATHEMATICS_PSAT_10"))
SGPstateData[["CO"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    ELA_GRADE_3=4,
    ELA_GRADE_4=4,
    ELA_GRADE_5=4,
    ELA_GRADE_6=4,
    ELA_GRADE_7=4,
    ELA_GRADE_8=4,
    ELA_PSAT_9= 2,
    ELA_PSAT_10=1,
    MATHEMATICS_GRADE_3=4,
    MATHEMATICS_GRADE_4=4,
    MATHEMATICS_GRADE_5=4,
    MATHEMATICS_GRADE_6=4,
    MATHEMATICS_GRADE_7=4,
    MATHEMATICS_GRADE_8=4,
    MATHEMATICS_PSAT_9= 2,
    MATHEMATICS_PSAT_10=1)

SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_PSAT_9"]] <- c(1,2,1)
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_PSAT_10"]] <- c(1,2)
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_PSAT_9"]] <- c(1,2,1)
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_PSAT_10"]] <- c(1,2)


### Run analysis

Colorado_SGP <- abcSGP(
        Colorado_SGP,
        steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config=CO_CONFIG,
        sgp.percentiles=FALSE,
        sgp.projections=FALSE,
        sgp.projections.lagged=FALSE,
        sgp.percentiles.baseline=FALSE,
        sgp.projections.baseline=FALSE,
        sgp.projections.lagged.baseline=TRUE,
        sgp.target.scale.scores=FALSE, ## Fails for CO due to checkered subject/grade testing and P/SAT baseline matrix availability
        parallel.config=parallel.config
)

###   Save results
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")
