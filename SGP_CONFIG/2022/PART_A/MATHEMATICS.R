################################################################################
###                                                                          ###
###          Baseline Configurations for Spring 2019 Math subjects           ###
###                                                                          ###
################################################################################

MATHEMATICS.2019.config <- list(
  MATHEMATICS.2019 = list(
    sgp.content.areas = rep("MATHEMATICS", 3),
    sgp.panel.years = c("2017", "2018", "2019"),
    sgp.grade.sequences = list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"),
                               c("5", "6", "7"), c("6", "7", "8")))
)

###
###    PSAT/SAT MATHEMATICS
###

MATHEMATICS_PSAT_9.2019.config <- list(
  MATHEMATICS_PSAT_9.2019 = list(
    sgp.content.areas = c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
    sgp.panel.years = c("2017", "2018", "2019"),
    sgp.grade.sequences = list(c("7", "8", "9")))
)

MATHEMATICS_PSAT_10.2019.config <- list(
  MATHEMATICS_PSAT_10.2019 = list(
    sgp.content.areas = c("MATHEMATICS", "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    sgp.panel.years = c("2017", "2018", "2019"),
    sgp.grade.sequences = list(c("8", "9", "10")))
)

MATHEMATICS_SAT.2019.config <- list(
  ###  ONLY PSAT 10 Prior for 2018
  MATHEMATICS_SAT.2019 = list(
    sgp.content.areas = c("MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    sgp.panel.years = c("2018", "2019"),
    sgp.grade.sequences = list(c("10", "11")))
)
