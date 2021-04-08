################################################################################
###                                                                          ###
###       Colorado Learning Loss Analyses -- Create Baseline Matrices        ###
###                                                                          ###
################################################################################

### Load necessary packages
require(SGP)

###   Load the results data from the 'official' 2019 SGP analyses
load("Data/Archive/2019_PreCOVID/Colorado_SGP_LONG_Data.Rdata")

###   Create a smaller subset of the LONG data to work with.
Colorado_Baseline_Data <- data.table::data.table(Colorado_SGP_LONG_Data[YEAR > 2015,
	c("ID", "CONTENT_AREA", "YEAR", "GRADE", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "VALID_CASE"),])

###   Read in Baseline SGP Configuration Scripts and Combine
source("SGP_CONFIG/2019/BASELINE/Matrices/ELA.R")
source("SGP_CONFIG/2019/BASELINE/Matrices/MATHEMATICS.R")

CO_BASELINE_CONFIG <- c(
	ELA_BASELINE.config,
	ELA_PSAT_9_BASELINE.config,
	ELA_PSAT_10_BASELINE.config,
	ELA_SAT_BASELINE.config,  #  Run sequential only -- maybe used in 2022...

	MATHEMATICS_BASELINE.config,
	MATHEMATICS_PSAT_9_BASELINE.config,
	MATHEMATICS_PSAT_10_BASELINE.config,
	MATHEMATICS_SAT_BASELINE.config  #  Run sequential only
)


###   Create Baseline Matrices

Colorado_SGP <- prepareSGP(Colorado_Baseline_Data, create.additional.variables=FALSE)

CO_Baseline_Matrices <- baselineSGP(
				Colorado_SGP,
				sgp.baseline.config=CO_BASELINE_CONFIG,
				return.matrices.only=TRUE,
				calculate.baseline.sgps=FALSE,
				goodness.of.fit.print=FALSE,
				parallel.config = list(
					BACKEND="PARALLEL", WORKERS=list(TAUS=13))
)

###   Save results
save(CO_Baseline_Matrices, file="Data/CO_Baseline_Matrices.Rdata")
