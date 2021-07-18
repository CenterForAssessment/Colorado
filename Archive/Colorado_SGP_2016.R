#########################################################
###
### Calculate SGPs for Colorado - 2016
###
##########################################################

### Load required packages

require(SGP)
require(data.table)

###  Modify the SGPstateData - Different/Additional SGP_Configuration from PARCC defaults

SGPstateData[["CO"]][["SGP_Configuration"]][["sgp.cohort.size"]] <- 2000
SGPstateData[["CO"]][["SGP_Configuration"]][["return.norm.group.scale.scores"]] <- TRUE
# SGPstateData[["CO"]][["SGP_Configuration"]][["rq.method"]] <- 'br' # Leave as 'fn' per Marie 9/9/16


###  Load Colorado PARCC 2015 and 2016 data

load("Data/Colorado_Data_LONG_2016.Rdata")

###  Rename SCALE_SCORE
setnames(Colorado_Data_LONG_2016, c("SCALE_SCORE", "SCALE_SCORE_ADJUSTED"), c("SCALE_SCORE_ORIGINAL", "SCALE_SCORE"))


###  Read in 2016 SGP Configuration Scripts and Combine

source("SGP_CONFIG/2016/ELA.R")
source("SGP_CONFIG/2016/MATHEMATICS.R")

COLO_2016.config <- c(
		MATHEMATICS_2016.config,
		ELA_2016.config)

###
###    abcSGP - Two step process to produce SGPs for Adjusted and Unadjusted Scale Scores
###

Colorado_SGP <- abcSGP(
		sgp_object=Colorado_Data_LONG_2016,
		sgp.config = COLO_2016.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"), # "summarizeSGP", "outputSGP"
		sgp.percentiles = TRUE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		save.intermediate.results=FALSE,
		outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data", "WIDE_Data"),
		parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=8, PROJECTIONS=8, LAGGED_PROJECTIONS=8))) # Ubuntu/Linux


###  Save 2016 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")


###
###    Summarize Results
###

Colorado_SGP <- summarizeSGP(
	Colorado_SGP,
	parallel.config=list(
		BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE,
		WORKERS=list(SUMMARY=6))
)



###
###    Visualize Results
###


visualizeSGP(Colorado_SGP,
	plot.types = c("bubblePlot", "growthAchievementPlot"), # "bubblePlot",
	bPlot.years=  "2015_2016.2",
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

Colorado_SGP@SGP$SGProjections$MATHEMATICS_SS.2015_2016.2 <-
	Colorado_SGP@SGP$SGProjections$MATHEMATICS_SS.2015_2016.2[!SGP_PROJECTION_GROUP %in% c("MATHEMATICS_INTGRT_SS", "INTEGRATED_MATH_1_SS")]


###  Step 3.  Produce ISRs

visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot"),
	sgPlot.demo.report = TRUE,  #  Only use for producing a test set of plots!
	# sgPlot.front.page = "Visualizations/Misc/CDE_Cover.pdf", # Introduction to the report.  File path is relative to the working directory
	sgPlot.header.footer.color="#1A7A9A")
