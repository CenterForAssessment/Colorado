################################################################################
###                                                                          ###
###             SGP Configurations for Spring 2018 Math subjects             ###
###                                                                          ###
################################################################################

ELA.2018.config <- list(
	ELA.2018 = list(
		sgp.content.areas=rep("ELA", 3),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8")))
)

ELA_PSAT_9.2018.config <- list(
	ELA_PSAT_9.2018 = list(
		sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_9"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("7", "8", "9")))
)

ELA_PSAT_10.2018.config <- list(
	ELA_PSAT_10.2018 = list(
		sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("8", "9", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

ELA_SAT.2018.config <- list(
	ELA_SAT.2018 = list(
		sgp.content.areas=c("ELA", "ELA_PSAT_10", "ELA_SAT"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("9", "10", "11")))
)
