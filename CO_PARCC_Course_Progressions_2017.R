################################################################################
###                                                                          ###
###            Identify 2017 Progressions for Colorado CMAS/PARCC            ###
###                                                                          ###
################################################################################

library(SGP)
library(plyr)
library(data.table)

###  Load Data
load("Data/Colorado_SGP.Rdata")
load("Data/Colorado_Data_LONG_2017.Rdata")

Colorado_Data_LONG <- rbindlist(list(Colorado_SGP@Data, Colorado_Data_LONG_2017), fill=TRUE)


##  Remove _SS tag to make things easier/legible
Colorado_Data_LONG[, CONTENT_AREA := gsub("_SS", "", CONTENT_AREA)]

math.prog<- courseProgressionSGP(Colorado_Data_LONG[!CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2016_2017.2')
ela.prog <- courseProgressionSGP(Colorado_Data_LONG[CONTENT_AREA %in% "ELA"], lag.direction="BACKWARD", year='2016_2017.2')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the Spring 17 data
names(math.prog$BACKWARD[['2016_2017.2']])

###
###   Algebra I (No Repeaters or Regression)
###

ALG1 <- math.prog$BACKWARD[['2016_2017.2']]$ALGEBRA_I.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_I.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG1 <- ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "ALGEBRA_I.EOCT"]
table(ALG1$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ALG1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 16) ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                      GEOMETRY.EOCT    21		XXX
# 2:             INTEGRATED_MATH_1.EOCT    81		XXX
# 3:             INTEGRATED_MATH_2.EOCT     3		XXX
# 4:                     MATHEMATICS.05     1		XXX
# 5:                     MATHEMATICS.06  2172
# 6:                     MATHEMATICS.07  7717
# 7:                     MATHEMATICS.08 21094


###   Viable 2 Prior (Spring 16 + Spring 15) ALGEBRA_I Progressions
ALG1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     MATHEMATICS.06                     MATHEMATICS.05  2168
# 2:                     MATHEMATICS.07                     MATHEMATICS.06  7693
# 3:                     MATHEMATICS.08                     MATHEMATICS.07 21029


###
###   Geometry (No Repeaters)
###

GEOM <- math.prog$BACKWARD[['2016_2017.2']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
GEOM <- GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "GEOMETRY.EOCT"]
table(GEOM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
GEOM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 16) GEOMETRY Progressions
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT  6631
# 2:             INTEGRATED_MATH_1.EOCT    57		XXX
# 3:                     MATHEMATICS.06     2		XXX
# 4:                     MATHEMATICS.07   205		XXX
# 5:                     MATHEMATICS.08  1696		???   XXX   ???

###   Viable 2 Prior (Spring 16 + Spring 15) GEOMETRY Progressions
GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 50]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT                     ALGEBRA_I.EOCT    65		XXX
# 2:                     ALGEBRA_I.EOCT                     MATHEMATICS.06  1797		XXX
# 3:                     ALGEBRA_I.EOCT                     MATHEMATICS.07  4688
# 4:                     ALGEBRA_I.EOCT                     MATHEMATICS.08    78		XXX   CANONICAL!!!
# 5:             INTEGRATED_MATH_1.EOCT                     MATHEMATICS.07    52		XXX
# 6:                     MATHEMATICS.07                     MATHEMATICS.06   203		XXX
# 7:                     MATHEMATICS.08                     MATHEMATICS.07  1688		XXX

GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="MATHEMATICS.08"] #  Since testing only through 9th Grade the CANONICAL progression gets cut off.  Single prior available, but not sure we should use for SGP TARGETS...


###
###   Algebra II (No Repeaters)
###

ALG2 <- math.prog$BACKWARD[['2016_2017.2']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG2 <- ALG2[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "ALGEBRA_II.EOCT"]

ALG2[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 16) ALGEBRA_II Progressions
ALG2[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT   227		XXX
# 2:                      GEOMETRY.EOCT  1413
# 3:             INTEGRATED_MATH_1.EOCT    45		XXX
# 4:             INTEGRATED_MATH_2.EOCT    14		XXX
# 5:                     MATHEMATICS.08   151		XXX

###   NONE!  Run GEOMETRY.EOCT for the SGP_NOTE variable


###
###   Integrated Math 1
###

INTM1 <- math.prog$BACKWARD[['2016_2017.2']]$INTEGRATED_MATH_1.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "INTEGRATED_MATH_1.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
INTM1 <- INTM1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "INTEGRATED_MATH_1.EOCT"]

INTM1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior(Spring 16) GEOMETRY Progressions (ENFORCE THAT NO Fall 16 TEST AVAILABLE?)
INTM1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1  Total
# 1:                     ALGEBRA_I.EOCT    67		XXX
# 2:                      GEOMETRY.EOCT     3		XXX
# 3:                     MATHEMATICS.05     1		XXX
# 4:                     MATHEMATICS.06   106		XXX
# 5:                     MATHEMATICS.07  1252		???
# 6:                     MATHEMATICS.08  6702
###   Establish config with MATHEMATICS.07 for the SGP_NOTE variable


###   Viable 2 Prior (Spring 16 + Spring 15) GEOMETRY Progressions
INTM1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 50]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT                     MATHEMATICS.07    53		XXX
# 2:                     MATHEMATICS.06                     MATHEMATICS.05   106		XXX
# 3:                     MATHEMATICS.07                     MATHEMATICS.06  1252
# 4:                     MATHEMATICS.08                     MATHEMATICS.07  6678

###
###   Integrated Math 2
###

INTM2 <- math.prog$BACKWARD[['2016_2017.2']]$INTEGRATED_MATH_2.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "INTEGRATED_MATH_2.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
INTM2 <- INTM2[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "INTEGRATED_MATH_2.EOCT"]

INTM2[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 16) INTEGRATED_MATH_2 Progressions
INTM2[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
### - NONE
###   Establish config with INTEGRATED_MATH_1.EOCT for the SGP_NOTE variable


###
###   Integrated Math 3
###

INTM3 <- math.prog$BACKWARD[['2016_2017.2']]$INTEGRATED_MATH_3.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "INTEGRATED_MATH_3.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
INTM3 <- INTM3[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "INTEGRATED_MATH_3.EOCT"]

INTM3[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 16) INTEGRATED_MATH_2 Progressions
INTM3[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
### - NONE


####
####     ELA
####

###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2016_2017.2']])

###  No Spring to FallBlock  -  Establish configs for the SGP_NOTE variable
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA.04[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.03"]$COUNT)   #  58882
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA.05[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.04"]$COUNT)   #  58331
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA.06[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.05"]$COUNT)   #  55984
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA.07[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.06"]$COUNT)   #  53623
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA.08[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.07"]$COUNT)   #  50777
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA.08[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.07" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.06"]$COUNT)   #  47001
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #  42614
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.07"]$COUNT)   #  39214
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  488 (repeaters)
