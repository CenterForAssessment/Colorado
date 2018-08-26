################################################################################
###                                                                          ###
###           Calculate SGPs for Colorado (CMAS/PSAT/SAT)  -   2018          ###
###                                                                          ###
################################################################################

###   Load required packages

require(SGP)
require(data.table)


###   Load data
load("Data/Colorado_Data_LONG.Rdata")

###   Read in 2017 P/SAT and All 2018 SGP Configuration Scripts and Combine
source("SGP_CONFIG/2017/PSAT_SAT.R")
source("SGP_CONFIG/2018/ELA.R")
source("SGP_CONFIG/2018/MATHEMATICS.R")

COLO_2018.config <- c(
	# Run 2017 P/SAT SGPs for ISRs
	ELA_PSAT_10.2017.config,
	ELA_SAT.2017.config,

	MATHEMATICS_PSAT_10.2017.config,
	MATHEMATICS_SAT.2017.config,

	ELA.2018.config,
	ELA_PSAT_9.2018.config,
	ELA_PSAT_10.2018.config,
	ELA_SAT.2018.config,

	MATHEMATICS.2018.config,
	ALGEBRA_I.2018.config,
	GEOMETRY.2018.config,
	MATHEMATICS_PSAT_9.2018.config,
	MATHEMATICS_PSAT_10.2018.config,
	MATHEMATICS_SAT.2018.config
)


###
###    abcSGP - To produce SG Percentiles and Projections
###

Colorado_SGP <- abcSGP(
		Colorado_Data_LONG,
		sgp.config = COLO_2018.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP",  "summarizeSGP", "outputSGP"),
		sgp.percentiles = TRUE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		save.intermediate.results=FALSE,
		parallel.config = list(
			BACKEND="PARALLEL", WORKERS=list(PERCENTILES=14, PROJECTIONS=12, LAGGED_PROJECTIONS=10, SUMMARY=12)))

table(Colorado_SGP@Summary$SCHOOL_NUMBER$SCHOOL_NUMBER__CONTENT_AREA__YEAR__GRADE__SCHOOL_ENROLLMENT_STATUS[, YEAR, CONTENT_AREA])

###  Save 2017 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")



###   Step 3.  Produce ISRs

load("~/Dropbox (SGP)/SGP/Colorado/Data/Colorado_SGP.Rdata")
require(SGP)
require(data.table)


###   Get a subset of data with just the 2018 PSAT/SAT kids.
###   Necessary for now until we integrate ability to use two different cover pages.

SATs <- c('ELA_PSAT_9', 'ELA_PSAT_10', 'ELA_SAT', 'MATHEMATICS_PSAT_9', 'MATHEMATICS_PSAT_10', 'MATHEMATICS_SAT')
ids <- unique(Colorado_SGP@Data[YEAR=='2018' & GRADE %in% c(9,10,11) & CONTENT_AREA %in% SATs, ID])
exclude.ids <- unique(Colorado_SGP@Data[YEAR=='2018' & !GRADE %in% c(9,10,11) & !CONTENT_AREA %in% SATs, ID])
test.ids <- ids[!ids %in% exclude.ids]
length(test.ids)
Colorado_SGP@Data <- Colorado_SGP@Data[ID %in% test.ids,]  #  & CONTENT_AREA %in% SATs - nope - need priors duh
table(Colorado_SGP@Data[, YEAR, CONTENT_AREA])
# table(Colorado_SGP@Data[YEAR=='2018' & CONTENT_AREA == "ELA", GRADE])

###   Re-configure course sequences for transition year ISRs
###   This is probably required for all such transitions, so might be something we want to include in
###   SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]]  ???

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "9", "9", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "9", "10", "11")

SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- c(rep("ELA", 7), "ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <- c(rep("MATHEMATICS", 6), "ALGEBRA_I", "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")

SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- rep(1L, 9)
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <- rep(1L, 9)


visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot"),
	sgPlot.demo.report = TRUE,  #  Only use for producing a test set of plots!
	# sgPlot.front.page = "Visualizations/Misc/2018_CMAS_ISR_Cover_Page.pdf", # RENAME FILE (Dan's has spaces in name)
	sgPlot.front.page = "Visualizations/Misc/2018_PSATSAT_ISR_Cover_Page.pdf", # Introduction to the report.  File path is relative to the working directory.
	sgPlot.header.footer.color="#6EC4E8") #,
	# sgPlot.districts = c("0130", "0180"),
	# parallel.config=list(
	# 	BACKEND="PARALLEL",
	# 	WORKERS=list(SG_PLOTS = 30)))
