############################################################
###                                                      ###
###          Calculate SGPs for Colorado - 2017          ###
###                                                      ###
############################################################

### Load required packages

require(SGP)
require(data.table)


###  Load data

load("Data/Archive/July 2017/Colorado_SGP.Rdata")
load("Data/Colorado_Data_LONG_2017.Rdata")
Colorado_SGP@SGP$Error_Reports <- NULL  #  Remove error reports from 2016 analyses (Integrated Math projections)


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


###
###    updateSGP - To produce SG percentiles and Projections
###

my.workers <- 12  #  Number of CPU cores for parallel calculations.  12 for Ubuntu/Linux

Colorado_SGP <- updateSGP(
		Colorado_SGP,
		Colorado_Data_LONG_2017,
		sgp.config = COLO_2017.config,
		steps=c("prepareSGP", "analyzeSGP"), # , "combineSGP", "outputSGP"),
		sgp.percentiles = TRUE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		save.intermediate.results=FALSE,
		parallel.config = list(
			BACKEND="PARALLEL",
			WORKERS=list(PERCENTILES=my.workers, PROJECTIONS=my.workers, LAGGED_PROJECTIONS=my.workers)))

###  Run Projections again seperately for Algebra I to Geometry projections.

	Colorado_SGP <- analyzeSGP(
			Colorado_SGP,
			sgp.config=GEOMETRY_SS.Projections.2016_2017.2.config,
			sgp.percentiles=FALSE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			goodness.of.fit.print=FALSE)


###
###    Merge Results into Long Data  --  combineSGP
###

Colorado_SGP <- combineSGP(Colorado_SGP)

###  Test allignment of Target with SGP Norm Group:
table(Colorado_SGP@Data[YEAR=="2016_2017.2" & CONTENT_AREA=="GEOMETRY_SS", is.na(SGP_TARGET_3_YEAR), as.character(SGP_NORM_GROUP)])

#                                                                               						FALSE TRUE
# 2014_2015.2/MATHEMATICS_SS_7; 2015_2016.2/ALGEBRA_I_SS_EOCT; 2016_2017.2/GEOMETRY_SS_EOCT     0 4688
# 2015_2016.2/ALGEBRA_I_SS_EOCT; 2016_2017.2/GEOMETRY_SS_EOCT                                2390    0
# 2015_2016.2/MATHEMATICS_SS_7; 2016_2017.2/GEOMETRY_SS_EOCT                                    0  217
# 2015_2016.2/MATHEMATICS_SS_8; 2016_2017.2/GEOMETRY_SS_EOCT                                    0 1826


###
###    Summarize Results  --  summarizeSGP
###

Colorado_SGP <- summarizeSGP(
	Colorado_SGP,
	parallel.config=list(
		BACKEND="PARALLEL",
		WORKERS=list(SUMMARY = my.workers))
)

###  Save 2017 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")


###
###    Output Results  --  outputSGP
###

outputSGP(Colorado_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data", "WIDE_Data"))


###
###    Visualize Results
###


visualizeSGP(Colorado_SGP,
	plot.types = c("bubblePlot", "growthAchievementPlot"),
	bPlot.years=  "2016_2017.2",
	bPlot.anonymize=TRUE,
	bPlot.content_areas=c("ELA_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS", "INTEGRATED_MATH_1_SS"),
	gaPlot.content_areas=c("ELA_SS", "MATHEMATICS_SS", "ALGEBRA_I_SS", "GEOMETRY_SS", "INTEGRATED_MATH_1_SS"))


###
###  Student growth plots
###

###  Two Required External Steps for Colorado ISRs!!!

###  Step 1.  Reconfigure the MATHEMATICS_SS projection sequences (specifically the Integrated Math plots)
###						This is NOT desired for the computation of the projections, but needed here to plot out the Integrated Math courses correctly

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_SS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT", NA, NA, "EOCT", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_SS"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS", NA, NA, "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_SS"]] <- rep(1L, 13)

# SGPstateData[["CO"]][["Student_Report_Information"]][["sgPlot.year.span"]] <- 4 # Number of years to represent in Chart.  Default is 5.  Here 4 = 2 prior years, current year and 1 future year (growth proj fan)
# Keep sgPlot.year.span at 3 per Marie/Dan J. email

###  Step 2.  Remove the Integrated Math projections from the MATHEMATICS_SS slot
###						DO NOT SAVE THE SGP OBJECT AFTER THIS STEP !!!
###						We have calculated the progression of grade level math to integrated Math
###						(as well as to the "canonical" progression - to Algebra I, Geom, and Alg II),
###						but we only want to show one in the plots, so we have to remove the Integrated Math ones first.
###						DO NOT SAVE THE SGP OBJECT AFTER THIS STEP !!!

Colorado_SGP@SGP$SGProjections$MATHEMATICS_SS.2016_2017.2 <-
	Colorado_SGP@SGP$SGProjections$MATHEMATICS_SS.2016_2017.2[!SGP_PROJECTION_GROUP %in% c("MATHEMATICS_INTGRT_SS", "INTEGRATED_MATH_1_SS")]

# Colorado_SGP@Data[, YEAR := gsub("[.]2", "", YEAR)]
# setkeyv(Colorado_SGP@Data, SGP:::getKey(Colorado_SGP@Data))

Colorado_SGP@Data[ID==4990675174 & CONTENT_AREA=="MATHEMATICS_SS" & YEAR=="2015_2016.2", VALID_CASE := "INVALID_CASE"] # School 6678, District 1080

###  Step 3.  Produce ISRs

visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot"),
	# sgPlot.demo.report = TRUE,  #  Only use for producing a test set of plots!
	sgPlot.front.page = "Visualizations/Misc/2017_ISR_Cover_Page.pdf", #  RENAME FILE (Dan's has spaces in name)  -  Introduction to the report.  File path is relative to the working directory.
	# sgPlot.districts = c("0130", "0180"),
	sgPlot.header.footer.color="#1A7A9A",
	parallel.config=list(
		BACKEND="PARALLEL",
		WORKERS=list(SG_PLOTS = 30)))


###  Step 4. Check the Schools/Districts created

dist <- system("ls /home/ec2-user/Colorado/Visualizations/studentGrowthPlots/School/2016_2017.2", intern=TRUE)
dat.dist <- unique(Colorado_SGP@Data[YEAR=='2016_2017.2' & !is.na(SGP)]$DISTRICT_NUMBER)
miss <- setdiff(dat.dist, dist)
m <- Colorado_SGP@Data[YEAR=='2016_2017.2' & !is.na(SGP) & DISTRICT_NUMBER %in% miss]
table(m[, GRADE, CONTENT_AREA]) #  All SAT Only

problem.districts <- list()
for (d in dist) {
	data.schools <- unique(Colorado_SGP@Data[YEAR=='2016_2017.2' & DISTRICT_NUMBER == d, SCHOOL_NUMBER])
	file.schools <- system(paste0("ls /home/ec2-user/Colorado/Visualizations/studentGrowthPlots/School/2016_2017.2/", d), intern=TRUE)
	file.schools <- gsub("[.]zip", "", file.schools)
	if (!(all(file.schools %in% data.schools) | all(data.schools %in% file.schools))) {
		missing.schools <- setdiff(data.schools, file.schools)
		problem.districts[[d]] <- missing.schools
	}
}

#  No Problem Schools within Districts :-)
