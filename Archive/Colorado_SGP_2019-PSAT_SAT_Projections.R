################################################################################
###                                                                          ###
###      Calculate Projections for PSAT 10/SAT SGPs for Colorado (2019)      ###
###                                                                          ###
################################################################################

require(SGP)
require(data.table)

load("Data/Colorado_SGP.Rdata")


##########
#####        Set up course progressions
##########

ELA_PSAT_10.2019.config <- list(
	ELA_PSAT_10.2019 = list(
		sgp.content.areas=c("ELA_PSAT_9", "ELA_PSAT_10"),
		sgp.panel.years=c("2018", "2019"),
		sgp.grade.sequences=list(c("9", "10")))
)

ELA_SAT.2019.config <- list(
	ELA_SAT.2019 = list(
		sgp.content.areas=c("ELA_PSAT_10", "ELA_SAT"),
		sgp.panel.years=c("2018", "2019"),
		sgp.grade.sequences=list(c("10", "11")))
)

MATHEMATICS_PSAT_10.2019.config <- list(
	MATHEMATICS_PSAT_10.2019 = list(
		sgp.content.areas=c("MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10"),
		sgp.panel.years=c("2018", "2019"),
		sgp.grade.sequences=list(c("9", "10")))
)

MATHEMATICS_SAT.2019.config <- list(
	MATHEMATICS_SAT.2019 = list(
		sgp.content.areas=c("MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
		sgp.panel.years=c("2018", "2019"),
		sgp.grade.sequences=list(c("10", "11")))
)


COLO_SAT_2019.config <- c(
	ELA_PSAT_10.2019.config,
	ELA_SAT.2019.config,

	MATHEMATICS_PSAT_10.2019.config,
	MATHEMATICS_SAT.2019.config
)


##########
#####        Run Growth Projection Analysis
##########

Colorado_SGP <- abcSGP(
                  Colorado_SGP,
                  steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
									sgp.config=COLO_SAT_2019.config,
                  sgp.percentiles=FALSE,
                  sgp.projections=TRUE,
                  sgp.projections.lagged=TRUE,
                  sgp.percentiles.baseline=FALSE,
                  sgp.projections.baseline=FALSE,
                  sgp.projections.lagged.baseline=FALSE)

grep("SAT", names(Colorado_SGP@SGP$SGProjections), value=TRUE)
