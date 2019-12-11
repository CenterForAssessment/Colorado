################################################################################
###                                                                          ###
###     Calculate SIMEX and Baseline SGPs for Colorado (CMAS Only) - 2019    ###
###                                                                          ###
################################################################################

require(SGP)
require(data.table)

setwd("/Users/avi/Data/CO/SIMEX")
load("/Users/avi/Dropbox (SGP)/SGP/Colorado/Data/Colorado_SGP.Rdata")

Colorado_Data_LONG <- Colorado_SGP@Data[CONTENT_AREA %in% c("ELA", "MATHEMATICS") & GRADE %in% 3:8]

co.csem <- fread("/Users/avi/Syncplicity Folders/NCIEA_CMAS/CMAS 2015-2019 student level CSEMs.csv")
setnames(co.csem, c("FPRC_DASY_KEY", "FPRC_SUMMATIVE_CSEM", "FPRC_SUMMATIVE_SCALE_SCORE"), c("YEAR", "SCALE_SCORE_CSEM", "SCALE_SCORE"))
co.csem[, FPRC_KEY := as.character(FPRC_KEY)]
co.csem[, YEAR := as.character(YEAR)]

dim(Colorado_Data_LONG)

##   Merge CSEM variables with 2015 - 2018 data
setkey(co.csem, FPRC_KEY, YEAR, SCALE_SCORE)
setkey(Colorado_Data_LONG, FPRC_KEY, YEAR, SCALE_SCORE)

Colorado_Data_LONG <- merge(Colorado_Data_LONG, co.csem, all.x = TRUE)

table(Colorado_Data_LONG[, YEAR, is.na(SCALE_SCORE_CSEM)])
table(Colorado_Data_LONG[VALID_CASE=="VALID_CASE", GRADE, is.na(SCALE_SCORE_CSEM)])
tmp.tbl <- Colorado_Data_LONG[VALID_CASE=="VALID_CASE" & is.na(SCALE_SCORE_CSEM) & GRADE %in% 3:8, as.list(summary(SCALE_SCORE)), keyby = c("CONTENT_AREA", "GRADE", "YEAR")]
tmp.tbl[!is.na(Median)]

#  3rd Grade ELA missing CSEMs
table(Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "ELA" & GRADE == 3 & SCALE_SCORE==765, SCALE_SCORE_CSEM], exclude=NULL) # 650

CSEM_Function <- splinefun(
                    Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "ELA" & GRADE == 3 & !is.na(SCALE_SCORE), SCALE_SCORE],
                    Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "ELA" & GRADE == 3 & !is.na(SCALE_SCORE), SCALE_SCORE_CSEM], method="natural")
Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "ELA" & GRADE == 3 & !is.na(SCALE_SCORE) & is.na(SCALE_SCORE_CSEM), SCALE_SCORE_CSEM :=
                    round(CSEM_Function(Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "ELA" & GRADE == 3 & !is.na(SCALE_SCORE) & is.na(SCALE_SCORE_CSEM), SCALE_SCORE]), 1)]

table(Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "ELA" & GRADE == 3 & SCALE_SCORE==765, SCALE_SCORE_CSEM], exclude=NULL)

#  7th Grade MATHEMATICS missing CSEMs
table(Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 7 & SCALE_SCORE==754, SCALE_SCORE_CSEM], exclude=NULL) # 650

CSEM_Function <- splinefun(
                    Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 7 & !is.na(SCALE_SCORE), SCALE_SCORE],
                    Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 7 & !is.na(SCALE_SCORE), SCALE_SCORE_CSEM], method="natural")
Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 7 & !is.na(SCALE_SCORE) & is.na(SCALE_SCORE_CSEM), SCALE_SCORE_CSEM :=
                    round(CSEM_Function(Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 7 & !is.na(SCALE_SCORE) & is.na(SCALE_SCORE_CSEM), SCALE_SCORE]), 1)]

table(Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 7 & SCALE_SCORE==754, SCALE_SCORE_CSEM], exclude=NULL)

#  8th Grade MATHEMATICS missing CSEMs
table(Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 8 & SCALE_SCORE==831, SCALE_SCORE_CSEM], exclude=NULL) # 650

CSEM_Function <- splinefun(
                    Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 8 & !is.na(SCALE_SCORE), SCALE_SCORE],
                    Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 8 & !is.na(SCALE_SCORE), SCALE_SCORE_CSEM], method="natural")
Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 8 & !is.na(SCALE_SCORE) & is.na(SCALE_SCORE_CSEM), SCALE_SCORE_CSEM :=
                    round(CSEM_Function(Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 8 & !is.na(SCALE_SCORE) & is.na(SCALE_SCORE_CSEM), SCALE_SCORE]), 1)]

table(Colorado_Data_LONG[YEAR == "2015" & CONTENT_AREA == "MATHEMATICS" & GRADE == 8 & SCALE_SCORE==831, SCALE_SCORE_CSEM], exclude=NULL)

grep("SGP", names(Colorado_Data_LONG), value=TRUE)
setnames(Colorado_Data_LONG, gsub("SGP", "ORIG", names(Colorado_Data_LONG)))
setnames(Colorado_Data_LONG, gsub("STATUS_3_YEAR", "STATUS_3_YEAR_ORIG", names(Colorado_Data_LONG)))

Colorado_Data_LONG[, VC_ORIG := VALID_CASE]

save(Colorado_Data_LONG, file="Data/Colorado_Data_LONG.rda")



##########
#####        SIMEX SGPs Only, 2017 & 2018
##########


require(SGP)
require(data.table)

setwd("/Users/avi/Data/CO/Colorado")
load("./Data/Colorado_Data_LONG.rda")

###   Make changes to SGPstateData
SGPstateData[["CO"]][["SGP_Configuration"]][["max.order.for.percentile"]] <- 2
SGPstateData[["CO"]][["SGP_Configuration"]][["print.other.gp"]] <- TRUE

###   Read in 2019 SGP Configuration Scripts and Combine
# source("/Users/avi/Dropbox (SGP)/Github_Repos/Projects/Colorado/SGP_CONFIG/2019/ELA.R")
# source("/Users/avi/Dropbox (SGP)/Github_Repos/Projects/Colorado/SGP_CONFIG/2019/MATHEMATICS.R")
#
# COLO_2019.config <- c(
# 	ELA.2019.config,
# 	MATHEMATICS.2019.config
# )

###
###    abcSGP - To produce CMAS SG Percentiles with SIMEX Only
###

Colorado_SGP <- abcSGP(
		sgp_object=Colorado_Data_LONG[YEAR %in% 2015:2018],
		# sgp.config = COLO_2019.config,
    years=c("2017", "2018"), # , "2019"
		content_areas=c("ELA", "MATHEMATICS"),
		steps=c("prepareSGP", "analyzeSGP"), # , "combineSGP", "outputSGP"
		sgp.percentiles = TRUE,
		sgp.projections = TRUE,
		sgp.projections.lagged = TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline = FALSE,
		sgp.projections.lagged.baseline = FALSE,
    calculate.simex = TRUE,
		simulate.sgps = TRUE,
		# sgp.target.scale.scores = TRUE,
		# outputSGP.output.type= "LONG_Data", # c("LONG_FINAL_YEAR_Data"),
		save.intermediate.results=FALSE,
    parallel.config = list(
      BACKEND="FOREACH",
      TYPE="doParallel",
      WORKERS=list(TAUS=8, SIMEX=8)))

###  Save 2019 Colorado SGP object
save(Colorado_SGP, file="Data/Colorado_SGP.Rdata")


##########
#####        BASELINE & SIMEX SGPs
##########

###  Invalidate first cases of repeater students

setkey(Colorado_SGP@Data, VALID_CASE, CONTENT_AREA, ID, GRADE, YEAR)
setkey(Colorado_SGP@Data, VALID_CASE, CONTENT_AREA, ID, GRADE)
dups <- data.table(Colorado_SGP@Data[unique(c(which(duplicated(Colorado_SGP@Data, by=key(Colorado_SGP@Data)))-1, which(duplicated(Colorado_SGP@Data, by=key(Colorado_SGP@Data))))), ], key=key(Colorado_SGP@Data))
table(dups$VALID_CASE) # 1495 duplicates within GRADE are already INVALID_CASEs - 11354 still VALID_CASEs
Colorado_SGP@Data[which(duplicated(Colorado_SGP@Data, by=key(Colorado_SGP@Data)))-1, VALID_CASE := "INVALID_CASE"]

table(Colorado_SGP@Data[, VALID_CASE, VC_ORIG])

Colorado_SGP@Data <- rbindlist(list(Colorado_SGP@Data, Colorado_Data_LONG[YEAR == 2019]), fill = TRUE)
Colorado_SGP <- prepareSGP(Colorado_SGP, create.additional.variables=FALSE)

###   Make changes to SGPstateData
SGPstateData[["CO"]][["SGP_Configuration"]][["max.order.for.percentile"]] <- 2
SGPstateData[["CO"]][["SGP_Configuration"]][["max.order.for.projection"]] <- 3 # Force uncorrected to match SIMEX
SGPstateData[["CO"]][["SGP_Configuration"]][["print.other.gp"]] <- TRUE
SGPstateData[["CO"]][["Growth"]][["System_Type"]] <- "Cohort and Baseline Referenced"


###		Calculate SIMEX/Baseline SGPs for CMAS Content Areas
	Colorado_SGP <- analyzeSGP(
		Colorado_SGP,
		years="2019",
		content_areas=c("ELA", "MATHEMATICS"),
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=TRUE,
		sgp.projections.baseline=TRUE,
		sgp.projections.lagged.baseline=TRUE,
		sgp.baseline.panel.years=c("2015", "2016", "2017", "2018"),
		simulate.sgps = TRUE,
    calculate.simex=list(csem.data.vnames="SCALE_SCORE_CSEM", lambda=seq(0,2,0.5), simulation.iterations=75,
                                  simex.sample.size=5000, extrapolation="linear", save.matrices=TRUE),
		calculate.simex.baseline=list(csem.data.vnames="SCALE_SCORE_CSEM", lambda=seq(0,2,0.5), simulation.iterations=75,
                                  simex.sample.size=10000, extrapolation="linear", save.matrices=TRUE, use.cohort.for.ranking=TRUE),
    parallel.config = list(
        BACKEND="FOREACH",
        TYPE="doParallel",
        WORKERS=list(TAUS=8, SIMEX=8))
  )

names(Colorado_SGP@SGP[[1]][["ELA.BASELINE.SIMEX"]][[2]])

Colorado_SGP <- combineSGP(Colorado_SGP,
                    # years = "2019",
                    sgp.target.scale.scores = TRUE,
                    parallel.config = list(
                      BACKEND="PARALLEL",
                      WORKERS=list(SGP_SCALE_SCORE_TARGETS=2)))

###  Save 2019 Colorado SGP object
save(Colorado_SGP, file="./Data/Colorado_SGP.Rdata")

Colorado_SGP@Data[, grep("ORIG", names(Colorado_SGP@Data), value=TRUE) := NULL]

outputSGP(Colorado_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"))
