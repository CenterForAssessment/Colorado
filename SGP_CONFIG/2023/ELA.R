###############################################################################
###                                                                         ###
###          Colorado configurations for Spring 2023 ELA subjects           ###
###                                                                         ###
###############################################################################

###    CMAS ELA

ELA_2023.config <- list(
    ELA.2023 = list(
        sgp.content.areas = c("ELA", "ELA", "ELA"),
        sgp.panel.years = c("2021", "2022", "2023"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"), c("5", "6"),
            c("5", "6", "7"), c("7", "8"))
    )
)


###    PSAT/SAT ELA

ELA_PSAT_9_2023.config <- list( # NOT RUN - no ELA grade 8
    ELA_PSAT_9_2023 = list(
        sgp.content.areas = c("ELA", "ELA_PSAT_9"),
        sgp.panel.years = c("2021", "2022", "2023"),
        sgp.grade.sequences = list(c("7", "8", "9"))
    )
)

ELA_PSAT_10_2023.config <- list(
    ELA_PSAT_10_2023 = list(
        sgp.content.areas = c("ELA", "ELA_PSAT_9", "ELA_PSAT_10"),
        sgp.panel.years = c("2021", "2022", "2023"),
        sgp.grade.sequences = list(c("8", "9", "10"))
    )
)

ELA_SAT_2023.config <- list(
    ELA_SAT_2023 = list(
        sgp.content.areas = c("ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT"),
        sgp.panel.years = c("2021", "2022", "2023"),
        sgp.grade.sequences = list(c("9", "10", "11"))
    )
)
