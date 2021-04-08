################################################################################
###                                                                          ###
###            Skip-year SGP Configurations for 2019 ELA subjects            ###
###                                                                          ###
################################################################################

ELA_2019.config <- list(
	ELA_2019 = list(
		sgp.content.areas=rep("ELA", 3),
		sgp.panel.years=c("2016", "2017", "2019"),
		sgp.grade.sequences=list(c("3", "5"), c("3", "4", "6"), c("4", "5", "7"), c("5", "6", "8")))
)

ELA_PSAT_9_2019.config <- list(
	ELA_PSAT_9_2019 = list(
		sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_9"),
		sgp.panel.years=c("2016", "2017", "2019"),
		sgp.grade.sequences=list(c("6", "7", "9")))
)

ELA_PSAT_10_2019.config <- list(
	ELA_PSAT_10_2019 = list(
		sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
		sgp.panel.years=c("2016", "2017", "2019"),
		sgp.grade.sequences=list(c("7", "8", "10")))
)

ELA_SAT_2019.config <- list(
	ELA_SAT_2019 = list(
		sgp.content.areas=c("ELA", "ELA", "ELA_SAT"),
		sgp.panel.years=c("2016", "2017", "2019"),
		sgp.grade.sequences=list(c("8", "9", "11")))
)
