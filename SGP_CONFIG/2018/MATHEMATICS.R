################################################################################
###                                                                          ###
###             SGP Configurations for Spring 2018 Math subjects             ###
###                                                                          ###
################################################################################

MATHEMATICS.2018.config <- list(
	MATHEMATICS.2018 = list(
		sgp.content.areas=rep("MATHEMATICS", 3),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8")),
		sgp.norm.group.preference=1L)
)


ALGEBRA_I.2018.config <- list(
	ALGEBRA_I.2018 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("6", "7", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=0L), ### CANONICAL progression
	ALGEBRA_I.2018 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("5", "6", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L)
)


GEOMETRY.2018.config <- list(
	GEOMETRY.2018 = list( #  --  <2000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2017", "2018"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=0L)
)


###
###		PSAT/SAT MATHEMATICS
###

MATHEMATICS_PSAT_9.2018.config <- list(
	MATHEMATICS_PSAT_9.2018 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("7", "8", "9")),
		sgp.norm.group.preference=0L),

	MATHEMATICS_PSAT_9.2018 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "MATHEMATICS_PSAT_9"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("7", "EOCT", "9")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	MATHEMATICS_PSAT_9.2018 = list(  #  --  <2000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "MATHEMATICS_PSAT_9"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "9")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	MATHEMATICS_PSAT_9.2018 = list( #  --  <2000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_1", "MATHEMATICS_PSAT_9"),
		sgp.panel.years=c("2017", "2018"),
		sgp.grade.sequences=list(c("EOCT", "9")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L)
)


MATHEMATICS_PSAT_10.2018.config <- list(
	MATHEMATICS_PSAT_10.2018 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("8", "EOCT", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=0L),

	MATHEMATICS_PSAT_10.2018 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	MATHEMATICS_PSAT_10.2018 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_1", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("8", "EOCT", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L)
)


MATHEMATICS_SAT.2018.config <- list(
	###  ONLY PSAT Prior for 2017
	###  Use sgp.exact.grade.progression to avoid multiple MATHEMATICS_PSAT_10 to MATHEMATICS_SAT duplicates
	MATHEMATICS_SAT.2018 = list(
		sgp.content.areas=c("ALGEBRA_I", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=0L),

	MATHEMATICS_SAT.2018 = list(
		sgp.content.areas=c("GEOMETRY", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	MATHEMATICS_SAT.2018 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2016", "2017", "2018"),
		sgp.grade.sequences=list(c("EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

		MATHEMATICS_SAT.2018 = list(
			sgp.content.areas=c("ALGEBRA_II.EOCT", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
			sgp.panel.years=c("2016", "2017", "2018"),
			sgp.grade.sequences=list(c("EOCT", "10", "11")),
			sgp.exact.grade.progression=TRUE,
			sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
			sgp.norm.group.preference=3L),

	MATHEMATICS_SAT.2018 = list(
		sgp.content.areas=c("MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2016", "2018"),
		sgp.grade.sequences=list(c("10", "11")),
		sgp.norm.group.preference=4L)
)
