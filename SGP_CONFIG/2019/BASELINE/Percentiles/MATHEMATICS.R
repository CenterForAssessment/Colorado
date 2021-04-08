################################################################################
###                                                                          ###
###           Skip-year SGP Configurations for 2019 Math subjects            ###
###                                                                          ###
################################################################################

MATHEMATICS_2019.config <- list(
	MATHEMATICS_2019 = list(
		sgp.content.areas=rep("MATHEMATICS", 3),
		sgp.panel.years=c("2016", "2017", "2019"),
		sgp.grade.sequences=list(c("3", "5"), c("3", "4", "6"), c("4", "5", "7"), c("5", "6", "8")),
		sgp.norm.group.preference=1L)
)

###
###		PSAT/SAT MATHEMATICS
###

MATHEMATICS_PSAT_9_2019.config <- list(
	MATHEMATICS_PSAT_9_2019 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
		sgp.panel.years=c("2016", "2017", "2019"),
		sgp.grade.sequences=list(c("6", "7", "9")))
)


MATHEMATICS_PSAT_10_2019.config <- list(
	MATHEMATICS_PSAT_10_2019 = list( ###  CANONICAL
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2016", "2017", "2019"),
		sgp.grade.sequences=list(c("7", "8", "10")))#,
		# sgp.norm.group.preference=0L)

	##   Doesn't make sense to have non-CANONICAL growth/progressions to compare to
	# MATHEMATICS_PSAT_10_2019 = list(
	# 	sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "MATHEMATICS_PSAT_10"),
	# 	sgp.panel.years=c("2016", "2017", "2019"),
	# 	sgp.grade.sequences=list(c("7", "EOCT", "10")),
	# 	sgp.norm.group.preference=1L,
	# 	sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
	#
	# MATHEMATICS_PSAT_10_2019 = list(
	# 	sgp.content.areas=c("GEOMETRY", "MATHEMATICS_PSAT_10"),
	# 	sgp.panel.years=c("2017", "2019"),
	# 	sgp.grade.sequences=list(c("EOCT", "10")),
	# 	sgp.norm.group.preference=2L,
	# 	sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
)


###  NO PSAT 9 Prior for 2017, so no point in running
# MATHEMATICS_SAT_2019.config <- list(
#
# 	###  NO PSAT 9 Prior for 2017, so no CANONICAL progression!
#
# 	###  3 Priors
# 	MATHEMATICS_SAT_2019 = list(
# 		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I", "MATHEMATICS_SAT"),
# 		sgp.panel.years=c("2016", "2017", "2019"),
# 		sgp.grade.sequences=list(c("8", "EOCT", "11")),
# 		sgp.norm.group.preference=0L,
# 		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
#
# 	MATHEMATICS_SAT_2019 = list(
# 		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY", "MATHEMATICS_SAT"),
# 		sgp.panel.years=c("2016", "2017", "2019"),
# 		sgp.grade.sequences=list(c("EOCT", "EOCT", "11")),
# 		sgp.norm.group.preference=1L,
# 		sgp.projection.grade.sequences=list("NO_PROJECTIONS")),
#
# 	MATHEMATICS_SAT_2019 = list(
# 		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_1", "MATHEMATICS_SAT"),
# 		sgp.panel.years=c("2016", "2017", "2019"),
# 		sgp.grade.sequences=list(c("8", "EOCT", "11")),
# 		sgp.norm.group.preference=2L,
# 		sgp.projection.grade.sequences=list("NO_PROJECTIONS"))
# )
