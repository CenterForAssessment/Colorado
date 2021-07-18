##############################################################
###
### Script for Calculating 2014 SGPs for Colorado
###
##############################################################

### Load SGP Package

require(SGP)

### Load data

load("Data/Colorado_Data_LONG.Rdata")


### prepareSGP 

Colorado_SGP = prepareSGP(Colorado_Data_LONG, var.names=NULL, state="CO")


### analyzeSGP

###  Manually specified sgp.config data.  Needed for the Colorado data because of grade level testing differences in 2003-4 in READING and MATH (no grade 3/4)

my.config <- list(

READING.2014 = list(
	sgp.content.areas=rep("READING", 12),
	sgp.panel.years=as.character(2003:2014),
	sgp.grade.sequences=list(as.character(3:4), as.character(3:5), as.character(3:6), as.character(3:7), as.character(3:8), as.character(3:9), as.character(3:10))),

MATHEMATICS.2014 = list(
	sgp.content.areas=rep("MATHEMATICS", 12),
	sgp.panel.years=as.character(2003:2014),
	sgp.grade.sequences=list(as.character(3:4), as.character(3:5), as.character(3:6), as.character(3:7), as.character(3:8), as.character(3:9), as.character(3:10))),

WRITING.2014 = list(
	sgp.content.areas=rep("WRITING", 12),
	sgp.panel.years=as.character(2003:2014),
	sgp.grade.sequences=list(as.character(3:4), as.character(3:5), as.character(3:6), as.character(3:7), as.character(3:8), as.character(3:9), as.character(3:10))))

Colorado_SGP <- analyzeSGP(
	Colorado_SGP,
	sgp.config = my.config,
	sgp.percentiles = TRUE, 
	sgp.projections = TRUE, 
	sgp.projections.lagged = TRUE, 
	sgp.percentiles.baseline = TRUE,
	sgp.projections.baseline = TRUE,
	sgp.projections.lagged.baseline = TRUE,
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=14, BASELINE_PERCENTILES=14, PROJECTIONS=10, LAGGED_PROJECTIONS=10)),
	simulate.sgps=FALSE)


### combineSGP

Colorado_SGP <- combineSGP(Colorado_SGP)


### summarizeSGP

Colorado_SGP <- summarizeSGP(Colorado_SGP, parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SUMMARY=20)))


### visualizeSGP

visualizeSGP(Colorado_SGP, sgPlot.demo.report=TRUE)


### Merge with original Colorado SGP

#save(Colorado_SGP, file="Colorado_SGP.Rdata", compress='bzip2')

