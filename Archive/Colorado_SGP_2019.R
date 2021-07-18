################################################################################
###                                                                          ###
###           Calculate SGPs for Colorado (CMAS/PSAT/SAT)  -   2019          ###
###                                                                          ###
################################################################################

###   Load required packages
require(SGP)
require(data.table)

###   Load data
load("Data/Colorado_SGP.Rdata")
load("Data/Colorado_Data_LONG_CMAS_2019.Rdata")

###   Read in 2019 P/SAT and All 2019 SGP Configuration Scripts and Combine
source("SGP_CONFIG/2019/ELA.R")
source("SGP_CONFIG/2019/MATHEMATICS.R")

COLO_2019.config <- c(
	ELA.2019.config,
	MATHEMATICS.2019.config
)


###
###    updateSGP - To produce CMAS SG Percentiles
###

Colorado_SGP <- updateSGP(
		what_sgp_object=Colorado_SGP,
	  with_sgp_data_LONG=Colorado_Data_LONG_CMAS_2019,
		sgp.config = COLO_2019.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		sgp.percentiles = TRUE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		sgp.target.scale.scores = TRUE,
		outputSGP.output.type=c("LONG_FINAL_YEAR_Data"),
	  outputSGP.directory="Data/Archive/2019_CMAS",
		save.intermediate.results=FALSE,
		parallel.config = list(
			BACKEND="PARALLEL",
			WORKERS=list(PERCENTILES=10, PROJECTIONS=10, LAGGED_PROJECTIONS=8, SGP_SCALE_SCORE_TARGETS=8)))

###  Save 2019 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")

###
###   Produce CMAS ISRs using visualizeSGP function
###

###  set `ulimit -S -n 4096` to avoid error about too many files open in pdflatex  - also lowered par workers to 30.

visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot", "growthAchievementPlot"),
	gaPlot.years = "2019",
	gaPlot.max.order.for.progression=3,
	sgPlot.content_areas = c("ELA", "MATHEMATICS"),
	sgPlot.demo.report = TRUE,
	# sgPlot.districts = "0880", # "0100", #
	# sgPlot.schools = missing.schools, # "9389", # "2223"
	sgPlot.front.page = "Visualizations/Misc/2019_CMAS_ISR_Cover_Page.pdf", # Visualizations/Misc/  # /home/ec2-user/SGP/Colorado
	sgPlot.header.footer.color="#6EC4E8",
	parallel.config=list(
		BACKEND="PARALLEL",
		WORKERS=list(SG_PLOTS = 15)))



###
###   PSAT/SAT
###

###   Load data
load("Data/Colorado_SGP.Rdata")
load("Data/Colorado_Data_LONG_PSAT_SAT_2019.Rdata")

###   Read in 2019 P/SAT and All 2019 SGP Configuration Scripts and Combine
source("SGP_CONFIG/2019/ELA.R")
source("SGP_CONFIG/2019/MATHEMATICS.R")

COLO_SAT_2019.config <- c(
	ELA_PSAT_9.2019.config,
	ELA_PSAT_10.2019.config,
	ELA_SAT.2019.config,

	MATHEMATICS_PSAT_9.2019.config,
	MATHEMATICS_PSAT_10.2019.config,
	MATHEMATICS_SAT.2019.config
)

###
###    updateSGP - To produce P/SAT SG Percentiles
###

SGPstateData[["CO"]][["SGP_Configuration"]][["print.other.gp"]] <- TRUE
SGPstateData[["CO"]][["SGP_Configuration"]][["print.sgp.order"]] <- TRUE

Colorado_SGP <- updateSGP(
		what_sgp_object=Colorado_SGP,
	  with_sgp_data_LONG=Colorado_Data_LONG_PSAT_SAT_2019,
		sgp.config = COLO_SAT_2019.config,
		steps=c("prepareSGP", "analyzeSGP"),
		overwrite.existing.data=FALSE,
		output.updated.data=FALSE,
		sgp.percentiles = TRUE,
		sgp.projections = FALSE,
		sgp.projections.lagged = FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		# goodness.of.fit.print = TRUE,
	  # sgp.test.cohort.size = 2500,
	  # return.sgp.test.results = TRUE,
		save.intermediate.results=FALSE,
		parallel.config = list(
			BACKEND="PARALLEL", WORKERS=list(PERCENTILES=12)))


####
###   Post Process @SGP$SGPercentiles to get SGP_ORDER_1 & SGP_ORDER_2 info merged in to highest order row for Math SAT.
###   This is necessary for CONTENT_AREA configs in which `sgp.exact.grade.progression` is used for 2 & 3 prior progressions
####

# for (ca in names(Colorado_SGP@SGP$SGPercentiles)) { # Only MATH SAT
  tmp.SGPercentiles <- Colorado_SGP@SGP$SGPercentiles[["MATHEMATICS_SAT.2019"]]
  tmp.SGPercentiles$First_Prior <- as.character(NA);tmp.SGPercentiles$Second_Prior <- as.character(NA)
  tmp.SGPercentiles[, First_Prior := sapply(strsplit(as.character(tmp.SGPercentiles$SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]
	tmp.SGPercentiles[, Second_Prior := sapply(strsplit(as.character(tmp.SGPercentiles$SGP_NORM_GROUP), "; "), function(x) rev(x)[3])]

  setkey(tmp.SGPercentiles, ID, First_Prior)
  tmp.SGPercentiles <- tmp.SGPercentiles[!is.na(SGP_ORDER_1), list(ID, First_Prior, SGP_ORDER_1)][tmp.SGPercentiles][, i.SGP_ORDER_1 := NULL]
	setkey(tmp.SGPercentiles, ID, First_Prior, Second_Prior)
  tmp.SGPercentiles <- tmp.SGPercentiles[!is.na(SGP_ORDER_2), list(ID, First_Prior, Second_Prior, SGP_ORDER_2)][tmp.SGPercentiles][, i.SGP_ORDER_2 := NULL]
	# table(tmp.SGPercentiles[!is.na(SGP_ORDER_3), is.na(SGP_ORDER_2)])
	# setkey(tmp.SGPercentiles, ID) check for dups!
	# dups <- data.table(tmp.SGPercentiles[unique(c(which(duplicated(tmp.SGPercentiles, by=key(tmp.SGPercentiles)))-1, which(duplicated(tmp.SGPercentiles, by=key(tmp.SGPercentiles))))), ], key=key(tmp.SGPercentiles))

	tmp.SGPercentiles[, First_Prior := NULL]
	tmp.SGPercentiles[, Second_Prior := NULL]

	#  Normalize Column order of Math P/SAT results
	setcolorder(tmp.SGPercentiles, names(Colorado_SGP@SGP$SGPercentiles[["MATHEMATICS_PSAT_9.2019"]])[-3])
	setcolorder(Colorado_SGP@SGP$SGPercentiles[["MATHEMATICS_PSAT_10.2019"]], names(Colorado_SGP@SGP$SGPercentiles[["MATHEMATICS_PSAT_9.2019"]])[-3])

	#  Merge in complete SAT results to SGP object for combineSGP
  tmp.SGPercentiles -> Colorado_SGP@SGP$SGPercentiles[["MATHEMATICS_SAT.2019"]]
# }



Colorado_SGP <- combineSGP(Colorado_SGP, years = "2019")


outputSGP(Colorado_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"))


###
###   summarizeSGP
###

#   Fix @Names slot - Fixed in SGPstateData, but after analyses run...
SGPstateData[["CO"]][["Variable_Name_Lookup"]] <- read.csv("/media/Data/Dropbox (SGP)/Github_Repos/Packages/SGPstateData/Variable_Name_Lookup/CO_Variable_Name_Lookup.csv", colClasses=c(rep("character",4), "logical"))
Colorado_SGP <- prepareSGP(Colorado_SGP, create.additional.variables=FALSE)

Colorado_SGP <- summarizeSGP(
	Colorado_SGP,
	parallel.config=list(
		BACKEND="PARALLEL", WORKERS=list(SUMMARY=12))
)

###  Save 2019 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")

###  visualizeSGP for bubblePlot and growthAchievementPlot

visualizeSGP(Colorado_SGP,
		plot.types = c("bubblePlot", "growthAchievementPlot"),
		bPlot.years= "2019",
		bPlot.content_areas=c("ELA", "MATHEMATICS"),
		bPlot.anonymize=TRUE,
		gaPlot.years = "2019",
		gaPlot.max.order.for.progression=2,
		parallel.config=list(
			BACKEND='FOREACH', TYPE="doParallel",
			WORKERS=list(GA_PLOTS=5))
)
