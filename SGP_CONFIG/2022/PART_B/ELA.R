###############################################################################
###                                                                         ###
###          Colorado configurations for Spring 2022 ELA subjects           ###
###                                                                         ###
###############################################################################

###    CMAS ELA

ELA_2022.config <- list(
  ELA.2022 = list(
    sgp.content.areas = c("ELA", "ELA"),
    sgp.panel.years = c("2021", "2022"),
    sgp.grade.sequences = list(c("3", "4"), c("4", "5"), c("5", "6"),
                               c("6", "7"), c("7", "8")))
    # sgp.grade.sequences = list(c("3", "4"), c("5", "6"), c("7", "8")))
)


###    PSAT/SAT ELA

ELA_PSAT_9_2022.config <- list( # NOT RUN - no ELA grade 8
  ELA_PSAT_9_2022 = list(
    sgp.content.areas = c("ELA", "ELA_PSAT_9"),
    sgp.panel.years = c("2021", "2022"),
    sgp.grade.sequences = list(c("8", "9")))
)

ELA_PSAT_10_2022.config <- list(
  ELA_PSAT_10_2022 = list(
    sgp.content.areas = c("ELA_PSAT_9", "ELA_PSAT_10"),
    sgp.panel.years = c("2021", "2022"),
    sgp.grade.sequences = list(c("9", "10")))
)

ELA_SAT_2022.config <- list(
  ELA_SAT_2022 = list(
    sgp.content.areas = c("ELA_PSAT_10", "ELA_SAT"),
    sgp.panel.years = c("2021", "2022"),
    sgp.grade.sequences = list(c("10", "11")))
)
