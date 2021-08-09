#####
###   MATHEMATICS 2021 configurations (accounting for skipped year in 2020)
#####

MATHEMATICS_2021.config <- list(
     MATHEMATICS.2021 = list(
                 sgp.content.areas = c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
                 sgp.panel.years = c("2018", "2019", "2021"),
                 sgp.grade.sequences = list(c("3", "4", "6"), c("5", "6", "8")))
)

###
###		PSAT/SAT MATHEMATICS
###

MATHEMATICS_PSAT_9_2021.config <- list(
	MATHEMATICS_PSAT_9_2021 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
		sgp.panel.years=c("2018", "2019", "2021"),
		sgp.grade.sequences=list(c("6", "7", "9")))
)


MATHEMATICS_PSAT_10_2021.config <- list(
	MATHEMATICS_PSAT_10_2021 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2018", "2019", "2021"),
		sgp.grade.sequences=list(c("7", "8", "10")))
)


MATHEMATICS_SAT_2021.config <- list(
	MATHEMATICS_SAT_2021 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS_PSAT_9", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2018", "2019", "2021"),
		sgp.grade.sequences=list(c("8", "9", "11")))
)
