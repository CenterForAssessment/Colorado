################################################################################
###                                                                          ###
###              Produce 2018 Colorado ISRs for PSAT/SAT data                ###
###                                                                          ###
################################################################################

###   Before opening R set `ulimit -S -n 4096` to avoid error about too many files open in pdflatex  - also lowered par workers to 30.

###   Load required data and packages
load("Colorado/Data/Colorado_SGP.Rdata")

require(SGP)
require(data.table)


###   Get a subset of data with just the 2018 PSAT/SAT kids.
###   Necessary for now until we integrate ability to use two different cover pages.
###   Also problems with past PARCC test/metadata.  Easiest to just subset only data to be used in reports.

SATs <- c('ELA_PSAT_9', 'ELA_PSAT_10', 'ELA_SAT', 'MATHEMATICS_PSAT_9', 'MATHEMATICS_PSAT_10', 'MATHEMATICS_SAT')
ids <- unique(Colorado_SGP@Data[YEAR=='2018' & GRADE %in% c(9,10,11) & CONTENT_AREA %in% SATs, ID]) #  & !is.na(SGP)
exclude.ids1 <- unique(Colorado_SGP@Data[YEAR=='2018' & !GRADE %in% c(9,10,11) & !CONTENT_AREA %in% SATs, ID])
test.ids <- ids[!ids %in% exclude.ids1]
length(test.ids)

Colorado_SGP@Data <- Colorado_SGP@Data[ID %in% test.ids,]  #  & CONTENT_AREA %in% SATs - nope - need priors duh
table(Colorado_SGP@Data[, YEAR, CONTENT_AREA]) # only PSAT/SAT in 2018


###
###   Change PSAT/SAT ACHIEVEMENT_LEVEL var to "exact" Achievement Percentile (per Dan/Marie Request)
###

##    Establish a quantile (ecdf) function  --  NOTE this might need to include specific YEAR vars in future ...  or change the SGPstateData cutscores each year.

my.ecdf <- function(data, subject, grade) {
	as.integer(round(ecdf(data[VALID_CASE == "VALID_CASE" & CONTENT_AREA==subject & GRADE==grade, SCALE_SCORE])(data[VALID_CASE == "VALID_CASE" & CONTENT_AREA==subject & GRADE==grade, SCALE_SCORE])*100, 2))
}

Colorado_SGP@Data[CONTENT_AREA=="ELA_PSAT_10" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "ELA_PSAT_10", 10)]
Colorado_SGP@Data[CONTENT_AREA=="ELA_PSAT_9" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "ELA_PSAT_9", 9)]
Colorado_SGP@Data[CONTENT_AREA=="ELA_SAT" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "ELA_SAT", 11)]

Colorado_SGP@Data[CONTENT_AREA=="MATHEMATICS_PSAT_10" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "MATHEMATICS_PSAT_10", 10)]
Colorado_SGP@Data[CONTENT_AREA=="MATHEMATICS_PSAT_9" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "MATHEMATICS_PSAT_9", 9)]
Colorado_SGP@Data[CONTENT_AREA=="MATHEMATICS_SAT" & VALID_CASE == "VALID_CASE", SCALE_SCORE_QUANTILE := my.ecdf(Colorado_SGP@Data, "MATHEMATICS_SAT", 11)]

##    Manually change problematic percentile calculations.

Colorado_SGP@Data[SCALE_SCORE_QUANTILE==0, SCALE_SCORE_QUANTILE := 1L]
Colorado_SGP@Data[SCALE_SCORE_QUANTILE==100, SCALE_SCORE_QUANTILE := 99L]

for (ca in c("ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT", "MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")) {
	for (achlev in 1:4){
		cutscore <- SGPstateData[["CO"]][["Achievement"]][["Cutscores"]][[ca]][[1]][achlev]
		Colorado_SGP@Data[VALID_CASE == "VALID_CASE" & CONTENT_AREA == ca & SCALE_SCORE == cutscore, SCALE_SCORE_QUANTILE := ((achlev*20)+1)]
		Colorado_SGP@Data[VALID_CASE == "VALID_CASE" & CONTENT_AREA == ca & SCALE_SCORE < cutscore & SCALE_SCORE_QUANTILE >= ((achlev*20)+1), SCALE_SCORE_QUANTILE := (achlev*20)]
	}
}
#     Colorado_SGP@Data[!is.na(SCALE_SCORE_QUANTILE), as.list(summary(SCALE_SCORE_QUANTILE)), keyby=c("CONTENT_AREA", "ACHIEVEMENT_LEVEL")]

##    Change values to a descriptive character string.

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

###
###   Temporary additions/changes to SGPstateData for PSAT/SAT ISRs
###

SGPstateData[["CO"]][["Student_Report_Information"]][["Achievement_Level_Text"]][["Interpretation"]] <- c("Percentile", "Rank Bands")
SGPstateData[["CO"]][["Student_Report_Information"]][["Achievement_Level_Text"]][["Suggested_Uses"]] <- "performance levels."

SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Abbreviation"]] <- "PSAT/SAT"
# SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]][["Achievement_Levels.9"]][["Labels"]] <- c("1st to 20th %ile", "21st to 40th %ile", "41st to 60th %ile", "61st to 80th %ile", "81st to 99th %ile")
SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]][["Achievement_Level_Labels.9"]] <- list(
		 "1st to 20th %iles" =  "1 to 20",
		"21st to 40th %iles" = "21 to 40",
		"41st to 60th %iles" = "41 to 60",
		"61st to 80th %iles" = "61 to 80",
		"81st to 99th %iles" = "81 to 99")

##    Changes to CMAS 'Achievement_Level_Labels' were NOT made to CMAS ISRs - Do NOT change if CDOE wants to match CMAS:
SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]][["Achievement_Level_Labels"]] <- list(
			"Did Not Yet Meet"="Level 1",
			"Partially Meeting"="Level 2",
			"Approaching"="Level 3",
			"Meeting"="Level 4",
			"Exceeding"="Level 5")
		# "Did Not Yet Meet" = "Level 1",
	  # "Partially Met " = "Level 2",
	  # "Approached\n Expectations" = "Level 3",
	  # "Met Expectations" = "Level 4",
	  # "Exceeded\n Expectations" = "Level 5")


###   Re-configure course sequences for PSAT/SAT ISRs

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8", "9", "9", "10", "11")
SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT", "EOCT", "EOCT", "EOCT", "EOCT", "9", "10", "11")

SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- c(rep("ELA", 7), "ELA_PSAT_9", "ELA_PSAT_10", "ELA_SAT")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <- c(rep("MATHEMATICS", 6),
			"ALGEBRA_I", "GEOMETRY", "ALGEBRA_II", "INTEGRATED_MATH_1", "INTEGRATED_MATH_2", "INTEGRATED_MATH_3",
			"MATHEMATICS_PSAT_9", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")

SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- c(rep(1L, 6), 0, 1, 1) # rep(1L, 9)
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <- c(rep(1L, 6),rep(0L, 6), 1, 1)

###
###   Produce ISRs using visualizeSGP function
###

visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot"),
	sgPlot.demo.report = TRUE,  #  Only use for producing a test set of plots!
	sgPlot.front.page = "Understanding_the_2018_PSATSAT_Report_FINAL.PDF", # "Visualizations/Misc/2018_PSATSAT_ISR_Cover_Page.pdf", # Introduction to the report.  File path is relative to the working directory.
	sgPlot.header.footer.color="#6EC4E8") #,
 	# sgPlot.districts = c("0130", "0180"),
	# parallel.config=list(
	# 	BACKEND="PARALLEL",
	# 	WORKERS=list(SG_PLOTS = 30)))


###
###   Post-Hoc checks for missing schools/districs
###

dist <- system("ls /home/ec2-user/SGP/Colorado/Visualizations/studentGrowthPlots/School/2018", intern=TRUE)
dat.dist <- unique(Colorado_SGP@Data[YEAR=='2018' & !is.na(SGP)]$DISTRICT_NUMBER)
miss <- setdiff(dat.dist, dist)
m <- Colorado_SGP@Data[YEAR=='2018' & !is.na(SGP) & DISTRICT_NUMBER %in% miss]
table(m[, GRADE, CONTENT_AREA]) #  All SAT Only

problem.districts <- list()
for (d in dist) {
	data.schools <- unique(Colorado_SGP@Data[YEAR=='2018' & DISTRICT_NUMBER == d, SCHOOL_NUMBER])
	file.schools <- system(paste0("ls /home/ec2-user/SGP/Colorado/Visualizations/studentGrowthPlots/School/2018/", d), intern=TRUE)
	file.schools <- gsub("[.]zip", "", file.schools)
	if (!(all(file.schools %in% data.schools) | all(data.schools %in% file.schools))) {
		missing.schools <- setdiff(data.schools, file.schools)
		problem.districts[[d]] <- missing.schools
	}
}
