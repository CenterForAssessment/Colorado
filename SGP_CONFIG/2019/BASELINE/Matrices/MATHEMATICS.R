################################################################################
###                                                                          ###
###   Mathematics BASELINE matrix configurations (sequential and skip-year)  ###
###                                                                          ###
################################################################################

MATHEMATICS_BASELINE.config <- list(
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2018", "2019"),
		sgp.baseline.grade.sequences=c("3", "4"),
		sgp.baseline.grade.sequences.lags=1),

	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2018", "2019"),
		sgp.baseline.grade.sequences=c("4", "5"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2017", "2018", "2019"),
		sgp.baseline.grade.sequences=c("3", "4", "5"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	###  SKIP YEAR
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2017", "2019"),
		sgp.baseline.grade.sequences=c("3", "5"),
		sgp.baseline.grade.sequences.lags=2),

	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2018", "2019"),
		sgp.baseline.grade.sequences=c("5", "6"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2017", "2018", "2019"),
		sgp.baseline.grade.sequences=c("4", "5", "6"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	###  SKIP YEAR
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2017", "2019"),
		sgp.baseline.grade.sequences=c("4", "6"),
		sgp.baseline.grade.sequences.lags=2),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2016", "2017", "2019"),
		sgp.baseline.grade.sequences=c("3", "4", "6"),
		sgp.baseline.grade.sequences.lags=c(1,2)),

	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2018", "2019"),
		sgp.baseline.grade.sequences=c("6", "7"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2017", "2018", "2019"),
		sgp.baseline.grade.sequences=c("5", "6", "7"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	###  SKIP YEAR
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2017", "2019"),
		sgp.baseline.grade.sequences=c("5", "7"),
		sgp.baseline.grade.sequences.lags=2),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2016", "2017", "2019"),
		sgp.baseline.grade.sequences=c("4", "5", "7"),
		sgp.baseline.grade.sequences.lags=c(1,2)),

	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2018", "2019"),
		sgp.baseline.grade.sequences=c("7", "8"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2017", "2018", "2019"),
		sgp.baseline.grade.sequences=c("6", "7", "8"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	###  SKIP YEAR
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 2),
		sgp.baseline.panel.years=c("2017", "2019"),
		sgp.baseline.grade.sequences=c("6", "8"),
		sgp.baseline.grade.sequences.lags=2),
	list(
		sgp.baseline.content.areas=rep("MATHEMATICS", 3),
		sgp.baseline.panel.years=c("2016", "2017", "2019"),
		sgp.baseline.grade.sequences=c("5", "6", "8"),
		sgp.baseline.grade.sequences.lags=c(1,2))
)

###  P/SAT High School

MATHEMATICS_PSAT_9_BASELINE.config <- list(
	list(
		sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS_PSAT_9"),
		sgp.baseline.panel.years=c("2018", "2019"),
		sgp.baseline.grade.sequences=c("8", "9"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
		sgp.baseline.panel.years=c("2017", "2018", "2019"),
		sgp.baseline.grade.sequences=c("7", "8", "9"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	###   Skip-Year
	list(
		sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS_PSAT_9"),
		sgp.baseline.panel.years=c("2017", "2019"),
		sgp.baseline.grade.sequences=c("7", "9"),
		sgp.baseline.grade.sequences.lags=2),

	list(
		sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
		sgp.baseline.panel.years=c("2016", "2017", "2019"),
		sgp.baseline.grade.sequences=c("6", "7", "9"),
		sgp.baseline.grade.sequences.lags=c(1,2))
)

MATHEMATICS_PSAT_10_BASELINE.config <- list(
	list(
		sgp.baseline.content.areas=c("MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
		sgp.baseline.panel.years=c("2018", "2019"),
		sgp.baseline.grade.sequences=c("9", "10"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
		sgp.baseline.panel.years=c("2017", "2018", "2019"),
		sgp.baseline.grade.sequences=c("8", "9", "10"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	###   Skip-Year
	list(
		sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS_PSAT_10"),
		sgp.baseline.panel.years=c("2017", "2019"),
		sgp.baseline.grade.sequences=c("8", "10"),
		sgp.baseline.grade.sequences.lags=2),
	list(
		sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_10"),
		sgp.baseline.panel.years=c("2016", "2017", "2019"),
		sgp.baseline.grade.sequences=c("7", "8", "10"),
		sgp.baseline.grade.sequences.lags=c(1,2))
)

MATHEMATICS_SAT_BASELINE.config <- list(
	list(
		sgp.baseline.content.areas=c("MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.baseline.panel.years=c("2018", "2019"),
		sgp.baseline.grade.sequences=c("10", "11"),
		sgp.baseline.grade.sequences.lags=1)#,
	# list(
	# 	sgp.baseline.content.areas=c("MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
	# 	sgp.baseline.panel.years=c("2017", "2018", "2019"),
	# 	sgp.baseline.grade.sequences=c("9", "10", "11"),
	# 	sgp.baseline.grade.sequences.lags=c(1,1)),
	###   Skip-Year
	###   BIG PROBLEM - NO 2017 MATHEMATICS_PSAT_9! - Equate???
	# list(
	# 	sgp.baseline.content.areas=c("MATHEMATICS_PSAT_9", "MATHEMATICS_SAT"),
	# 	sgp.baseline.panel.years=c("2017", "2019"),
	# 	sgp.baseline.grade.sequences=c("9", "11"),
	# 	sgp.baseline.grade.sequences.lags=2),
	# list(
	# 	sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS_PSAT_9", "MATHEMATICS_SAT"),
	# 	sgp.baseline.panel.years=c("2016", "2017", "2019"),
	# 	sgp.baseline.grade.sequences=c("8", "9", "11"),
	# 	sgp.baseline.grade.sequences.lags=c(1,2))
)
