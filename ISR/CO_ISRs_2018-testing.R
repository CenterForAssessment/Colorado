
###   Produce ISRs
detach(package:SGP, unload = TRUE, force = TRUE); rm(SGPstateData);gc()
unlink("/Users/avi/Data/Colorado/SAT/2018/Visualizations/studentGrowthPlots/School/2018/Sample_District/Sample_School", recursive=T)

setwd("~/Data/Colorado/CMAS/2018")
setwd("~/Data/Colorado/SAT/2018")

load("~/Dropbox (SGP)/SGP/Colorado/Data/Colorado_SGP.Rdata")
require(SGP)
require(data.table)


###   Get a subset of data with just the 2018 PSAT/SAT kids.
###   Necessary for now until we integrate ability to use two different cover pages.

SATs <- c('ELA_PSAT_9', 'ELA_PSAT_10', 'ELA_SAT', 'MATHEMATICS_PSAT_9', 'MATHEMATICS_PSAT_10', 'MATHEMATICS_SAT')
ids <- unique(Colorado_SGP@Data[YEAR=='2018' & GRADE %in% c(9,10,11) & CONTENT_AREA %in% SATs, ID]) #  & !is.na(SGP)
exclude.ids1 <- unique(Colorado_SGP@Data[YEAR=='2018' & !GRADE %in% c(9,10,11) & !CONTENT_AREA %in% SATs, ID])
# exclude.ids2 <- unique(Colorado_SGP@Data[YEAR %in% c('2015', '2016', '2017') & CONTENT_AREA %in% c("GEOMETRY", "ALGEBRA_II", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3"), ID])
# exclude.ids2 <- unique(Colorado_SGP@Data[CONTENT_AREA == "INTEGRATED_MATH_1", ID])
# test.ids <- ids[!ids %in% unique(c(exclude.ids1, exclude.ids2))]
test.ids <- ids[!ids %in% exclude.ids1]
length(test.ids)
# ldata <- copy(Colorado_SGP@Data) # Colorado_SGP@Data <- ldata

			# Colorado_SGP@Data[GRADE=="EOCT", GRADE := "9"]
Colorado_SGP@Data <- Colorado_SGP@Data[ID %in% test.ids,]  #  & CONTENT_AREA %in% SATs - nope - need priors duh
# Colorado_SGP@Data <- Colorado_SGP@Data[YEAR %in% c('2016', '2017', '2018'),]  #  & CONTENT_AREA %in% SATs - nope - need priors duh
# Colorado_SGP@Data <- Colorado_SGP@Data[CONTENT_AREA %in% c(SATs, "ELA", "MATHEMATICS", "ALGEBRA_I"),]  #  & CONTENT_AREA %in% SATs - nope - need priors duh
table(Colorado_SGP@Data[, YEAR, CONTENT_AREA])
# table(Colorado_SGP@Data[YEAR=='2018' & CONTENT_AREA == "ELA", GRADE])
# table(Colorado_SGP@Data[CONTENT_AREA %in% SATs, CONTENT_AREA, ACHIEVEMENT_LEVEL], exclude=NULL)
# Colorado_SGP@Data[CONTENT_AREA %in% SATs & !is.na(SCALE_SCORE), as.list(summary(SCALE_SCORE)), keyby=c("CONTENT_AREA", "ACHIEVEMENT_LEVEL")]

Colorado_SGP@Data[CONTENT_AREA %in% SATs & ACHIEVEMENT_LEVEL == "Level 1", ACHIEVEMENT_LEVEL := "1 to 20"]
Colorado_SGP@Data[CONTENT_AREA %in% SATs & ACHIEVEMENT_LEVEL == "Level 2", ACHIEVEMENT_LEVEL := "21 to 40"]
Colorado_SGP@Data[CONTENT_AREA %in% SATs & ACHIEVEMENT_LEVEL == "Level 3", ACHIEVEMENT_LEVEL := "41 to 60"]
Colorado_SGP@Data[CONTENT_AREA %in% SATs & ACHIEVEMENT_LEVEL == "Level 4", ACHIEVEMENT_LEVEL := "61 to 80"]
Colorado_SGP@Data[CONTENT_AREA %in% SATs & ACHIEVEMENT_LEVEL == "Level 5", ACHIEVEMENT_LEVEL := "81 to 99"]

###  Percentile Lookup Table

my.ecdf <- function(data, subject, grade) {
	as.integer(round(ecdf(data[VALID_CASE == "VALID_CASE" & CONTENT_AREA==subject & GRADE==grade, SCALE_SCORE])(data[VALID_CASE == "VALID_CASE" & CONTENT_AREA==subject & GRADE==grade, SCALE_SCORE])*100, 2))
}

# Colorado_SGP@Data[, SCALE_SCORE_QUANTILE := NULL]

Colorado_SGP@Data[CONTENT_AREA=="ELA_PSAT_10" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "ELA_PSAT_10", 10)]
Colorado_SGP@Data[CONTENT_AREA=="ELA_PSAT_9" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "ELA_PSAT_9", 9)]
Colorado_SGP@Data[CONTENT_AREA=="ELA_SAT" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "ELA_SAT", 11)]

Colorado_SGP@Data[CONTENT_AREA=="MATHEMATICS_PSAT_10" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "MATHEMATICS_PSAT_10", 10)]
Colorado_SGP@Data[CONTENT_AREA=="MATHEMATICS_PSAT_9" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "MATHEMATICS_PSAT_9", 9)]
Colorado_SGP@Data[CONTENT_AREA=="MATHEMATICS_SAT" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "MATHEMATICS_SAT", 11)]

Colorado_SGP@Data[SCALE_SCORE_QUANTILE==0, SCALE_SCORE_QUANTILE := 1L]
Colorado_SGP@Data[SCALE_SCORE_QUANTILE==100, SCALE_SCORE_QUANTILE := 99L]

for (ca in c("ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT", "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")) {
	for (achlev in 1:4){
		cutscore <- SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][[ca]][[1]][achlev]
		Colorado_SGP@Data[VALID_CASE == "VALID_CASE" & CONTENT_AREA == ca & SCALE_SCORE == cutscore, SCALE_SCORE_QUANTILE := ((achlev*20)+1)]
		Colorado_SGP@Data[VALID_CASE == "VALID_CASE" & CONTENT_AREA == ca & SCALE_SCORE < cutscore & SCALE_SCORE_QUANTILE >= ((achlev*20)+1), SCALE_SCORE_QUANTILE := (achlev*20)]
	}
}

# Colorado_SGP@Data[!is.na(SCALE_SCORE_QUANTILE), as.list(summary(SCALE_SCORE_QUANTILE)), keyby=c("CONTENT_AREA", "ACHIEVEMENT_LEVEL")]

Colorado_SGP@Data[, SCALE_SCORE_QUANTILE := as.character(SCALE_SCORE_QUANTILE)]
Colorado_SGP@Data[, SCALE_SCORE_QUANTILE := gsub("1$", "1st %ile", SCALE_SCORE_QUANTILE)]
Colorado_SGP@Data[, SCALE_SCORE_QUANTILE := gsub("2$", "2nd %ile", SCALE_SCORE_QUANTILE)]
Colorado_SGP@Data[, SCALE_SCORE_QUANTILE := gsub("3$", "3rd %ile", SCALE_SCORE_QUANTILE)]
Colorado_SGP@Data[, SCALE_SCORE_QUANTILE := gsub("11st %ile", "11th %ile", SCALE_SCORE_QUANTILE)]
Colorado_SGP@Data[, SCALE_SCORE_QUANTILE := gsub("12nd %ile", "12th %ile", SCALE_SCORE_QUANTILE)]
Colorado_SGP@Data[, SCALE_SCORE_QUANTILE := gsub("13rd %ile", "13th %ile", SCALE_SCORE_QUANTILE)]
Colorado_SGP@Data[!grepl("%ile", SCALE_SCORE_QUANTILE), SCALE_SCORE_QUANTILE := paste0(SCALE_SCORE_QUANTILE, "th %ile")]
Colorado_SGP@Data[SCALE_SCORE_QUANTILE == "NAth %ile", SCALE_SCORE_QUANTILE := NA]

setnames(Colorado_SGP@Data, c("SCALE_SCORE_QUANTILE", "ACHIEVEMENT_LEVEL"), c("ACHIEVEMENT_LEVEL", "ACH_LEVEL_ORIGINAL"))
# setnames(Colorado_SGP@Data, c("ACHIEVEMENT_LEVEL", "ACH_LEVEL_ORIGINAL"), c("SCALE_SCORE_QUANTILE", "ACHIEVEMENT_LEVEL"))
Colorado_SGP@Data[!is.na(ACH_LEVEL_ORIGINAL) & is.na(ACHIEVEMENT_LEVEL), ACHIEVEMENT_LEVEL := ACH_LEVEL_ORIGINAL]

# table(Colorado_SGP@Data[, ACH_LEVEL_ORIGINAL, ACHIEVEMENT_LEVEL])
#
# wrong <- Colorado_SGP@Data[ACHIEVEMENT_LEVEL=="79th %ile" & ACH_LEVEL_ORIGINAL=="81 to 99",]
# wrong <- Colorado_SGP@Data[ACHIEVEMENT_LEVEL=="60th %ile" & ACH_LEVEL_ORIGINAL=="61 to 80",]
# table(wrong$CONTENT_AREA)
# table(wrong$SCALE_SCORE)

###   Re-configure course sequences for transition year ISRs
###   This is probably required for all such transitions, so might be something we want to include in
###   SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]]  ???

###

SGPstateData[["CO"]][["Student_Report_Information"]][["Achievement_Level_Text"]][["Interpretation"]] <- c("Percentile", "Rank Bands")
SGPstateData[["CO"]][["Student_Report_Information"]][["Achievement_Level_Text"]][["Suggested_Uses"]] <- "performance levels."

SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Abbreviation"]] <- "PSAT/SAT"
# SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]][["Achievement_Levels.9"]][["Labels"]] <- c("1st to 20th %ile", "21 to 40", "41 to 60", "61 to 80", "81 to 99")

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "9", "9", "10", "11")
# SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8", "9", "9", "9", "9", "9", "9", "9", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT", "EOCT", "EOCT", "EOCT", "9", "10", "11")
# SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("EOCT", "EOCT", "EOCT", "EOCT", "3", "4", "5", "6", "7", "8", "EOCT", "9", "10", "11")

SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- c(rep("ELA", 7), "ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <- c(rep("MATHEMATICS", 6),
			"ALGEBRA_I", "GEOMETRY", "ALGEBRA_II", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3",
			"MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")

SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- c(rep(1L, 6), 0, 1, 1) # rep(1L, 9)
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <- c(rep(1L, 6),rep(0L, 6), 1, 1)
# SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <- c(rep(1L, 6),rep(0L, 5), 1, 1, 1)

SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT")
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["ALGEBRA_I"]] <- "EOCT"
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["ALGEBRA_II"]] <- "EOCT"
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["GEOMETRY"]] <- "EOCT"

SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["INTEGRATED_MATH_1"]] <- "EOCT"
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["INTEGRATED_MATH_2"]] <- "EOCT"
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["INTEGRATED_MATH_3"]] <- "EOCT"

#### XXX  ####

SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["ELA"]] <- SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["ELA"]][1:7]
SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]][['Grades_Tested']] <- c(3,4,5,6,7,8, "EOCT")
SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]][['Grades_Tested.9']] <- 9:11

SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["ALGEBRA_I"]] <- "2015"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["ALGEBRA_II"]] <- "2015"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["GEOMETRY"]] <- "2015"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["INTEGRATED_MATH_1"]] <- "2015"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["INTEGRATED_MATH_2"]] <- "2015"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["INTEGRATED_MATH_3"]] <- "2015"

SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["ELA_PSAT_9"]] <- "2018"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["ELA_PSAT_10"]] <- "2016"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["ELA_SAT"]] <- "2017"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["MATHEMATICS_PSAT_9"]] <- "2018"  ###  XXX  ???  XXX   ###
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["MATHEMATICS_PSAT_10"]] <- "2016"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["MATHEMATICS_SAT"]] <- "2017"

###  XOX  ###
# SGPstateData[["CO"]][["Student_Report_Information"]][["Transformed_Achievement_Level_Cutscores"]] <- NULL
# unlink("/Users/avi/Data/Colorado/SAT/2018/Visualizations/studentGrowthPlots/School/2018/Sample_District/Sample_School", recursive=T)

visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot"),
	sgPlot.demo.report = TRUE,  #  Only use for producing a test set of plots!
	# sgPlot.front.page = "Visualizations/Misc/2018_CMAS_ISR_Cover_Page.pdf", # RENAME FILE (Dan's has spaces in name)
	# sgPlot.students = "7308961965",
	# sgPlot.content_areas = "MATHEMATICS",
	sgPlot.front.page = "Understanding_the_2018_PSATSAT_Report_FINAL.PDF", # "Visualizations/Misc/2018_PSATSAT_ISR_Cover_Page.pdf", # Introduction to the report.  File path is relative to the working directory.
	sgPlot.header.footer.color="#6EC4E8") #,
 	# sgPlot.districts = c("0130", "0180"),
	# parallel.config=list(
	# 	BACKEND="PARALLEL",
	# 	WORKERS=list(SG_PLOTS = 30)))

sgPlot.students
ID 8823037127  - single score for SAT ELA

ID 7308961965 - 2nd prior is GEOM - shows up as ALG 1
ID 7385016643 - 2nd prior is GEOM (others missing)


#####
#####
#####

ldata <- copy(Colorado_SGP@Data) # Colorado_SGP@Data <- ldata

detach(package:SGP, unload = TRUE, force = TRUE); rm(SGPstateData);gc()
setwd("~/Data/CMAS/2018")
load("~/Dropbox (SGP)/SGP/Colorado/Data/Colorado_SGP.Rdata")
require(SGP)
require(data.table)


SATs <- c('ELA_PSAT_9', 'ELA_PSAT_10', 'ELA_SAT', 'MATHEMATICS_PSAT_9', 'MATHEMATICS_PSAT_10', 'MATHEMATICS_SAT')
# SATs <- c('ELA_PSAT_9', 'ELA_PSAT_10', 'ELA_SAT', 'MATHEMATICS_PSAT_9', 'MATHEMATICS_PSAT_10', 'MATHEMATICS_SAT', "ALGEBRA_I", "GEOMETRY", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2"
ids <- unique(Colorado_SGP@Data[YEAR=='2018' & GRADE %in% c(3:8) & !CONTENT_AREA %in% SATs, ID]) #  & !is.na(SGP)
exclude.ids1 <- unique(Colorado_SGP@Data[YEAR=='2018' & GRADE %in% c(9,10,11) & CONTENT_AREA %in% SATs, ID])
test.ids <- ids[!ids %in% exclude.ids1]
length(test.ids)
Colorado_SGP@Data <- Colorado_SGP@Data[ID %in% test.ids,]  #  & CONTENT_AREA %in% SATs - nope - need priors duh
table(Colorado_SGP@Data[, YEAR, CONTENT_AREA])

#### XXX  ####

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "9")
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8", "9", NA, NA, "EOCT", "EOCT", "EOCT", "EOCT")

SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- c(rep("ELA", 6), "ELA_PSAT_9")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <- c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_9", NA, NA, "ALGEBRA_I", "GEOMETRY", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2")

SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- rep(1L, 6)
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <- rep(1L, 12)

SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]] <- NULL

#### XXX  ####

SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Abbreviation"]] <- "CMAS"

visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot"),
	sgPlot.demo.report = TRUE,
	sgPlot.front.page = "Visualizations/Misc/2018_CMAS_ISR_Cover_Page.pdf",
	sgPlot.header.footer.color="#6EC4E8")

#####
#####
#####


SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "9", "9", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT", "EOCT", "EOCT", "9", "10", "11")
# SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("EOCT", "EOCT", "EOCT", "EOCT", "3", "4", "5", "6", "7", "8", "EOCT", "9", "10", "11")

SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- c(rep("ELA", 7), "ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <- c(rep("MATHEMATICS", 6),
			"ALGEBRA_I", "GEOMETRY", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3",
			"MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")

SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- c(rep(1L, 6), 0, 1, 1) # rep(1L, 9)
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <- c(rep(1L, 6),rep(0L, 5), 1, 1)

SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["ELA"]] <- SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][["ELA"]][1:7]
SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]][['Grades_Tested']] <- c(3,4,5,6,7,8, "EOCT")
SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]][['Grades_Tested.9']] <- 9:11

SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["ALGEBRA_I"]] <- "2015"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["GEOMETRY"]] <- "2015"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["INTEGRATED_MATH_1"]] <- "2015"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["INTEGRATED_MATH_2"]] <- "2015"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["INTEGRATED_MATH_3"]] <- "2015"

SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["ELA_PSAT_9"]] <- "2018"
SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]][["MATHEMATICS_PSAT_9"]] <- "2018"
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT")
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["ALGEBRA_I"]] <- "EOCT"
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["GEOMETRY"]] <- "EOCT"

SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["INTEGRATED_MATH_1"]] <- "EOCT"
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["INTEGRATED_MATH_2"]] <- "EOCT"
SGPstateData[["CO"]][["Student_Report_Information"]][["Grades_Reported"]][["INTEGRATED_MATH_3"]] <- "EOCT"
