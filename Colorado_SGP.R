### Read-in SPSS data file
Colorado_Data_LONG <- read.spss("CSAP_02_12_readin.sav", to.data.frame=TRUE, use.value.labels=FALSE)

### Load SGP Package

require(SGP)
require(foreign)

### Load data
load("XXXXXXX\\Colorado_Data_LONG.Rdata")

###prepare data

Colorado_SGP = prepareSGP(Colorado_Data_LONG, var.names=NULL, state="CO")

###  Manually specified sgp.config data.  Needed for the Colorado data because of grade level testing differences in 2003-4 in READING and MATH (no grade 3/4)
my.config <- list(
READING.2005 = list(
	sgp.content.areas=rep("READING", 3),
	sgp.panel.years=2003:2005,
	sgp.grade.sequences=list(3:4, 3:5, 4:6, 5:7, 6:8, 7:9, 8:10)),
READING.2006 = list(
	sgp.content.areas=rep("READING", 4),
	sgp.panel.years=2003:2006,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 4:7, 5:8, 6:9, 7:10)),
READING.2007 = list(
	sgp.content.areas=rep("READING", 5),
	sgp.panel.years=2003:2007,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 4:8, 5:9, 6:10)),
READING.2008 = list(
	sgp.content.areas=rep("READING", 6),
	sgp.panel.years=2003:2008,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 4:9, 5:10)),
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
READING.2012 = list(
	sgp.content.areas=rep("READING", 10),
	sgp.panel.years=2003:2012,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 3:10)),

MATHEMATICS.2005 = list(
	sgp.content.areas=rep("MATHEMATICS", 3),
	sgp.panel.years=2003:2005,
	sgp.grade.sequences=list(5:6, 5:7, 6:8, 7:9, 8:10)), # Note Different grade 4,5,6,7,8,9,10
MATHEMATICS.2006 = list(
	sgp.content.areas=rep("MATHEMATICS", 4),
	sgp.panel.years=2003:2006,
	sgp.grade.sequences=list(3:4, 4:5, 5:6, 5:7, 5:8, 6:9, 7:10)), # Note Different grade 5,6,7,8,9,10
MATHEMATICS.2007 = list(
	sgp.content.areas=rep("MATHEMATICS", 5),
	sgp.panel.years=2003:2007,
	sgp.grade.sequences=list(3:4, 3:5, 4:6, 5:7, 5:8, 5:9, 6:10)), # Note Different grade 6,7,8,9,10
MATHEMATICS.2008 = list(
	sgp.content.areas=rep("MATHEMATICS", 6),
	sgp.panel.years=2003:2008,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 4:7, 5:8, 5:9, 5:10)), # Note Different grade 7,8,9,10
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
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 4:10)),
MATHEMATICS.2012 = list(
	sgp.content.areas=rep("MATHEMATICS", 10),
	sgp.panel.years=2003:2012,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 3:10)),


WRITING.2005 = list(
	sgp.content.areas=rep("WRITING", 3),
	sgp.panel.years=2003:2005,
	sgp.grade.sequences=list(3:4, 3:5, 4:6, 5:7, 6:8, 7:9, 8:10)),
WRITING.2006 = list(
	sgp.content.areas=rep("WRITING", 4),
	sgp.panel.years=2003:2006,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 4:7, 5:8, 6:9, 7:10)),
WRITING.2007 = list(
	sgp.content.areas=rep("WRITING", 5),
	sgp.panel.years=2003:2007,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 4:8, 5:9, 6:10)),
WRITING.2008 = list(
	sgp.content.areas=rep("WRITING", 6),
	sgp.panel.years=2003:2008,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 4:9, 5:10)),
WRITING.2009 = list(
	sgp.content.areas=rep("WRITING", 7),
	sgp.panel.years=2003:2009,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 4:10)),
WRITING.2010 = list(
	sgp.content.areas=rep("WRITING", 8),
	sgp.panel.years=2003:2010,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 3:10)),
WRITING.2011 = list(
	sgp.content.areas=rep("WRITING", 9),
	sgp.panel.years=2003:2011,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 3:10)),
WRITING.2012 = list(
	sgp.content.areas=rep("WRITING", 10),
	sgp.panel.years=2003:2012,
	sgp.grade.sequences=list(3:4, 3:5, 3:6, 3:7, 3:8, 3:9, 3:10)))

#########################

Colorado_SGP <- analyzeSGP(
	state="CO",
	Colorado_SGP,
	sgp.config = my.config,
	sgp.percentiles = TRUE, 
	sgp.projections = TRUE, 
	sgp.projections.lagged = TRUE, 
	sgp.percentiles.baseline = TRUE,
	sgp.projections.baseline = TRUE,
	sgp.projections.lagged.baseline = TRUE,
	simulate.sgps=FALSE)

#  Save the SGP Object as an .Rdata file:
save(Colorado_SGP, file="Colorado_SGP.Rdata", compress='bzip2')


