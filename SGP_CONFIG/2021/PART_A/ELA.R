#####
###   ELA 2021 configurations (accounting for skipped year in 2020)
#####

ELA_2021.config <- list(
     ELA.2021 = list(
                 sgp.content.areas = c("ELA", "ELA", "ELA"),
                 sgp.panel.years = c("2018", "2019", "2021"),
                 sgp.grade.sequences = list(c("3", "5"), c("4", "5", "7")))
)

###
###		PSAT/SAT ELA
###

ELA_PSAT_9_2021.config <- list(
	ELA_PSAT_9_2021 = list(
		sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_9"),
		sgp.panel.years=c("2018", "2019", "2021"),
		sgp.grade.sequences=list(c("6", "7", "9")))
)

ELA_PSAT_10_2021.config <- list(
	ELA_PSAT_10_2021 = list(
		sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
		sgp.panel.years=c("2018", "2019", "2021"),
		sgp.grade.sequences=list(c("7", "8", "10")))
)

ELA_SAT_2021.config <- list(
	ELA_SAT_2021 = list(
		sgp.content.areas=c("ELA", "ELA_PSAT_9", "ELA_SAT"),
		sgp.panel.years=c("2018", "2019", "2021"),
		sgp.grade.sequences=list(c("8", "9", "11")))
)
