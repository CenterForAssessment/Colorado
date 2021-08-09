################################################################################
###                                                                          ###
###       SGP STRAIGHT projections for skip year SGP analyses for 2021       ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Colorado_SGP.Rdata")

###   Load configurations
source("SGP_CONFIG/2021/PART_B/ELA.R")
source("SGP_CONFIG/2021/PART_B/MATHEMATICS.R")

CO_CONFIG <- c(
    ELA_2021.config,
    ELA_PSAT_2021.config,

    MATHEMATICS_2021.config,
    MATHEMATICS_PSAT_2021.config
)

###   Parallel Config
parallel.config <- list(BACKEND="PARALLEL",
                        WORKERS=list(
                          PERCENTILES=8, BASELINE_PERCENTILES=8,
                          PROJECTIONS=8, LAGGED_PROJECTIONS=8,
                          SGP_SCALE_SCORE_TARGETS=8))

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("CO", "2021")
SGPstateData[["CO"]][["SGP_Configuration"]][["sgp.target.scale.scores.merge"]] <- NULL
# SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL

#  Establish required meta-data for STRAIGHT projection sequences
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    ELA_GRADE_3=c(3, 4, 5, 6, 7, 8, 9, 10),
    ELA_GRADE_4=c(3, 4, 5, 6, 7, 8, 9, 10),
    ELA_GRADE_5=c(3, 4, 5, 6, 7, 8, 9, 10),
    ELA_GRADE_6=c(3, 4, 5, 6, 7, 8, 9, 10),
    ELA_GRADE_7=c(3, 4, 5, 6, 7, 8, 9, 10),
    ELA_GRADE_8=c(3, 4, 5, 6, 7, 8, 9, 10),
    ELA_PSAT_9= c(3, 4, 5, 6, 7, 8, 9, 10),
    ELA_PSAT_10=c(3, 4, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_GRADE_3=c(3, 4, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_GRADE_4=c(3, 4, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_GRADE_5=c(3, 4, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_GRADE_6=c(3, 4, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_GRADE_7=c(3, 4, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_GRADE_8=c(3, 4, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_PSAT_9 = c(3, 4, 5, 6, 7, 8, 9, 10),
    MATHEMATICS_PSAT_10 = c(3, 4, 5, 6, 7, 8, 9, 10))
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    ELA_GRADE_3=c(rep("ELA", 6), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_GRADE_4=c(rep("ELA", 6), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_GRADE_5=c(rep("ELA", 6), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_GRADE_6=c(rep("ELA", 6), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_GRADE_7=c(rep("ELA", 6), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_GRADE_8=c(rep("ELA", 6), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_PSAT_9= c(rep("ELA", 6), "ELA_PSAT_9", "ELA_PSAT_10"),
    ELA_PSAT_10=c(rep("ELA", 6), "ELA_PSAT_9", "ELA_PSAT_10"),
    MATHEMATICS_GRADE_3=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_GRADE_4=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_GRADE_5=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_GRADE_6=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_GRADE_7=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_GRADE_8=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_PSAT_9= c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    MATHEMATICS_PSAT_10=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"))
SGPstateData[["CO"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    ELA_GRADE_3=4,
    ELA_GRADE_4=4,
    ELA_GRADE_5=4,
    ELA_GRADE_6=4,
    ELA_GRADE_7=4,
    ELA_GRADE_8=4,
    ELA_PSAT_9= 4,
    ELA_PSAT_10=4,
    MATHEMATICS_GRADE_3=4,
    MATHEMATICS_GRADE_4=4,
    MATHEMATICS_GRADE_5=4,
    MATHEMATICS_GRADE_6=4,
    MATHEMATICS_GRADE_7=4,
    MATHEMATICS_GRADE_8=4,
    MATHEMATICS_PSAT_9= 4,
    MATHEMATICS_PSAT_10=4)

###   Run analysis

Colorado_SGP <- abcSGP(
        Colorado_SGP,
        years = "2021", # need to add years now (after adding 2019 baseline projections).  Why?
        steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config=CO_CONFIG,
        sgp.percentiles=FALSE,
        sgp.projections=FALSE,
        sgp.projections.lagged=FALSE,
        sgp.percentiles.baseline=FALSE,
        sgp.projections.baseline=TRUE,
        sgp.projections.lagged.baseline=FALSE,
        sgp.target.scale.scores=TRUE,
        parallel.config=parallel.config
)

###   Save results
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")
