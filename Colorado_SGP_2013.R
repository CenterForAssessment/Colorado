##############################################################
###
### Script for Calculating 2013 SGPs for Colorado
###
##############################################################

### Load SGP Package

require(SGP)

### Load data

#load("/u01/Marie/2012/Colorado_SGP.Rdata")
load("Colorado_Data_LONG.Rdata")
#load("Data/Colorado_SGP.Rdata")


### prepareSGP 

Colorado_SGP = prepareSGP(Colorado_Data_LONG, var.names=NULL, state="CO")


### analyzeSGP

###  Manually specified sgp.config data.  Needed for the Colorado data because of grade level testing differences in 2003-4 in READING and MATH (no grade 3/4)

my.config <- list(

READING.2013 = list(
	sgp.content.areas=rep("READING", 11),
	sgp.panel.years=as.character(2003:2013),
	sgp.grade.sequences=list(as.character(3:4), as.character(3:5), as.character(3:6), as.character(3:7), as.character(3:8), as.character(3:9), as.character(3:10))),

MATHEMATICS.2013 = list(
	sgp.content.areas=rep("MATHEMATICS", 10),
	sgp.panel.years=as.character(2003:2013),
	sgp.grade.sequences=list(as.character(3:4), as.character(3:5), as.character(3:6), as.character(3:7), as.character(3:8), as.character(3:9), as.character(3:10))),

WRITING.2013 = list(
	sgp.content.areas=rep("WRITING", 10),
	sgp.panel.years=as.character(2003:2013),
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
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=6, BASELINE_PERCENTILES=6, PROJECTIONS=10, LAGGED_PROJECTIONS=10)),
	simulate.sgps=FALSE)


### combineSGP

Colorado_SGP <- combineSGP(Colorado_SGP, update.all.years=TRUE)


### summarizeSGP

Colorado_SGP <- summarizeSGP(Colorado_SGP, parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SUMMARY=10)))


### visualizeSGP

visualizeSGP(Colorado_SGP, sgPlot.demo.report=TRUE)


###  Save the SGP Object as an .Rdata file:

save(Colorado_SGP, file="Colorado_SGP.Rdata", compress='bzip2')

