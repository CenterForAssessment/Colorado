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
		sgp.norm.group.preference=1L),
	ALGEBRA_I_SS.2016_2017.2 = list( #  --  <2000 :: Include for SGP_NOTE
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L)
)


GEOMETRY_SS.2016_2017.2.config <- list(
	### CANONICAL - Put first even though most are in  c("7", "EOCT", "EOCT") since testing cut off at 9th Grade ???
	GEOMETRY_SS.2016_2017.2 = list( #  --  <2000 :: Include for SGP_NOTE
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("8", "EOCT", "EOCT")),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=0L),

	GEOMETRY_SS.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("7", "EOCT", "EOCT")), # c("6", "EOCT", "EOCT"),
		# sgp.exact.grade.progression=TRUE, #  YES if running CANONICAL above to avoid multiple "ALGEBRA_I_SS", "GEOMETRY_SS" matrices
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	GEOMETRY_SS.2016_2017.2 = list( #  --  <2000 :: Include for SGP_NOTE
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("6", "7", "EOCT"), c("7", "8", "EOCT")), # 8th & 9th grades
		sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2)),
		sgp.norm.group.preference=6L)
)


GEOMETRY_SS.Projections.2016_2017.2.config <- list(
	### CANONICAL  --  Restricted to single prior.
  GEOMETRY_SS.2016_2017.2 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))))


ALGEBRA_II_SS.2016_2017.2.config <- list(
	ALGEBRA_II_SS.2016_2017.2 = list( ###  CANONICAL  --  <2000 :: Include for SGP_NOTE
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=0L)
)


INTEGRATED_MATH_1_SS.2016_2017.2.config <- list(
	INTEGRATED_MATH_1.2016_2017.2 = list( ###  CANONICAL
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("7", "8", "EOCT")),
		sgp.norm.group.preference=0L),

	INTEGRATED_MATH_1.2016_2017.2 = list( ###  --  <2000 :: Include for SGP_NOTE
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("6", "7", "EOCT")), # 8th grade
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L)
)


INTEGRATED_MATH_2_SS.2016_2017.2.config <- list(
	INTEGRATED_MATH_2.2016_2017.2 = list( ###  CANONICAL
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=0L)
)

###
###		PSAT/SAT MATHEMATICS
###

MATHEMATICS_PSAT.2016_2017.2.config <- list(
	MATHEMATICS_PSAT.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS", "MATHEMATICS_PSAT"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("8", "EOCT", "10")),
		sgp.norm.group.preference=0L),

	MATHEMATICS_PSAT.2016_2017.2 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS", "MATHEMATICS_PSAT"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=1L),

	MATHEMATICS_PSAT.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "INTEGRATED_MATH_1_SS", "MATHEMATICS_PSAT"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("8", "EOCT", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=2L),

	MATHEMATICS_PSAT.2016_2017.2 = list(
		sgp.content.areas=c("ALGEBRA_II_SS", "MATHEMATICS_PSAT"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L),

	MATHEMATICS_PSAT.2016_2017.2 = list( #  --  <2000 :: Include for SGP_NOTE
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "MATHEMATICS_PSAT"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "10")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=4L)
)

MATHEMATICS_SAT.2016_2017.2.config <- list(
	###  ONLY PSAT Prior for 2017
	###  Use sgp.exact.grade.progression to avoid multiple MATHEMATICS_PSAT to MATHEMATICS_SAT duplicates
	MATHEMATICS_SAT.2016_2017.2 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "MATHEMATICS_PSAT", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("EOCT", "10", "11")),
		sgp.exact.grade.progression=TRUE,
		sgp.norm.group.preference=0L),
	#
	# MATHEMATICS_SAT.2016_2017.2 = list(
	# 	sgp.content.areas=c("GEOMETRY_SS", "MATHEMATICS_PSAT", "MATHEMATICS_SAT"),
	# 	sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
	# 	sgp.grade.sequences=list(c("EOCT", "10", "11")),
	# 	sgp.exact.grade.progression=TRUE,
	# 	sgp.norm.group.preference=1L),
	#
	# MATHEMATICS_SAT.2016_2017.2 = list(
	# 	sgp.content.areas=c("INTEGRATED_MATH_1_SS", "MATHEMATICS_PSAT", "MATHEMATICS_SAT"),
	# 	sgp.panel.years=c("2014_2015.2", "2015_2016.2", "2016_2017.2"),
	# 	sgp.grade.sequences=list(c("EOCT", "10", "11")),
	# 	sgp.exact.grade.progression=TRUE,
	# 	sgp.norm.group.preference=2L),

	MATHEMATICS_SAT.2016_2017.2 = list(
		sgp.content.areas=c("MATHEMATICS_PSAT", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2015_2016.2", "2016_2017.2"),
		sgp.grade.sequences=list(c("10", "11")),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS"),
		sgp.norm.group.preference=3L)
)
