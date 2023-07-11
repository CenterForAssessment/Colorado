###############################################################################
###                                                                         ###
###          Colorado configurations for Spring 2022 Math subjects          ###
###                                                                         ###
###############################################################################

###    CMAS MATHEMATICS

MATHEMATICS_2022.config <- list(
  MATHEMATICS.2022 = list(
    sgp.content.areas = c("MATHEMATICS", "MATHEMATICS"),
    sgp.panel.years = c("2021", "2022"),
    sgp.grade.sequences = list(c("3", "4"), c("4", "5"), c("5", "6"),
                               c("6", "7"), c("7", "8")))
#    sgp.grade.sequences = list(c("4", "5"), c("6", "7")))
)


###    PSAT/SAT MATHEMATICS

MATHEMATICS_PSAT_9_2022.config <- list(
  MATHEMATICS_PSAT_9_2022 = list(
    sgp.content.areas = c("MATHEMATICS", "MATHEMATICS_PSAT_9"),
    sgp.panel.years = c("2021", "2022"),
    sgp.grade.sequences = list(c("8", "9")))
)

MATHEMATICS_PSAT_10_2022.config <- list(
  MATHEMATICS_PSAT_10_2022 = list(
    sgp.content.areas = c("MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
    sgp.panel.years = c("2021", "2022"),
    sgp.grade.sequences = list(c("9", "10")))
)

MATHEMATICS_SAT_2022.config <- list(
  MATHEMATICS_SAT_2022 = list(
    sgp.content.areas = c("MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    sgp.panel.years = c("2021", "2022"),
    sgp.grade.sequences = list(c("10", "11")))
)
