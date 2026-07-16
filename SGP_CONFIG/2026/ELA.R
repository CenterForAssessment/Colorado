###############################################################################
###                                                                         ###
###          Colorado configurations for Spring 2026 ELA subjects           ###
###                                                                         ###
###############################################################################

###    CMAS ELA

ELA_2026.config <- list(
    ELA.2026 = list(
        sgp.content.areas = c("ELA", "ELA", "ELA"),
        sgp.panel.years = c("2024", "2025", "2026"),
        sgp.grade.sequences = list(
            c("3", "4"), c("3", "4", "5"),
            c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))
    )
)


###    PSAT/SAT ELA

##  Continue to separate CMAS and P/SAT ELA per Marie H. 7/14/2026 email
# ELA_PSAT_9_2026.config <- list(
#     ELA_PSAT_9_2026 = list(
#         sgp.content.areas = c("ELA", "ELA", "ELA_PSAT_9"),
#         sgp.panel.years = c("2024", "2025", "2026"),
#         sgp.grade.sequences = list(c("7", "8", "9"))
#     )
# )

##  Continue to separate CMAS and P/SAT ELA
ELA_PSAT_10_2026.config <- list(
    ELA_PSAT_10_2026 = list(
        sgp.content.areas = c("ELA_PSAT_9", "ELA_PSAT_10"),
        sgp.panel.years = c("2025", "2026"),
        sgp.grade.sequences = list(c("9", "10"))
        ##  With CMAS prior:
        # sgp.content.areas = c("ELA", "ELA_PSAT_9", "ELA_PSAT_10"),
        # sgp.panel.years = c("2024", "2025", "2026"),
        # sgp.grade.sequences = list(c("8", "9", "10"))
    )
)

ELA_SAT_2026.config <- list(
    ELA_SAT_2026 = list(
        sgp.content.areas = c("ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT"),
        sgp.panel.years = c("2024", "2025", "2026"),
        sgp.grade.sequences = list(c("9", "10", "11"))
    )
)
