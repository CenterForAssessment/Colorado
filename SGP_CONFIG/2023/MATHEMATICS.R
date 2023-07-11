###############################################################################
###                                                                         ###
###          Colorado configurations for Spring 2023 Math subjects          ###
###                                                                         ###
###############################################################################

###    CMAS MATHEMATICS

MATHEMATICS_2023.config <- list(
    MATHEMATICS.2023 = list(
        sgp.content.areas = c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
        sgp.panel.years = c("2021", "2022", "2023"),
        sgp.grade.sequences = list(
            c("3", "4"), c("4", "5"), c("4", "5", "6"),
            c("6", "7"), c("6", "7", "8"))
    )
)


###    PSAT/SAT MATHEMATICS

MATHEMATICS_PSAT_9_2023.config <- list(
    MATHEMATICS_PSAT_9_2023 = list(
        sgp.content.areas = c("MATHEMATICS", "MATHEMATICS_PSAT_9"),
        sgp.panel.years = c("2022", "2023"),
        sgp.grade.sequences = list(c("8", "9"))
    )
        # sgp.content.areas = c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
        # sgp.panel.years = c("2021", "2022", "2023"),
        # sgp.grade.sequences = list(c("7", "8", "9")))
)

MATHEMATICS_PSAT_10_2023.config <- list(
    MATHEMATICS_PSAT_10_2023 = list(
        sgp.content.areas =
            c("MATHEMATICS", "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
        sgp.panel.years = c("2021", "2022", "2023"),
        sgp.grade.sequences = list(c("8", "9", "10"))
    )
)

MATHEMATICS_SAT_2023.config <- list(
    MATHEMATICS_SAT_2023 = list(
        sgp.content.areas =
            c("MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
        sgp.panel.years = c("2021", "2022", "2023"),
        sgp.grade.sequences = list(c("9", "10", "11"))
    )
)
