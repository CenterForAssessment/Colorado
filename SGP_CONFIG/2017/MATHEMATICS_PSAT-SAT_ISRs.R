################################################################################################
###                                                                                          ###
###   SGP Configurations for Spring 2017 Grade Level and EOCT Math subjects - SCALE SCORES   ###
###                                                                                          ###
################################################################################################

MATHEMATICS_SS.2016_2017.2.config <- list(
	MATHEMATICS_SS.2016_2017.2 = list(
		sgp.content.areas=rep("MATHEMATICS_SS", 3),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8")),
		sgp.norm.group.preference=1L)
)


ALGEBRA_I_SS.2016_2017.2.config <- list(
	ALGEBRA_I_SS.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")),
		sgp.norm.group.preference=0L), ### CANONICAL progression
	ALGEBRA_I_SS.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("6", "7", "EOCT")), # 7th & 8th grades  {7th Grade has "Singular design matrix" error with 5th Grade}
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=1L)
)

###
###		PSAT/SAT MATHEMATICS
###

MATHEMATICS_PSAT_10.2016_2017.2.config <- list(
	MATHEMATICS_PSAT_10.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		sgp.norm.group.preference=0L)
)

MATHEMATICS_SAT.2016_2017.2.config <- list(
	MATHEMATICS_SAT.2016_2017.2 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.norm.group.preference=0L)
)
