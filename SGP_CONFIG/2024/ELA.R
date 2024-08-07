###############################################################################
###                                                                         ###
###          Colorado configurations for Spring 2024 ELA subjects           ###
###                                                                         ###
###############################################################################

###    CMAS ELA

ELA_2024.config <- list(
    ELA.2024 = list(
        sgp.content.areas = c("ELA", "ELA", "ELA"),
        sgp.panel.years = c("2022", "2023", "2024"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
    )
)


###    PSAT/SAT ELA

##  NOT RUN - per Marie H email 7/16/2024
##  "we don’t want to cross back to CMAS at all for ELA"
# ELA_PSAT_9_2024.config <- list(
#     ELA_PSAT_9_2024 = list(
#         sgp.content.areas = c("ELA", "ELA", "ELA_PSAT_9"),
#         sgp.panel.years = c("2022", "2023", "2024"),
#         sgp.grade.sequences = list(c("7", "8", "9"))
#     )
# )

##  Again, no CMAS priors for '24 ELA P/SAT
ELA_PSAT_10_2024.config <- list(
    ELA_PSAT_10_2024 = list(
        sgp.content.areas = c("ELA_PSAT_9", "ELA_PSAT_10"),
        sgp.panel.years = c("2023", "2024"),
        sgp.grade.sequences = list(c("9", "10"))
        # sgp.content.areas = c("ELA", "ELA_PSAT_9", "ELA_PSAT_10"),
        # sgp.panel.years = c("2022", "2023", "2024"),
        # sgp.grade.sequences = list(c("8", "9", "10"))
    )
)

ELA_SAT_2024.config <- list(
    ELA_SAT_2024 = list(
        sgp.content.areas = c("ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT"),
        sgp.panel.years = c("2022", "2023", "2024"),
        sgp.grade.sequences = list(c("9", "10", "11"))
    )
)
