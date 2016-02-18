################################################################################
###                                                                          ###
###         Configuration code associated with 2015 Grade Level ELA          ###
###                                                                          ###
################################################################################

###  Use BOTH TCAP Writing and Reading as priors for PARCC ELA
##    Unlike other End-of-Grade subjects, use sgp.exact.grade.progression 
##     and sgp.norm.group.preference for ELA with double priors

ELA_2015.config <- list(
	ELA.2015 = list( # 1 Year of priors
		sgp.content.areas=c("READING", "WRITING", "ELA"),
		sgp.panel.years=c("2012", "2012", "2013", "2013", "2014", "2014", "2015"),
		sgp.grade.sequences=list(c("3", "3", "4"), c("4", "4", "5"), c("5", "5", "6"),
			c("6", "6", "7"), c("7", "7", "8"), c("8", "8", "9"), c("9", "9", "10")),
		sgp.exact.grade.progression=list(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS"),
		sgp.norm.group.preference=3),

	ELA.2015 = list( # 2 Years of priors
		sgp.content.areas=c("READING", "WRITING", "READING", "WRITING", "ELA"),
		sgp.panel.years=c("2013", "2013", "2014", "2014", "2015"),
		sgp.grade.sequences=list(c("3", "3", "4", "4", "5"), c("4", "4", "5", "5", "6"), c("5", "5", "6", "6", "7"), 
			c("6", "6", "7", "7", "8"), c("7", "7", "8", "8", "9"), c("8", "8", "9", "9", "10")),
		sgp.exact.grade.progression=list(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS"),
		sgp.norm.group.preference=2),

	ELA.2015 = list( # 3 Years of priors
		sgp.content.areas=c("READING", "WRITING", "READING", "WRITING", "READING", "WRITING", "ELA"),
		sgp.panel.years=c("2012", "2012", "2013", "2013", "2014", "2014", "2015"),
		sgp.grade.sequences=list(c("3", "3", "4", "4", "5", "5", "6"), c("4", "4", "5", "5", "6", "6", "7"), 
			c("5", "5", "6", "6", "7", "7", "8"), c("6", "6", "7", "7", "8", "8", "9"), c("7", "7", "8", "8", "9", "9", "10")),
		sgp.exact.grade.progression=list(TRUE, TRUE, TRUE, TRUE, TRUE),
		sgp.projection.grade.sequences=list("NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS"),
		sgp.norm.group.preference=1)

)