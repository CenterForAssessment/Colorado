setwd("~/Dropbox (SGP)/SGP/Colorado/")
setwd("/Users/avi/Data/CMAS")
load("~/Dropbox (SGP)/SGP/Colorado/Data/Colorado_SGP_LONG_Data.Rdata")
require(SGP)
require(data.table)

Colorado_SGP_LONG_Data <- Colorado_SGP_LONG_Data[CONTENT_AREA %in% c("ELA_SS", "ELA_PSAT", "ELA_SAT", "MATHEMATICS_SS", "ALGEBRA_I_SS", "MATHEMATICS_PSAT", "MATHEMATICS_SAT")]

source("/Users/avi/Dropbox (SGP)/Github_Repos/Projects/Colorado/SGP_CONFIG/2017/ELA_SS.R")
source("/Users/avi/Dropbox (SGP)/Github_Repos/Projects/Colorado/SGP_CONFIG/2017/MATHEMATICS_SS.R")

COLO_2017.config <- c(
	ELA_SS.2016_2017.2.config,
	MATHEMATICS_SS.2016_2017.2.config,

	ALGEBRA_I_SS.2016_2017.2.config,

	ELA_PSAT.2016_2017.2.config,
	ELA_SAT.2016_2017.2.config,
	MATHEMATICS_PSAT.2016_2017.2.config,
	MATHEMATICS_SAT.2016_2017.2.config
)

kbs <- createKnotsBoundaries(Colorado_SGP_LONG_Data[CONTENT_AREA %in% c("MATHEMATICS_PSAT", "MATHEMATICS_SAT", "ELA_PSAT", "ELA_SAT")]) # ALGEBRA_II_SS knots/bounds not available from PARCC
SGPstateData[["CO"]][["Achievement"]][["Knots_Boundaries"]] <- c(SGPstateData[["CO"]][["Achievement"]][["Knots_Boundaries"]], kbs)

SGPstateData[["CO"]][["Achievement"]][["Cutscores"]] <- c(SGPstateData[["CO"]][["Achievement"]][["Cutscores"]],
	list(
		MATHEMATICS_PSAT=list(
			GRADE_10=c(380, 440, 510, 620)),
		MATHEMATICS_SAT=list(
			GRADE_11=c(390, 480, 550, 680)),
		ELA_PSAT=list(
			GRADE_10=c(370, 420, 500, 610)),
		ELA_SAT=list(
			GRADE_11=c(400, 460, 530, 660))
	)
)


SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_SS"]] <- c("3", "4", "5", "6", "7", "8", "9", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_SS"]] <- c(rep("ELA_SS", 7), "ELA_PSAT", "ELA_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_SS"]] <- rep(1L, 8)

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_SS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_SS"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "MATHEMATICS_PSAT", "MATHEMATICS_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_SS"]] <- rep(1L, 8)

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ALGEBRA_I_SS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ALGEBRA_I_SS"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "MATHEMATICS_PSAT", "MATHEMATICS_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ALGEBRA_I_SS"]] <- rep(1L, 8)

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_PSAT"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_PSAT"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "MATHEMATICS_PSAT", "MATHEMATICS_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_PSAT"]] <- rep(1L, 8)
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_SAT"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_SAT"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "MATHEMATICS_PSAT", "MATHEMATICS_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_SAT"]] <- rep(1L, 8)

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_PSAT"]] <- c("3", "4", "5", "6", "7", "8", "9", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_PSAT"]] <- c(rep("ELA_SS", 7), "ELA_PSAT", "ELA_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_PSAT"]] <- rep(1L, 8)
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_SAT"]] <- c("3", "4", "5", "6", "7", "8", "9", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_SAT"]] <- c(rep("ELA_SS", 7), "ELA_PSAT", "ELA_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_SAT"]] <- rep(1L, 8)

###
###    abcSGP - To produce SG Percentiles & Projections
###

Colorado_SGP <- abcSGP(
		Colorado_SGP_LONG_Data,
		sgp.config = COLO_2017.config,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
		simulate.sgps = FALSE,
		save.intermediate.results=FALSE,
		parallel.config = list(
			BACKEND="PARALLEL",
			WORKERS=list(PERCENTILES=6, PROJECTIONS=1, LAGGED_PROJECTIONS=1)))

SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]] <- c(SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]],
	list(
		MATHEMATICS_PSAT= 10,
		MATHEMATICS_SAT = 11,
		ELA_PSAT= 10,
		ELA_SAT = 11
	))

SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Labels"]][["ELA_PSAT"]] <- "PSAT ELA"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Labels"]][["ELA_SAT"]] <- "SAT ELA"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Labels"]][["MATHEMATICS_PSAT"]] <- "PSAT Math"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Labels"]][["MATHEMATICS_SAT"]] <- "SAT Math"

SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Domains"]][["ELA_PSAT"]] <- "ELA_SS"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Domains"]][["ELA_SAT"]] <- "ELA_SS"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Domains"]][["MATHEMATICS_PSAT"]] <- "MATHEMATICS_SS"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Domains"]][["MATHEMATICS_SAT"]] <- "MATHEMATICS_SS"

SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported_Domains"]][["MATHEMATICS_SS"]] <- c("3","4","5","6","7","8","9","10","11","EOCT")

SGPstateData[["CO"]][["Student_Report_Information"]][["Vertical_Scale"]][["ELA_PSAT"]] <- FALSE
SGPstateData[["CO"]][["Student_Report_Information"]][["Vertical_Scale"]][["ELA_SAT"]] <- FALSE
SGPstateData[["CO"]][["Student_Report_Information"]][["Vertical_Scale"]][["MATHEMATICS_PSAT"]] <- FALSE
SGPstateData[["CO"]][["Student_Report_Information"]][["Vertical_Scale"]][["MATHEMATICS_SAT"]] <- FALSE

SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores"]][["ELA_PSAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores"]][["ELA_SAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores"]][["MATHEMATICS_PSAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores"]][["MATHEMATICS_SAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")

SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores_gaPlot"]][["ELA_PSAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores_gaPlot"]][["ELA_SAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores_gaPlot"]][["MATHEMATICS_PSAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores_gaPlot"]][["MATHEMATICS_SAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")


# SGPstateData[["CO"]][["SGP_Configuration"]][["sgp.projections.use.only.complete.matrices"]]
# SGPstateData[["CO"]][["SGP_Configuration"]]$sgPlot.fan

	visualizeSGP(
		Colorado_SGP,
		plot.types=c("studentGrowthPlot"),
		sgPlot.header.footer.color="#1A7A9A",
		sgPlot.content_areas=c("ELA_SS", "MATHEMATICS_SS"), # "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgPlot.demo.report = TRUE)




SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_SS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT", NA, NA, "EOCT", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_SS"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS", NA, NA, "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_SS"]] <- rep(1L, 13)


SGPstateData[["CO"]][["Student_Report_Information"]][["sgPlot.year.span"]] <- 3

SGPstateData[["CO"]][["Student_Report_Information"]][['Vertical_Scale']] <- list(MATHEMATICS_SS=FALSE, ELA_SS=FALSE, GEOMETRY_SS=FALSE, ALGEBRA_I_SS=FALSE, ALGEBRA_II_SS=FALSE, INTEGRATED_MATH_1_SS=FALSE, INTEGRATED_MATH_2_SS=FALSE, INTEGRATED_MATH_3_SS=FALSE)

SGPstateData[["CO"]][["Student_Report_Information"]][["Achievement_Level_Labels"]] <- list(
"Did Not Yet Meet\nExpectations"="Level 1",
"Partially Meeting\nExpectations"="Level 2",
"Approaching\nExpectations"="Level 3",
"Meeting\nExpectations"="Level 4",
"Exceeding\nExpectations"="Level 5")


SGPstateData[["CO"]][["Student_Report_Information"]][["Achievement_Level_Labels"]] <- list(
"Did Not Yet Meet"="Level 1",
"Partially Meeting"="Level 2",
"Approaching"="Level 3",
"Meeting"="Level 4",
"Exceeding"="Level 5")

SGPstateData[["CO"]][["Student_Report_Information"]][["Proficiency_Label"]] <- "benchmark"
SGPstateData[["CO"]][["SGP_Configuration"]][["sgPlot.use.student.id"]] <- TRUE


###
###  Student growth plots
###

###  Need to get rid of the '.2' usage in year  --  causes problems with pdflatex creation of school catalogs/files

# Colorado_SGP@Data[, YEAR := gsub("[.]2", "", YEAR)]
# names(Colorado_SGP@SGP$SGProjections) <- gsub("2015_2016.2", "2015_2016", names(Colorado_SGP@SGP$SGProjections))

###  Null out MATHEMATICS_INTGRT_SS projections manually - want it to calculate the projections (in case ever needed), but shouldn't (can't) be part of the student reports
##
#
#
# SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_INTGRT_SS"]] <-
# SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_INTGRT_SS"]] <-
# SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_INTGRT_SS"]] <- NULL
#
# names(SGPstateData[["CO"]][["Achievement"]][["Cutscores"]]) <-  gsub("2015_2016.2", "2015_2016", names(SGP::SGPstateData[["CO"]][["Achievement"]][["Cutscores"]]))
#
# Colorado_SGP@SGP$SGProjections$MATHEMATICS_SS.2015_2016 <-
# 	Colorado_SGP@SGP$SGProjections$MATHEMATICS_SS.2015_2016[!SGP_PROJECTION_GROUP %in% c("MATHEMATICS_INTGRT_SS", "INTEGRATED_MATH_1_SS")]
#
##
###

###  Create student report DEMO catalog

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_SS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT", NA, NA, "EOCT", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_SS"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS", NA, NA, "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_SS"]] <- rep(1L, 13)

# SGPstateData[["CO"]][["SGP_Configuration"]][["sgPlot.show.content_area.progression"]] <- FALSE

Colorado_SGP@SGP$SGProjections$MATHEMATICS_SS.2015_2016.2 <-
	Colorado_SGP@SGP$SGProjections$MATHEMATICS_SS.2015_2016.2[!SGP_PROJECTION_GROUP %in% c("MATHEMATICS_INTGRT_SS", "INTEGRATED_MATH_1_SS")]

# Colorado_SGP@Data[, LAST_NAME := paste(LAST_NAME, "-", ID)]

visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot"),
	sgPlot.header.footer.color="#1A7A9A",
	# sgPlot.content_areas=c("ELA_SS", "MATHEMATICS_SS"), # "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
	sgPlot.demo.report = TRUE)




SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]] <-
		  c(SGPstateData[["PARCC"]][["SGP_Configuration"]][["grade.projection.sequence"]], list(
			ELA_SS=c("3", "4", "5", "6", "7", "8", "9"),
      MATHEMATICS_SS=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT", NA, NA, "EOCT", "EOCT", "EOCT"),
#			MATHEMATICS_SS=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT"),
#			MATHEMATICS_INTGRT_SS=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT"),
			GEOMETRY_SS=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT"),
			ALGEBRA_I_SS=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT"),
			ALGEBRA_II_SS=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT"),
			INTEGRATED_MATH_1_SS=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT"),
			INTEGRATED_MATH_2_SS=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT"),
			INTEGRATED_MATH_3_SS=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT")))

SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <-
		  c(SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]], list(
			ELA_SS=rep("ELA_SS", 7),
      MATHEMATICS_SS=c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS", NA, NA, "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS"),
#			MATHEMATICS_SS=c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
#			MATHEMATICS_INTGRT_SS=c(rep("MATHEMATICS_SS", 6), "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS"),
			GEOMETRY_SS=c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
			ALGEBRA_I_SS=c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
			ALGEBRA_II_SS=c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
      INTEGRATED_MATH_1_SS= c("INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS"),
			INTEGRATED_MATH_2_SS= c("INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS"),
			INTEGRATED_MATH_3_SS= c("INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS")))
#			INTEGRATED_MATH_1_SS= c(rep("MATHEMATICS_SS", 6), "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS"),
#			INTEGRATED_MATH_2_SS= c(rep("MATHEMATICS_SS", 6), "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS"),
#			INTEGRATED_MATH_3_SS= c(rep("MATHEMATICS_SS", 6), "INTEGRATED_MATH_1_SS", "INTEGRATED_MATH_2_SS", "INTEGRATED_MATH_3_SS"))) #

SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <-
		  c(SGPstateData[["PARCC"]][["SGP_Configuration"]][["year_lags.projection.sequence"]], list(
			ELA_SS=rep(1L, 6),
			MATHEMATICS_SS=rep(1L, 13), # 8
#			MATHEMATICS_INTGRT_SS=rep(1L, 8),
			GEOMETRY_SS=rep(1L, 8),
			ALGEBRA_I_SS=rep(1L, 8),
			ALGEBRA_II_SS=rep(1L, 8),
      INTEGRATED_MATH_1_SS=rep(1L, 2),
			INTEGRATED_MATH_2_SS=rep(1L, 2),
			INTEGRATED_MATH_3_SS=rep(1L, 2)))
#			INTEGRATED_MATH_1_SS=rep(1L, 8),
#			INTEGRATED_MATH_2_SS=rep(1L, 8),
#			INTEGRATED_MATH_3_SS=rep(1L, 8)))

SGPstateData[["CO"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <-
		  c(SGPstateData[["PARCC"]][["SGP_Configuration"]][["max.forward.projection.sequence"]], list(
		  	ELA_SS=3,
			MATHEMATICS_SS=3,
			MATHEMATICS_INTGRT_SS=3,
			GEOMETRY_SS=3,
			ALGEBRA_I_SS=3,
			ALGEBRA_II_SS=3,
			INTEGRATED_MATH_1_SS=3,
			INTEGRATED_MATH_2_SS=3,
			INTEGRATED_MATH_3_SS=3))

SGPstateData[["CO"]][['SGP_Progression_Preference']] <- data.table(
	SGP_PROJECTION_GROUP = c(
		"MATHEMATICS_SS", "MATHEMATICS_INTGRT_SS", "ALGEBRA_I_SS", "INTEGRATED_MATH_1_SS", "GEOMETRY_SS", "INTEGRATED_MATH_2_SS", "ALGEBRA_II_SS", "INTEGRATED_MATH_3_SS",
		"MATHEMATICS", "MATHEMATICS_INTGRT", "ALGEBRA_I", "INTEGRATED_MATH_1", "GEOMETRY", "INTEGRATED_MATH_2", "ALGEBRA_II", "INTEGRATED_MATH_3"),
	PREFERENCE = c(1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2), key = "SGP_PROJECTION_GROUP")

SGPstateData[["CO"]][["Student_Report_Information"]][['Vertical_Scale']] <- list(MATHEMATICS_SS=FALSE, ELA_SS=FALSE, GEOMETRY_SS=FALSE, ALGEBRA_I_SS=FALSE, ALGEBRA_II_SS=FALSE, INTEGRATED_MATH_1_SS=FALSE, INTEGRATED_MATH_2_SS=FALSE, INTEGRATED_MATH_3_SS=FALSE)

SGPstateData[["CO"]][["Student_Report_Information"]] <-
	list(
		sgPlot.year.span = 3, # Number of years to represent in Chart.  Default is 5.  Here 3 = 2 test years and 1 future year (growth proj fan)
		Vertical_Scale="No",
    Transformed_Achievement_Level_Cutscores =
			c(SGPstateData[["PARCC"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores"]],
			  list(
        ELA_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				MATHEMATICS_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				GEOMETRY_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				ALGEBRA_I_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				ALGEBRA_II_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				INTEGRATED_MATH_1_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				INTEGRATED_MATH_2_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				INTEGRATED_MATH_3_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"))),
		Transformed_Achievement_Level_Cutscores_gaPlot =
			c(SGPstateData[["PARCC"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores_gaPlot"]],
			  list(
        ELA_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				MATHEMATICS_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				GEOMETRY_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				ALGEBRA_I_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				ALGEBRA_II_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				INTEGRATED_MATH_1_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				INTEGRATED_MATH_2_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"),
				INTEGRATED_MATH_3_SS=c("2014_2015.1", "2014_2015.2", "2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2"))),
    Vertical_Scale=list(MATHEMATICS_SS=FALSE, ELA_SS=FALSE, GEOMETRY_SS=FALSE, ALGEBRA_I_SS=FALSE, ALGEBRA_II_SS=FALSE, INTEGRATED_MATH_1_SS=FALSE, INTEGRATED_MATH_2_SS=FALSE, INTEGRATED_MATH_3_SS=FALSE),
		Content_Areas_Labels=list(
				ELA="ELA", MATHEMATICS="Math", GEOMETRY="Geometry", ALGEBRA_I="Algebra I", ALGEBRA_II="Algebra II",
				INTEGRATED_MATH_1="Integrated Math 1", INTEGRATED_MATH_2="Integrated Math 2", INTEGRATED_MATH_3="Integrated Math 3",
				ELA_SS="ELA", MATHEMATICS_SS="Math", GEOMETRY_SS="Geometry", ALGEBRA_I_SS="Algebra I", ALGEBRA_II_SS="Algebra II",
				INTEGRATED_MATH_1_SS="Integrtd Math 1", INTEGRATED_MATH_2_SS="Integrtd Math 2", INTEGRATED_MATH_3_SS="Integrtd Math 3"),
		Content_Areas_Domains=list(
				ELA="ELA", MATHEMATICS="MATHEMATICS", GEOMETRY="MATHEMATICS", ALGEBRA_I="MATHEMATICS", ALGEBRA_II="MATHEMATICS",
				INTEGRATED_MATH_1="MATHEMATICS", INTEGRATED_MATH_2="MATHEMATICS", INTEGRATED_MATH_3="MATHEMATICS",
				ELA_SS="ELA_SS", MATHEMATICS_SS="MATHEMATICS_SS", GEOMETRY_SS="MATHEMATICS_SS", ALGEBRA_I_SS="MATHEMATICS_SS", ALGEBRA_II_SS="MATHEMATICS_SS",
				INTEGRATED_MATH_1_SS="MATHEMATICS_SS", INTEGRATED_MATH_2_SS="MATHEMATICS_SS", INTEGRATED_MATH_3_SS="MATHEMATICS_SS"),
		Grades_Reported=list(
				ELA=c("3","4","5","6","7","8","9","10","11"), MATHEMATICS=c("3","4","5","6","7","8"), GEOMETRY="EOCT", ALGEBRA_I="EOCT", ALGEBRA_II="EOCT",
				INTEGRATED_MATH_1="EOCT", INTEGRATED_MATH_2="EOCT", INTEGRATED_MATH_3="EOCT",
				ELA_SS=c("3","4","5","6","7","8","9"), MATHEMATICS_SS=c("3","4","5","6","7","8"), GEOMETRY_SS="EOCT", ALGEBRA_I_SS="EOCT", ALGEBRA_II_SS="EOCT",
				INTEGRATED_MATH_1_SS="EOCT", INTEGRATED_MATH_2_SS="EOCT", INTEGRATED_MATH_3_SS="EOCT"),
		Grades_Reported_Domains=list(
				ELA=c("3","4","5","6","7","8","9"), ELA_SS=c("3","4","5","6","7","8","9"),
				MATHEMATICS=c("3","4","5","6","7","8","EOCT"), MATHEMATICS_SS=c("3","4","5","6","7","8","EOCT")),
		Achievement_Level_Labels=list(
				"Level 1"="Level 1",
				"Level 2"="Level 2",
				"Level 3"="Level 3",
				"Level 4"="Level 4",
				"Level 5"="Level 5"))
