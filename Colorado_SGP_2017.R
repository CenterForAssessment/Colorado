#########################################################
###
### Calculate SGPs for Colorado - 2017
###
##########################################################

### Load required packages

require(SGP)
require(data.table)


###  Load data

load("Data/Colorado_SGP.Rdata")
load("Data/Colorado_Data_LONG_2017.Rdata")


###  Read in 2017 SGP Configuration Scripts and Combine

source("SGP_CONFIG/2017/ELA_SS.R")
source("SGP_CONFIG/2017/MATHEMATICS_SS.R")

COLO_2017.config <- c(
	ELA_SS.2016_2017.2.config,
	MATHEMATICS_SS.2016_2017.2.config,

	ALGEBRA_I_SS.2016_2017.2.config,
	GEOMETRY_SS.2016_2017.2.config,
	ALGEBRA_II_SS.2016_2017.2.config,

	INTEGRATED_MATH_1_SS.2016_2017.2.config,
	INTEGRATED_MATH_2_SS.2016_2017.2.config
)

co.names <- Colorado_SGP@Names

###
###    updateSGP - Two step process to produce SGPs
###

Colorado_SGP <- updateSGP(
		Colorado_SGP,
		Colorado_Data_LONG_2017,
		sgp.config = COLO_2017.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"), # "summarizeSGP"
		sgp.percentiles = TRUE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		save.intermediate.results=FALSE,
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data", "WIDE_Data"),
		parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=12, PROJECTIONS=12, LAGGED_PROJECTIONS=12))) # Ubuntu/Linux

		table(as.character(Colorado_SGP@SGP$SGPercentiles$GEOMETRY_SS.2016_2017.2$SGP_NORM_GROUP))
		
###
###    Summarize Results
###

co.names -> Colorado_SGP@Names

Colorado_SGP <- summarizeSGP(
	Colorado_SGP,
	parallel.config=list(
		BACKEND="PARALLEL",
		WORKERS=list(SUMMARY=20))
)


###  Save 2017 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")


###
###    Visualize Results
###


visualizeSGP(Colorado_SGP,
	plot.types = c("bubblePlot", "growthAchievementPlot"), # "bubblePlot",
	bPlot.years=  "2016_2017.2",
	# bPlot.content_areas=c("ELA_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
	bPlot.anonymize=TRUE)


###
###  Student growth plots
###

###  Two Required External Steps for Colorado ISRs!!!

###  Step 1.  Reconfigure the MATHEMATICS_SS projection sequences (specifically the Integrated Math plots)
###						This is NOT desired for the computation of the projections, but needed here to plot out the Integrated Math courses correctly

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_SS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT", NA, NA, "EOCT", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_SS"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS", NA, NA, "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_SS"]] <- rep(1L, 13)


###  Step 2.  Remove the Integrated Math projections from the MATHEMATICS_SS slot
###						DO NOT SAVE THE SGP OBJECT AFTER THIS STEP !!!
###						We have calculated the progression of grade level math to integrated Math
###						(as well as to the "canonical" progression - to Algebra I, Geom, and Alg II),
###						but we only want to show one in the plots, so we have to remove the Integrated Math ones first.
###						DO NOT SAVE THE SGP OBJECT AFTER THIS STEP !!!

Colorado_SGP@SGP$SGProjections$MATHEMATICS_SS.2016_2017.2 <-
	Colorado_SGP@SGP$SGProjections$MATHEMATICS_SS.2016_2017.2[!SGP_PROJECTION_GROUP %in% c("MATHEMATICS_INTGRT_SS", "INTEGRATED_MATH_1_SS")]


###  Step 3.  Produce ISRs

visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot"),
	sgPlot.demo.report = TRUE,  #  Only use for producing a test set of plots!
	# sgPlot.front.page = "Visualizations/Misc/CDE_Cover.pdf", # Introduction to the report.  File path is relative to the working directory
	sgPlot.header.footer.color="#1A7A9A")
