################################################################################
###                                                                          ###
###   Configuration code for 2016 Grade Level Math and EOCT Math subjects    ###
###                                                                          ###
################################################################################

MATHEMATICS_2016.config <- list(
	MATHEMATICS.2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "MATHEMATICS_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("3", "4"), c("4", "5"), c("5", "6"), c("6", "7"), c("7", "8")),
		sgp.projection.sequence = c("MATHEMATICS_SS", "MATHEMATICS_INTGRT_SS")),

	ALGEBRA_I.2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c(7, "EOCT"), c(8, "EOCT"))), # 8th - 9th grades.  c(6, "EOCT") -- Singular design matrix

	ALGEBRA_I.2016 = list(
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_I_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))),

	GEOMETRY.2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c(8, "EOCT"))), # 9th grade
		
	GEOMETRY.2016 = list(
		sgp.content.areas=c("ALGEBRA_I_SS", "GEOMETRY_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))),
		
	# ALGEBRA_II.2016 = list(
	# 	sgp.content.areas=c("ALGEBRA_I_SS", "ALGEBRA_II_SS"),
	# 	sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
	# 	sgp.grade.sequences=list(c("EOCT", "EOCT"))),

	ALGEBRA_II.2016 = list(
		sgp.content.areas=c("GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))),

	INTEGRATED_MATH_1.2016 = list(
		sgp.content.areas=c("MATHEMATICS_SS", "INTEGRATED_MATH_1_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c(8, "EOCT"))), # 8th grade

	INTEGRATED_MATH_2.2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT"))),
		
	INTEGRATED_MATH_3.2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")))
)
