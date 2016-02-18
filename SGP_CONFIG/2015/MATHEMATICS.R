################################################################################
###                                                                          ###
###   Configuration code for 2015 Grade Level Math and EOCT Math subjects    ###
###                                                                          ###
################################################################################

MATHEMATICS_2015.config <- list(
	MATHEMATICS.2015 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
		sgp.panel.years=as.character(2012:2015),
		sgp.grade.sequences=list(as.character(3:4), as.character(3:5), as.character(3:6), as.character(4:7), as.character(5:8))),

	ALGEBRA_I.2015 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=as.character(2012:2015),
		sgp.grade.sequences=list(c(5:7, "EOCT"), c(6:8, "EOCT"), c(7:9, "EOCT"))), # 8th - 10th grades

	GEOMETRY.2015 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "GEOMETRY"),
		sgp.panel.years=as.character(2012:2015),
		sgp.grade.sequences=list(c(6:8, "EOCT"), c(7:9, "EOCT"), c(8:10, "EOCT"))), # 9th - 11th grades
		
	ALGEBRA_II.2015 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "ALGEBRA_II"),
		sgp.panel.years=as.character(2012:2015),
		sgp.grade.sequences=list(c(7:9, "EOCT"), c(8:10, "EOCT"))), # 10th - 11th grades

	INTEGRATED_MATH_1.2015 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "INTEGRATED_MATH_1"),
		sgp.panel.years=as.character(2012:2015),
		sgp.grade.sequences=list(c(5:7, "EOCT"), c(6:8, "EOCT"), c(7:9, "EOCT"))), # 8th - 10th grades

	INTEGRATED_MATH_2.2015 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "INTEGRATED_MATH_2"),
		sgp.panel.years=as.character(2012:2015),
		sgp.grade.sequences=list(c(6:8, "EOCT"), c(7:9, "EOCT"), c(8:10, "EOCT"))), # 9th - 11th grades
		
	INTEGRATED_MATH_3.2015 = list(
		sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "INTEGRATED_MATH_3"),
		sgp.panel.years=as.character(2012:2015),
		sgp.grade.sequences=list(c(7:9, "EOCT"), c(8:10, "EOCT"))) # 10th - 11th grades
)