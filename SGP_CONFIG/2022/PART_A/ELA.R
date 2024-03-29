###############################################################################
###                                                                         ###
###          Baseline Configurations for Spring 2019 ELA subjects           ###
###                                                                         ###
###############################################################################

ELA.2019.config <- list(
  ELA.2019 = list(
    sgp.content.areas = rep("ELA", 3),
    sgp.panel.years = c("2017", "2018", "2019"),
    sgp.grade.sequences = list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"),
                               c("5", "6", "7"), c("6", "7", "8")))
)

ELA_PSAT_9.2019.config <- list(
  ELA_PSAT_9.2019 = list(
    sgp.content.areas = c("ELA", "ELA", "ELA_PSAT_9"),
    sgp.panel.years = c("2017", "2018", "2019"),
    sgp.grade.sequences = list(c("7", "8", "9")))
)

ELA_PSAT_10.2019.config <- list(
  ELA_PSAT_10.2019 = list(
    sgp.content.areas = c("ELA", "ELA_PSAT_9", "ELA_PSAT_10"),
    sgp.panel.years = c("2017", "2018", "2019"),
    sgp.grade.sequences = list(c("8", "9", "10")))
)

ELA_SAT.2019.config <- list(
  ###  ONLY PSAT 10 Prior for 2018
  ELA_SAT.2019 = list(
    sgp.content.areas = c("ELA_PSAT_10", "ELA_SAT"),
    sgp.panel.years = c("2018", "2019"),
    sgp.grade.sequences = list(c("10", "11")))
)
