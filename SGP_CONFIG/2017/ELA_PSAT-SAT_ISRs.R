#####################################################################################
###                                                                               ###
###    SGP Configurations code for Spring 2017  Grade Level ELA - SCALE SCORES    ###
###                                                                               ###
#####################################################################################

ELA_SS.2016_2017.2.config <- list(
	ELA_SS.2016_2017.2 = list(
		sgp.content.areas=rep("ELA_SS", 3),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"), c("7", "8", "9")))
)

ELA_PSAT_10.2016_2017.2.config <- list(
	ELA_PSAT_10.2016_2017.2 = list(
		sgp.content.areas=c("ELA_SS", "ELA_SS", "ELA_PSAT_10"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("8", "9", "EOCT")))
)

ELA_SAT.2016_2017.2.config <- list(
	ELA_SAT.2016_2017.2 = list(
		sgp.content.areas=c("ELA_SS", "ELA_PSAT_10", "ELA_SAT"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("9", "EOCT", "EOCT")))
)
