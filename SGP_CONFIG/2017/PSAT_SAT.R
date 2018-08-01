################################################################################
###                                                                          ###
###                   SGP Configurations for 2017 PSAT/SAT                   ###
###                                                                          ###
################################################################################

###   ELA

ELA_PSAT_10.2017.config <- list(
	ELA_PSAT_10.2017 = list(
		sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
		sgp.panel.years=c("2015", "2016", "2017"),
		sgp.grade.sequences=list(c("8", "9", "EOCT")))
)

ELA_SAT.2017.config <- list(
	ELA_SAT.2017 = list(
		sgp.content.areas=c("ELA", "ELA_PSAT_10", "ELA_SAT"),
		sgp.panel.years=c("2015", "2016", "2017"),
		sgp.grade.sequences=list(c("9", "EOCT", "EOCT")))
)


###   Mathematics

MATHEMATICS_PSAT_10.2017.config <- list(
	MATHEMATICS_PSAT_10.2017 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2015", "2016", "2017"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		sgp.norm.group.preference=0L)
)

MATHEMATICS_SAT.2017.config <- list(
	MATHEMATICS_SAT.2017 = list(
		sgp.content.areas=c("ALGEBRA_I", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2015", "2016", "2017"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.norm.group.preference=0L)
)
