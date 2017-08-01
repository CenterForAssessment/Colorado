################################################################################
###                                                                          ###
###            Identify 2017 Progressions for Colorado CMAS/PARCC            ###
###                                                                          ###
################################################################################

library(SGP)
library(plyr)
library(data.table)

###  Load Data
load("Data/Archive/July 2017/Colorado_SGP_LONG_Data.Rdata")
load("Data/Colorado_Data_LONG_2017-PSAT_SAT.Rdata")

Colorado_Data_LONG <- rbindlist(list(Colorado_SGP_LONG_Data, Colorado_Data_LONG_2017), fill=TRUE)


##  Remove _SS tag to make things easier/legible
Colorado_Data_LONG[, CONTENT_AREA := gsub("_SS", "", CONTENT_AREA)]
ids <- unique(Colorado_Data_LONG_2017[YEAR=="2016_2017.2", ID])
Subset_Data_LONG <- Colorado_Data_LONG[ID %in% ids,]


ela.prog <- courseProgressionSGP(Subset_Data_LONG[grepl("ELA", CONTENT_AREA)], lag.direction="BACKWARD", year='2016_2017.2')
math.prog<- courseProgressionSGP(Subset_Data_LONG[!grepl("ELA", CONTENT_AREA)], lag.direction="BACKWARD", year='2016_2017.2')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the Spring 17 data
names(math.prog$BACKWARD[['2016_2017.2']])

###
###   PSAT MATHEMATICS
###

PSATM <- math.prog$BACKWARD[['2016_2017.2']]$MATHEMATICS_PSAT.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_PSAT.10" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
PSATM <- PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_PSAT.10" & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
table(PSATM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
PSATM[COUNT > 500]  #  Major progressions

###   Viable 1 Prior (Spring 16) Progressions
PSATM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT 23845
# 2:                    ALGEBRA_II.EOCT  2283
# 3:                      GEOMETRY.EOCT  7987
# 4:             INTEGRATED_MATH_1.EOCT  6684
# 5:             INTEGRATED_MATH_2.EOCT  1206   #XXX#
# 6:             INTEGRATED_MATH_3.EOCT   168   #XXX#
# 7:                     MATHEMATICS.03     1
# 8:                     MATHEMATICS.07     2
# 9:                     MATHEMATICS.08    16


###   Viable 2 Prior (Spring 16 + Spring 15) ALGEBRA_I Progressions
PSATM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 1500]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT                     MATHEMATICS.08 19292
# 2:                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT  5186
# 3:                      GEOMETRY.EOCT                     MATHEMATICS.08  1687   #XXX#
# 4:             INTEGRATED_MATH_1.EOCT                     MATHEMATICS.08  5952


###
###   SAT MATHEMATICS
###

SATM <- math.prog$BACKWARD[['2016_2017.2']]$MATHEMATICS_SAT.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_SAT.11" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
SATM <- SATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_SAT.11" & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
table(SATM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
SATM[COUNT > 500]  #  Major progressions

###   Viable 1 Prior (Spring 16) Progressions
SATM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT    94
# 2:                    ALGEBRA_II.EOCT     1
# 3:                      GEOMETRY.EOCT    34
# 4:             INTEGRATED_MATH_1.EOCT    10
# 5:             INTEGRATED_MATH_2.EOCT     1
# 6:                     MATHEMATICS.06     1
# 7:                     MATHEMATICS.08     2
# 8:                MATHEMATICS_PSAT.10 50259

###   Viable 2 Prior (Spring 16 + Spring 15) Progressions
SATM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 1500]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                MATHEMATICS_PSAT.10                     ALGEBRA_I.EOCT 18210
# 2:                MATHEMATICS_PSAT.10                    ALGEBRA_II.EOCT  1681		#XXX#
# 3:                MATHEMATICS_PSAT.10                      GEOMETRY.EOCT  8093
# 4:                MATHEMATICS_PSAT.10             INTEGRATED_MATH_1.EOCT  6229
# 5:                MATHEMATICS_PSAT.10             INTEGRATED_MATH_2.EOCT  1522		#XXX#


####
####     ELA
####

###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2016_2017.2']])

###  No Spring to FallBlock  -  Establish configs for the SGP_NOTE variable
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA_PSAT.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  42307
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA_PSAT.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1!="ELA.09"]$COUNT)   #    256
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA_PSAT.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.08"]$COUNT)   #  37241
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA_SAT.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA_PSAT.10"]$COUNT)   #  42614
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA_SAT.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1!="ELA_PSAT.10"]$COUNT)   #    141
sum(ela.prog$BACKWARD[['2016_2017.2']]$ELA_SAT.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA_PSAT.10" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT)   #  36187
