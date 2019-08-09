################################################################################
###                                                                          ###
###             SGP Configurations for Spring 2019 ELA subjects              ###
###                                                                          ###
################################################################################

ELA.2019.config <- list(
	ELA.2019 = list(
		sgp.content.areas=rep("ELA", 4),
		sgp.panel.years=c("2016", "2017", "2018", "2019"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("3", "4", "5", "6"), c("4", "5", "6", "7"), c("5", "6", "7", "8")))
)

#ELA_PSAT_9.2019.config <- list(
#	ELA_PSAT_9.2019 = list(
#		sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_9"),
#		sgp.panel.years=c("2017", "2018", "2019"),
#		sgp.grade.sequences=list(c("7", "8", "9")))
#)

ELA_PSAT_10.2019.config <- list(
	ELA_PSAT_10.2019 = list(
		sgp.content.areas=c("ELA_PSAT_9", "ELA_PSAT_10"),
		sgp.panel.years=c("2018", "2019"),
		sgp.grade.sequences=list(c("9", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)

ELA_SAT.2019.config <- list(
	ELA_SAT.2019 = list(
		sgp.content.areas=c("ELA_PSAT_10", "ELA_SAT"),
		sgp.panel.years=c("2018", "2019"),
		sgp.grade.sequences=list(c("10", "11")))
)
