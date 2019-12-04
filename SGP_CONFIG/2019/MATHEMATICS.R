################################################################################
###                                                                          ###
###             SGP Configurations for Spring 2019 Math subjects             ###
###                                                                          ###
################################################################################

MATHEMATICS.2019.config <- list(
	MATHEMATICS.2019 = list(
		sgp.content.areas=rep("MATHEMATICS", 4),
		sgp.panel.years=c("2016", "2017", "2018", "2019"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("3", "4", "5", "6"), c("4", "5", "6", "7"), c("5", "6", "7", "8")),
		sgp.norm.group.preference=1L)
)

###
###		PSAT/SAT MATHEMATICS
###

MATHEMATICS_PSAT_9.2019.config <- list(
	MATHEMATICS_PSAT_9.2019 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
		sgp.panel.years=c("2016", "2017", "2018", "2019"),
		sgp.grade.sequences=list(c("6", "7", "8", "9")),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), #  CANONICAL Progression for 2019, but not running any projections (yet)
		sgp.norm.group.preference=0L),

	MATHEMATICS_PSAT_9.2019 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "ALGEBRA_I", "MATHEMATICS_PSAT_9"),
		sgp.panel.years=c("2016", "2017", "2018", "2019"),
		sgp.grade.sequences=list(c("6", "7", "EOCT", "9")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	MATHEMATICS_PSAT_9.2019 = list(  #  --  <2000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "MATHEMATICS_PSAT_9"),
		sgp.panel.years=c("2017", "2018", "2019"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "9")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L)
)


MATHEMATICS_PSAT_10.2019.config <- list(
	MATHEMATICS_PSAT_10.2019 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2016", "2017", "2018", "2019"),
		sgp.grade.sequences=list(c("7", "8", "9", "10")),
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), #  CANONICAL Progression for 2019, but not running any projections (yet)
		sgp.norm.group.preference=0L),

	MATHEMATICS_PSAT_10.2019 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2016", "2017", "2018", "2019"),
		sgp.grade.sequences=list(c("7", "EOCT", "9", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	MATHEMATICS_PSAT_10.2019 = list(
		sgp.content.areas=c("GEOMETRY", "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2017", "2018", "2019"),
		sgp.grade.sequences=list(c("EOCT", "9", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L)
)


MATHEMATICS_SAT.2019.config <- list(

	###  ONLY PSAT 10 Prior for 2018
	###  Use sgp.exact.grade.progression to avoid multiple MATHEMATICS_PSAT_10 to MATHEMATICS_SAT duplicates

	###  3 Priors
	MATHEMATICS_SAT.2019 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2016", "2017", "2018", "2019"),
		sgp.grade.sequences=list(c("8", "EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		# sgp.projection.grade.sequences=list("NO_PROJECTIONS"), #  CANONICAL Progression for 2019, but not running any projections (yet)
		sgp.norm.group.preference=0L),

	MATHEMATICS_SAT.2019 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2016", "2017", "2018", "2019"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	MATHEMATICS_SAT.2019 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_1", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2016", "2017", "2018", "2019"),
		sgp.grade.sequences=list(c("8", "EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	###  2 Priors
	MATHEMATICS_SAT.2019 = list(
		sgp.content.areas=c("ALGEBRA_I", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2017", "2018", "2019"),
		sgp.grade.sequences=list(c("EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	MATHEMATICS_SAT.2019 = list(
		sgp.content.areas=c("GEOMETRY", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2017", "2018", "2019"),
		sgp.grade.sequences=list(c("EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L),

	MATHEMATICS_SAT.2019 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2017", "2018", "2019"),
		sgp.grade.sequences=list(c("EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=5L),

	MATHEMATICS_SAT.2019 = list(
		sgp.content.areas=c("ALGEBRA_II", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2017", "2018", "2019"),
		sgp.grade.sequences=list(c("EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=6L),

	###  1 Prior
	MATHEMATICS_SAT.2019 = list(
		sgp.content.areas=c("MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2018", "2019"),
		sgp.grade.sequences=list(c("10", "11")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=7L)
)
