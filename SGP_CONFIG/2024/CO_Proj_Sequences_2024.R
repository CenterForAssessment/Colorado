SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
    list(
        ELA         = c("3", "4", "5", "6", "7", "8"),
        ELA_PSAT_9  = c("7", "8", "9", "10", "11"),
        ELA_PSAT_10 = c("7", "8", "9", "10", "11"),
        ELA_SAT     = c("7", "8", "9", "10", "11"),
        MATHEMATICS         = c("3", "4", "5", "6", "7", "8"),
        MATHEMATICS_PSAT_9  = c("7", "8", "9", "10", "11"),
        MATHEMATICS_PSAT_10 = c("7", "8", "9", "10", "11"),
        MATHEMATICS_SAT     = c("7", "8", "9", "10", "11")
    )

SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
    list(
        ELA         = rep("ELA", 6),
        ELA_PSAT_9  = c("ELA", "ELA", "ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT"),
        ELA_PSAT_10 = c("ELA", "ELA", "ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT"),
        ELA_SAT     = c("ELA", "ELA", "ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT"),
        MATHEMATICS         = rep("MATHEMATICS", 6),
        MATHEMATICS_PSAT_9  =
            c("MATHEMATICS", "MATHEMATICS",
            "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
        MATHEMATICS_PSAT_10 =
            c("MATHEMATICS", "MATHEMATICS",
            "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
        MATHEMATICS_SAT     =
            c("MATHEMATICS", "MATHEMATICS",
            "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")
    )

SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <-
    list(
        ELA         = rep(1L, 5),
        ELA_PSAT_9  = rep(1L, 4),
        ELA_PSAT_10 = rep(1L, 4),
        ELA_SAT     = rep(1L, 4),
        MATHEMATICS         = rep(1L, 5),
        MATHEMATICS_PSAT_9  = rep(1L, 4),
        MATHEMATICS_PSAT_10 = rep(1L, 4),
        MATHEMATICS_SAT     = rep(1L, 4)
    )