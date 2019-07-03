################################################################################
###                                                                          ###
###                Produce 2018 Colorado ISRs for CMAS data                  ###
###                                                                          ###
################################################################################

###  Before opening R set `ulimit -S -n 4096` to avoid error about too many files open in pdflatex  - also lowered par workers to 30.

###   Load required data and packages
load("Colorado/Data/Colorado_SGP.Rdata")

require(SGP)
require(data.table)


###   Get a subset of data with just the 2018 CMAS kids.
###   Necessary for now until we integrate ability to use two different cover pages.
###   Also problems with past PARCC test/metadata.  Easiest to just subset only data to be used in reports.

ids <- unique(Colorado_SGP@Data[YEAR=='2018' & GRADE %in% c(3:8) & CONTENT_AREA %in% c("ELA", "MATHEMATICS"), ID]) #  & !is.na(SGP)
Colorado_SGP@Data <- Colorado_SGP@Data[ID %in% ids,]
Colorado_SGP@Data <- Colorado_SGP@Data[-which(YEAR=='2018' & GRADE %in% c(9,10,11, "EOCT")),]
Colorado_SGP@Data <- Colorado_SGP@Data[-which(CONTENT_AREA %in% c("ALGEBRA_I", "GEOMETRY", "INTEGRATED_MATH_1", "MATHEMATICS_SAT", "ELA_SAT", "SLA")),]
table(Colorado_SGP@Data[, YEAR, CONTENT_AREA]) # only ELA/MATHEMATICS for 2015-2018

###   Re-configure course sequences for CMAS ISRs (CMAS ONLY! - no PSAT/SAT or PARCC EOCT)

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["ELA"]] <- c("3", "4", "5", "6", "7", "8")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["ELA"]] <- c(rep("ELA", 6))
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["ELA"]] <- rep(1L, 5)

SGPstateData[["CO"]][["SGP_Configuration"]][["grade.projection.sequence"]][["MATHEMATICS"]] <- c("3", "4", "5", "6", "7", "8")
SGPstateData[["CO"]][["SGP_Configuration"]][["content_area.projection.sequence"]][["MATHEMATICS"]] <- c(rep("MATHEMATICS", 6))
SGPstateData[["CO"]][["SGP_Configuration"]][["year_lags.projection.sequence"]][["MATHEMATICS"]] <- rep(1L, 5)

SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]] <- NULL

SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Abbreviation"]] <- "CMAS"
SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]]  <- NULL


###   Remove the projections from 8th grade to PSAT 9 (per Dan/Marie request)

Colorado_SGP@SGP$SGProjections$ELA.2018 <- Colorado_SGP@SGP$SGProjections$ELA.2018[SGP_PROJECTION_GROUP!="ELA_PSAT_9",]
Colorado_SGP@SGP$SGProjections$MATHEMATICS.2018 <- Colorado_SGP@SGP$SGProjections$MATHEMATICS.2018[SGP_PROJECTION_GROUP!="MATHEMATICS_PSAT_9",]


###
###   Produce ISRs using visualizeSGP function
###

###  set `ulimit -S -n 4096` to avoid error about too many files open in pdflatex  - also lowered par workers to 30.

visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot"),
	sgPlot.content_areas = c("ELA", "MATHEMATICS"),
	sgPlot.demo.report = TRUE,
	# sgPlot.districts = "0880", # "0100", #
	# sgPlot.schools = missing.schools, # "9389", # "2223"
	sgPlot.front.page = "2018_CMAS_ISR_Cover_Page.pdf", # Visualizations/Misc/  # /home/ec2-user/SGP/Colorado
	sgPlot.header.footer.color="#6EC4E8",
	parallel.config=list(
		BACKEND="PARALLEL",
		WORKERS=list(SG_PLOTS = 15)))


###
###   Post-Hoc checks for missing schools/districs
###

missing.schools <- c('7837', '0018', '1510', '1566', '1568', '2897', '3030', '4100', '4975', '2804', '3472', '4316', '4447', '5229', '0226',
										 '1284', '2760', '3192', '3194', '5286', '5288', '5730', '8903', '8927', '9430', '1352', '1390', '2589', '4878',
										 '6224', '6642', '8135', '8387', '1132', '4680', '2184', '0135', '0215', '0264', '0267', '1512', '1579', '1873', '2012', '2226',
										 '5259', '5997', '6019', '6164', '6365', '6772', '6773', '7245', '7448', '0793', '9061', '2574', '6162', '6686', '1332', '3106',
										 '0517', '3360', '4070', '6306', '7556', '5464', '0074', '1629', '1921', '6140', '8779', '8851', '5093', '5098', '2376', '0660', '0694',
										 '1318', '1976', '2120', '2130', '2300', '2799', '2820', '2832', '2963', '3393', '4404', '4548', '5454', '5472', '6330', '6470',
										 '8381', '9299', '9427', '9428', '7994', '0146', '0892', '0898', '1190', '4698', '5068', '5120', '5168', '7104', '7161', '7198',
										 '9330', '9374', '5335', '1224', '0361', '2392', '6166', '7281', '1888', '0025', '7086', '7212', '8210', '2452', '7755', '9393', '9670',
										 '0053', '0988', '1500', '3880', '4438', '8965')

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

#  No Problem Schools within Districts :-)
