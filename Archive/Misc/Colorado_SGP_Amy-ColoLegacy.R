#################################################################
###   Script for 5 steps of the SGP Package with Colorado Data
#################################################################

#  Load the LONG data:
load("~/CO_LONG.Rdata")

### Code used to clean up the original CO_LONG data file:

# levels(CO_LONG[['CONTENT_AREA']]) <- c('READING', 'MATHEMATICS') #Swith labels

# CO_LONG[['ACHIEVEMENT_LEVEL_PROVIDED']] <- CO_LONG[['ACHIEVEMENT_LEVEL']]
# perlev.recode <- function(scale_scores, state, CONTENT_AREA, grade) {
	# findInterval(scale_scores, SGPstateData[[state]][["Achievement"]][["Cutscores"]][[as.character(CONTENT_AREA)]][[paste("GRADE_", grade, sep="")]])+1
# }

# CO_LONG <- data.table(CO_LONG, key=c("CONTENT_AREA", "GRADE"))
# CO_LONG[['ACHIEVEMENT_LEVEL']] <- CO_LONG[, perlev.recode(SCALE_SCORE, "CO", CONTENT_AREA[1], GRADE[1]), by=list(CONTENT_AREA, GRADE)]$V1
# table(CO_LONG[['ACHIEVEMENT_LEVEL_PROVIDED']], CO_LONG[['ACHIEVEMENT_LEVEL']])
# CO_LONG[['ACHIEVEMENT_LEVEL_PROVIDED']] <- NULL
# CO_LONG[['ACHIEVEMENT_LEVEL']][is.na(CO_LONG[['ACHIEVEMENT_LEVEL']])] <- 5
# CO_LONG[['ACHIEVEMENT_LEVEL']] <- ordered(CO_LONG[['ACHIEVEMENT_LEVEL']], levels = 1:5, labels=c("Unsatisfactory", "Partially Proficient", "Proficient", "Advanced", "No Score"))

# CO_LONG[['YEAR']] <- CO_LONG[['YEAR']]+2002

# table(CO_LONG$GRADE, CO_LONG$CONTENT_AREA, CO_LONG$YEAR)


#  Step 1.
Colorado_SGP <- prepareSGP(CO_LONG)

#  Poke around the new SGP Object:
class(Colorado_SGP)
slotNames( Colorado_SGP )
names(Colorado_SGP@Data)
class(Colorado_SGP@Data)
sapply(Colorado_SGP@Data, class)
dim(Colorado_SGP@Data)
head(Colorado_SGP@Data)
summary(Colorado_SGP@Data)

#  If you just want to take a subset to run for fun:
# # half.data <- CO_LONG[CO_LONG$CONTENT_AREA == "READING" & CO_LONG$GRADE <= 6 & CO_LONG$YEAR %in% c(2009, 2010, 2011),]
# Colorado_SGP <- prepareSGP(half.data)
 
 #  Step 2.
 
 
###  Manually specified sgp.config data.  Needed for the Colorado data because of grade level testing differences in 2003-4 in READING and MATH (no grade 3/4)
my.config <- list(
READING.2009 = list(
	sgp.content.areas=rep("READING", 7),
	sgp.panel.years=2003:2009,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 4:10)),
READING.2010 = list(
	sgp.content.areas=rep("READING", 8),
	sgp.panel.years=2003:2010,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 3:10)),
READING.2011 = list(
	sgp.content.areas=rep("READING", 9),
	sgp.panel.years=2003:2011,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 3:10)),

MATHEMATICS.2009 = list(
	sgp.content.areas=rep("MATHEMATICS", 7),
	sgp.panel.years=2003:2009,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 4:8, 5:9, 5:10)), # Note Different grade 8,9,10
MATHEMATICS.2010 = list(
	sgp.content.areas=rep("MATHEMATICS", 8),
	sgp.panel.years=2003:2010,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 4:9, 5:10)),
MATHEMATICS.2011 = list(
	sgp.content.areas=rep("MATHEMATICS", 9),
	sgp.panel.years=2003:2011,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 4:10)))

###  Another version of the sgp.config that only uses 3 years of data
my.config.2 <- list(
READING.2011 = list(
	sgp.content.areas=rep("READING", 3),
	sgp.panel.years=2009:2011,
	sgp.grade.sequences=list(3:4, 3:5, 4:6, 5:7, 6:8, 7:9, 8:10)),

MATHEMATICS.2011 = list(
	sgp.content.areas=rep("MATHEMATICS", 3),
	sgp.panel.years=2009:2011,
	sgp.grade.sequences=list(3:4, 3:5, 4:6, 5:7, 6:8, 7:9, 8:10)))

Colorado_SGP <- analyzeSGP(
	Colorado_SGP,
	sgp.config = Amy.config.2,
	# sgp.percentiles = FALSE, 
	# sgp.projections = FALSE, 
	# sgp.projections.lagged = FALSE, 
	sgp.percentiles.baseline = FALSE,
	sgp.projections.baseline = FALSE,
	sgp.projections.lagged.baseline = FALSE,
	simulate.sgps=FALSE,
	parallel.config=list(
		BACKEND=list(TYPE="SNOW", SNOW_TYPE="SOCK"),
		ANALYSES=list(PERCENTILE_WORKERS=8, 
		PROJECTIONS_WORKERS=4, LAGGED_PROJECTIONS_WORKERS=4)))

#  Save the SGP Object as an .Rdata file:
save(Colorado_SGP, file="Colorado_SGP.Rdata", compress='bzip2')

names(Colorado_SGP@SGP)
class(Colorado_SGP@SGP)
head(Colorado_SGP@SGP$SGPercentiles$READING.2011)

#  How to write out results from SGP Object to a .csv file:
write.csv(Colorado_SGP@SGP$SGPercentiles$READING.2011, file="READ.11.csv", row.names=FALSE)

###  Adam's aside:  The one line heart of the studentGrowthPercentiles/analyzeSGP functions:
###  Britt, you don't need to run this :)
	#  Subset the data
	new.data <- subset(sgpData, GRADE_2011==8)
	
	#  Create the knots and boundaries for the prior year data.
	ks <- as.vector(unlist(round(quantile(new.data$SS_2010, probs=c(0.2,0.4,0.6,0.8), na.rm=TRUE),digits=3)))
	bs <- as.vector(round(extendrange(new.data$SS_2010, f=0.1), digits=3))
	
	#  Here it is - the SGP one liner!  Kind of...
	qr <- rq(SS_2011 ~ bs(SS_2010, knots=ks, Boundary.knots=bs), data=new.data, tau=seq(0.005, 0.995, by=0.01))



#  Step 3.

names(Colorado_SGP@Data)
dim(Colorado_SGP@Data) 

Colorado_SGP <- combineSGP(Colorado_SGP)

names(Colorado_SGP@Data)
dim(Colorado_SGP@Data) 
summary(Colorado_SGP@Data$SGP)

head(Colorado_SGP@SGP$SGProjections$READING.2011.LAGGED)

#  Step 4.

#  summarizeSGP must be set up to run in parallel outside of the function.  This works on Windows, as of version 0.8-0.0, but requires sourcing in the 'summarizeSGP_Util_Functions.R' script.
library(doSNOW)
doSNOW.cl = makeCluster(8, type = "SOCK") #  The first argument (8 here) is the number of cores you have available for parallel processing.
registerDoSNOW(doSNOW.cl)

source('summarizeSGP_Util_Functions.R')

clusterExport(doSNOW.cl, list('rbind.all', 'group.format', 'median_na', 'boot.median', 'mean_na', 'num_non_missing', 'percent_in_category', 'percent_at_above_target', 'boot.sgp', 'sgpSummary', 'combineSims'))

Colorado_SGP <- summarizeSGP(Colorado_SGP,
		sgp.summaries=list(MEDIAN_SGP="median_na(SGP)",
             MEDIAN_SGP_COUNT="num_non_missing(SGP)",
             MEDIAN_SGP_TARGET="median_na(SGP_TARGET)",
             MEDIAN_SGP_TARGET_COUNT="num_non_missing(SGP_TARGET)",
             PERCENT_AT_ABOVE_PROFICIENT="percent_in_category(ACHIEVEMENT_LEVEL, list(c('Proficient', 'Advanced')), list(c('Unsatisfactory', 'Partially Proficient', 'Proficient', 'Advanced')))",
             PERCENT_AT_ABOVE_PROFICIENT_COUNT="num_non_missing(ACHIEVEMENT_LEVEL)",
             PERCENT_AT_ABOVE_PROFICIENT_PRIOR="percent_in_category(ACHIEVEMENT_LEVEL_PRIOR, list(c('Proficient', 'Advanced')), list(c('Unsatisfactory', 'Partially Proficient', 'Proficient', 'Advanced')))",
             PERCENT_AT_ABOVE_PROFICIENT_PRIOR_COUNT="num_non_missing(ACHIEVEMENT_LEVEL_PRIOR)"),
		summary.groups=list(institution=c("STATE", "SCHOOL_NUMBER, SCHOOL_ENROLLMENT_STATUS", "TEACHER_ID"),
             content="CONTENT_AREA",
             time=NULL, #  NULL because we only did 2011 analyses
             institution_level="GRADE",
             demographic=c("ETHNICITY", "FREE_REDUCED_LUNCH_STATUS", "ELL_STATUS", "IEP_STATUS", 
             	"CATCH_UP_KEEP_UP_STATUS_INITIAL"),
             institution_inclusion=list(STATE=NULL, #DISTRICT_NUMBER=...,
             	SCHOOL_NUMBER="SCHOOL_ENROLLMENT_STATUS",TEACHER_ID="SCHOOL_ENROLLMENT_STATUS")),
		confidence.interval.groups=list(TYPE="Bootstrap",
             VARIABLES=c("SGP"),
             QUANTILES=c(0.025, 0.975),
             GROUPS=list(institution=c("SCHOOL_NUMBER", "TEACHER_ID"),
               content="CONTENT_AREA",
               time=NULL,
               institution_level= NULL,
               demographic=NULL,
               institution_inclusion=list(STATE=NULL, SCHOOL_NUMBER="SCHOOL_ENROLLMENT_STATUS",
               	TEACHER_ID="SCHOOL_ENROLLMENT_STATUS"))))

# Run this next line if you are using the doSNOW parallel backend:
stopCluster(doSNOW.cl)

names(Colorado_SGP@Summary)

#  Version 0.9-0.0 should have internal parallelization:
# parallel.config=list(
	# BACKEND=list(TYPE="PARALLEL", SNOW_TYPE="SOCK"),
	# ANALYSES=list(SUMMARY_WORKERS=8))

#  Step 5.

visualizeSGP(Colorado_SGP, plot.types= "bubblePlot", bPlot.format="presentation")
