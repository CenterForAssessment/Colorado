###############################################################################
###                                                                         ###
###          Colorado configurations for Spring 2025 ELA subjects           ###
###                                                                         ###
###############################################################################

###    CMAS ELA

ELA_2025.config <- list(
    ELA.2025 = list(
        sgp.content.areas = c("ELA", "ELA", "ELA"),
        sgp.panel.years = c("2023", "2024", "2025"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
    )
)


###    PSAT/SAT ELA

##  Run in '25 - at least for review/investigation
ELA_PSAT_9_2025.config <- list(
    ELA_PSAT_9_2025 = list(
        sgp.content.areas = c("ELA", "ELA", "ELA_PSAT_9"),
        sgp.panel.years = c("2023", "2024", "2025"),
        sgp.grade.sequences = list(c("7", "8", "9"))
    )
)

##  Test CMAS prior for '25 ELA P/SAT
ELA_PSAT_10_2025.config <- list(
    ELA_PSAT_10_2025 = list(
        # sgp.content.areas = c("ELA_PSAT_9", "ELA_PSAT_10"),
        # sgp.panel.years = c("2024", "2025"),
        # sgp.grade.sequences = list(c("9", "10"))
        sgp.content.areas = c("ELA", "ELA_PSAT_9", "ELA_PSAT_10"),
        sgp.panel.years = c("2023", "2024", "2025"),
        sgp.grade.sequences = list(c("8", "9", "10"))
    )
)

ELA_SAT_2025.config <- list(
    ELA_SAT_2025 = list(
        sgp.content.areas = c("ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT"),
        sgp.panel.years = c("2023", "2024", "2025"),
        sgp.grade.sequences = list(c("9", "10", "11"))
    )
)
