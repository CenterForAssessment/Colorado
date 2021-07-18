setwd("~/Dropbox (SGP)/SGP/Colorado/")
setwd("/Users/avi/Data/CMAS")
load("~/Dropbox (SGP)/SGP/Colorado/Data/Colorado_SGP_LONG_Data.Rdata")
require(SGP)
require(data.table)

Colorado_SGP_LONG_Data <- Colorado_SGP_LONG_Data[CONTENT_AREA %in% c("ELA_SS", "ELA_PSAT", "ELA_SAT", "MATHEMATICS_SS", "ALGEBRA_I_SS", "MATHEMATICS_PSAT", "MATHEMATICS_SAT")]
Colorado_SGP_LONG_Data[CONTENT_AREA == "ELA_PSAT", CONTENT_AREA := "ELA_PSAT_10"]
Colorado_SGP_LONG_Data[CONTENT_AREA == "MATHEMATICS_PSAT", CONTENT_AREA := "MATHEMATICS_PSAT_10"]

Colorado_SGP_LONG_Data[CONTENT_AREA %in% c("ELA_PSAT_10", "ELA_SAT", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"), GRADE := "EOCT"]
Colorado_SGP_LONG_Data[CONTENT_AREA %in% c("ELA_PSAT_10", "MATHEMATICS_PSAT_10"), GRADE_REPORTED := "10"]
Colorado_SGP_LONG_Data[CONTENT_AREA %in% c("ELA_SAT", "MATHEMATICS_SAT"), GRADE_REPORTED := "11"]
table(Colorado_SGP_LONG_Data[, CONTENT_AREA, GRADE])

kbs <- createKnotsBoundaries(Colorado_SGP_LONG_Data[CONTENT_AREA %in% c("MATHEMATICS_PSAT_10", "MATHEMATICS_SAT", "ELA_PSAT_10", "ELA_SAT")]) # ALGEBRA_II_SS knots/bounds not available from PARCC
SGPstateData[["CO"]][["Achievement"]][["Knots_Boundaries"]] <- c(SGPstateData[["CO"]][["Achievement"]][["Knots_Boundaries"]], kbs)

SGPstateData[["CO"]][["Achievement"]][["Cutscores"]] <- c(SGPstateData[["CO"]][["Achievement"]][["Cutscores"]],
	list(
		MATHEMATICS_PSAT_10=list(
			GRADE_EOCT=c(380, 440, 510, 620)),
		MATHEMATICS_SAT=list(
			GRADE_EOCT=c(390, 480, 550, 680)),
		ELA_PSAT_10=list(
			GRADE_EOCT=c(370, 420, 500, 610)),
		ELA_SAT=list(
			GRADE_EOCT=c(400, 460, 530, 660))
	)
)

setnames(Colorado_SGP_LONG_Data, "ACHIEVEMENT_LEVEL", "ACHIEVEMENT_LEVEL_OG")
Colorado_SGP_LONG_Data <- SGP:::getAchievementLevel(Colorado_SGP_LONG_Data, state="CO")
# table(Colorado_SGP_LONG_Data[VALID_CASE=="VALID_CASE", ACHIEVEMENT_LEVEL, ACHIEVEMENT_LEVEL_OG]) # NOT ALL OLD/PARCC Levels MATCH!!!
# table(Colorado_SGP_LONG_Data[CONTENT_AREA %in% c("ELA_PSAT_10", "ELA_SAT", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"), ACHIEVEMENT_LEVEL, ACHIEVEMENT_LEVEL_OG])
# tbl <- Colorado_SGP_LONG_Data[VALID_CASE=="VALID_CASE", as.list(summary(SCALE_SCORE)), keyby=c("CONTENT_AREA", "GRADE", "ACHIEVEMENT_LEVEL")]
# tbl[CONTENT_AREA %in% c("ELA_PSAT_10", "ELA_SAT", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")]
Colorado_SGP_LONG_Data[ACHIEVEMENT_LEVEL_OG != "NA", ACHIEVEMENT_LEVEL := ACHIEVEMENT_LEVEL_OG] #  Keep old ACHIEVEMENT_LEVEL values
Colorado_SGP_LONG_Data[,ACHIEVEMENT_LEVEL_OG := NULL]

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_SS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_SS"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_SS"]] <- rep(1L, 8)

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ALGEBRA_I_SS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ALGEBRA_I_SS"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ALGEBRA_I_SS"]] <- rep(1L, 8)

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_PSAT_10"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_PSAT_10"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_PSAT_10"]] <- rep(1L, 8)
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS_SAT"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS_SAT"]] <- c(rep("MATHEMATICS_SS", 6), "ALGEBRA_I_SS", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS_SAT"]] <- rep(1L, 8)

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_SS"]] <- c("3", "4", "5", "6", "7", "8", "9", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_SS"]] <- c(rep("ELA_SS", 7), "ELA_PSAT_10", "ELA_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_SS"]] <- rep(1L, 8)

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_PSAT_10"]] <- c("3", "4", "5", "6", "7", "8", "9", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_PSAT_10"]] <- c(rep("ELA_SS", 7), "ELA_PSAT_10", "ELA_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_PSAT_10"]] <- rep(1L, 8)
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA_SAT"]] <- c("3", "4", "5", "6", "7", "8", "9", "EOCT", "EOCT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA_SAT"]] <- c(rep("ELA_SS", 7), "ELA_PSAT_10", "ELA_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA_SAT"]] <- rep(1L, 8)

###
###    abcSGP - To produce SG Percentiles & Projections
###


source("/Users/avi/Dropbox (SGP)/Github_Repos/Projects/Colorado/SGP_CONFIG/2017/ELA_PSAT-SAT_ISRs.R")
source("/Users/avi/Dropbox (SGP)/Github_Repos/Projects/Colorado/SGP_CONFIG/2017/MATHEMATICS_PSAT-SAT_ISRs.R")

# source("/media/Data/Dropbox (SGP)/Github_Repos/Projects/Colorado/SGP_CONFIG/2017/ELA_PSAT-SAT_ISRs.R")

COLO_2017.config <- c(
	ELA_SS.2016_2017.2.config,
	ELA_PSAT_10.2016_2017.2.config,
	ELA_SAT.2016_2017.2.config,

	MATHEMATICS_SS.2016_2017.2.config,
	ALGEBRA_I_SS.2016_2017.2.config,
	MATHEMATICS_PSAT_10.2016_2017.2.config,
	MATHEMATICS_SAT.2016_2017.2.config
)

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
			WORKERS=list(PERCENTILES=5, PROJECTIONS=3, LAGGED_PROJECTIONS=2))) # TAUS = 6))) #

	save(Colorado_SGP, file="Colorado_SGP.rda")

###
###    visualizeSGP - To produce ISRs
###

SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]] <- c(SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]],
	list(
		MATHEMATICS_PSAT_10 = "EOCT",
		MATHEMATICS_SAT = "EOCT",
		ELA_PSAT_10 = "EOCT",
		ELA_SAT = "EOCT"
	))

SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Labels"]][["ELA_PSAT_10"]] <- "PSAT 10 ELA"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Labels"]][["ELA_SAT"]] <- "SAT ELA"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Labels"]][["MATHEMATICS_PSAT_10"]] <- "PSAT 10 Math"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Labels"]][["MATHEMATICS_SAT"]] <- "SAT Math"

SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Domains"]][["ELA_PSAT_10"]] <- "ELA_SS"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Domains"]][["ELA_SAT"]] <- "ELA_SS"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Domains"]][["MATHEMATICS_PSAT_10"]] <- "MATHEMATICS_SS"
SGPstateData[["CO"]][["Student_Report_Information"]][["Content_Areas_Domains"]][["MATHEMATICS_SAT"]] <- "MATHEMATICS_SS"

SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported_Domains"]][["ELA_SS"]] <- c("3","4","5","6","7","8","9","EOCT") # "9","10","11",
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported_Domains"]][["MATHEMATICS_SS"]] <- c("3","4","5","6","7","8","EOCT") # "9","10","11",

SGPstateData[["CO"]][["Student_Report_Information"]][["Vertical_Scale"]][["ELA_PSAT_10"]] <- FALSE
SGPstateData[["CO"]][["Student_Report_Information"]][["Vertical_Scale"]][["ELA_SAT"]] <- FALSE
SGPstateData[["CO"]][["Student_Report_Information"]][["Vertical_Scale"]][["MATHEMATICS_PSAT_10"]] <- FALSE
SGPstateData[["CO"]][["Student_Report_Information"]][["Vertical_Scale"]][["MATHEMATICS_SAT"]] <- FALSE

SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores"]][["ELA_PSAT_10"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores"]][["ELA_SAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores"]][["MATHEMATICS_PSAT_10"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores"]][["MATHEMATICS_SAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")

SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores_gaPlot"]][["ELA_PSAT_10"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores_gaPlot"]][["ELA_SAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores_gaPlot"]][["MATHEMATICS_PSAT_10"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")
SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores_gaPlot"]][["MATHEMATICS_SAT"]] <- c("2015_2016.1", "2015_2016.2", "2016_2017.1", "2016_2017.2", "2017_2018.1", "2017_2018.2", "2018_2019.1", "2018_2019.2")

SGPstateData[["CO"]][["Assessment_Program_Information"]][["Organization"]][["URL"]] <- "www.cde.state.co.us/accountability/"

	visualizeSGP(
		Colorado_SGP,
		plot.types=c("studentGrowthPlot"),
		sgPlot.header.footer.color= "#6EC4E8", # light blue.  med blue: #488BC9 .  Pre-2018 (PARCC): "#1A7A9A",
		sgPlot.front.page = "Visualizations/2018_CMAS_ISR_Cover_Page.pdf", #  Sub _ for space in PDF name
		# sgPlot.content_areas=c("ELA_SS", "MATHEMATICS_SS"), # "ALGEBRA_I_SS", "GEOMETRY_SS", "ALGEBRA_II_SS"),
		sgPlot.demo.report = TRUE)
