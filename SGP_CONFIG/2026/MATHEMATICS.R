###############################################################################
###                                                                         ###
###          Colorado configurations for Spring 2026 Math subjects          ###
###                                                                         ###
###############################################################################

###    CMAS MATHEMATICS

MATHEMATICS_2026.config <- list(
    MATHEMATICS.2026 = list(
        sgp.content.areas = c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
        sgp.panel.years = c("2024", "2025", "2026"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
    )
)


###    PSAT/SAT MATHEMATICS

MATHEMATICS_PSAT_9_2026.config <- list(
    MATHEMATICS_PSAT_9_2026 = list(
        sgp.content.areas =
            c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
        sgp.panel.years = c("2024", "2025", "2026"),
        sgp.grade.sequences = list(c("7", "8", "9"))
    )
)

MATHEMATICS_PSAT_10_2026.config <- list(
    MATHEMATICS_PSAT_10_2026 = list(
        sgp.content.areas =
            c("MATHEMATICS", "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
        sgp.panel.years = c("2024", "2025", "2026"),
        sgp.grade.sequences = list(c("8", "9", "10"))
    )
)

MATHEMATICS_SAT_2026.config <- list(
    MATHEMATICS_SAT_2026 = list(
        sgp.content.areas =
            c("MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
        sgp.panel.years = c("2024", "2025", "2026"),
        sgp.grade.sequences = list(c("9", "10", "11"))
    )
)
