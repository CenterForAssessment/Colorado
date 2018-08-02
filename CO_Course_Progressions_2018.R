################################################################################
###                                                                          ###
###          Identify 2018 Progressions for Colorado CMAS/PSAT/SAT           ###
###                                                                          ###
################################################################################

library(SGP)

###  Load Data
load("Data/Colorado_Data_LONG.Rdata")


##  Remove _SS tag to make things easier/legible
ids <- unique(Colorado_Data_LONG[YEAR=="2018", ID])
Subset_Data_LONG <- Colorado_Data_LONG[ID %in% ids,]


ela.prog <- SGP::courseProgressionSGP(Subset_Data_LONG[grepl("ELA", CONTENT_AREA)], lag.direction="BACKWARD", year='2018')
math.prog<- SGP::courseProgressionSGP(Subset_Data_LONG[!grepl("ELA|SLA", CONTENT_AREA)], lag.direction="BACKWARD", year='2018')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the Spring 17 data
names(math.prog$BACKWARD[['2018']])

###   Algebra I (No Repeaters or Regression)

ALG1 <- math.prog$BACKWARD[['2018']]$ALGEBRA_I.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_I.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
ALG1 <- ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "ALGEBRA_I.EOCT"]
table(ALG1$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ALG1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 17) ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:             INTEGRATED_MATH_1.EOCT     1
# 2:                     MATHEMATICS.06   894
# 3:                     MATHEMATICS.07  5883  #  YES
# 4:                     MATHEMATICS.08     2


###   Viable 2 Prior (Spring 17 + Spring 16) ALGEBRA_I Progressions
ALG1[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     MATHEMATICS.06                     MATHEMATICS.05   892
# 2:                     MATHEMATICS.07                     MATHEMATICS.06  5878




###   Geometry (No Repeaters)

GEOM <- math.prog$BACKWARD[['2018']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
GEOM <- GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "GEOMETRY.EOCT"]
table(GEOM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
GEOM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior (Spring 17) GEOMETRY Progressions
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT  1418
# 2:                     MATHEMATICS.07    73

###   Viable 2 Prior (Spring 17 + Spring 16) GEOMETRY Progressions
GEOM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 50]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT                     MATHEMATICS.06  1417
# 2:                     MATHEMATICS.07                     MATHEMATICS.06    73


###   PSAT 9 MATHEMATICS

PSATM <- math.prog$BACKWARD[['2018']]$MATHEMATICS_PSAT_9.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_PSAT_9.09" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
PSATM <- PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_PSAT_9.09" & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
table(PSATM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
PSATM[COUNT > 500]  #  Major progressions

###   Viable 1 Prior (Spring 17) Progressions
PSATM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT  8947 # YES
# 2:                      GEOMETRY.EOCT  2202 # YES
# 3:             INTEGRATED_MATH_1.EOCT  1400 # YES
# 4:             INTEGRATED_MATH_2.EOCT   151
# 5:                     MATHEMATICS.06   125
# 6:                     MATHEMATICS.07   165
# 7:                     MATHEMATICS.08 38506 # YES CANONICAL
# 8:             MATHEMATICS_PSAT_10.10    13
# 9:                 MATHEMATICS_SAT.11     1


###   Viable 2 Prior (Spring 17 + Spring 16) ALGEBRA_I Progressions
PSATM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 1500]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT                     MATHEMATICS.07  7746
# 2:                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT  1809
# 3:                     MATHEMATICS.08                     MATHEMATICS.07 35022

###   PSAT 10 MATHEMATICS

PSATM <- math.prog$BACKWARD[['2018']]$MATHEMATICS_PSAT_10.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_PSAT_10.10" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
PSATM <- PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_PSAT_10.10" & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
table(PSATM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
PSATM[COUNT > 500]  #  Major progressions

###   Viable 1 Prior (Spring 17) Progressions
PSATM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT 25187
# 2:                    ALGEBRA_II.EOCT  2189
# 3:                      GEOMETRY.EOCT  7968
# 4:             INTEGRATED_MATH_1.EOCT  7390
# 5:             INTEGRATED_MATH_2.EOCT  1410
# 6:             INTEGRATED_MATH_3.EOCT   185
# 7:                     MATHEMATICS.08    14
# 8:                 MATHEMATICS_SAT.11    12


###   Viable 2 Prior (Spring 17 + Spring 16) ALGEBRA_I Progressions
PSATM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 1500]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT                     MATHEMATICS.08 20517
# 2:                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT  4952
# 3:                      GEOMETRY.EOCT                     MATHEMATICS.08  1727
# 4:             INTEGRATED_MATH_1.EOCT                     MATHEMATICS.08  6540

###
###   SAT MATHEMATICS
###

SATM <- math.prog$BACKWARD[['2018']]$MATHEMATICS_SAT.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_SAT.11" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks
SATM <- SATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_SAT.11" & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
table(SATM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
SATM[COUNT > 500]  #  Major progressions

###   Viable 1 Prior (Spring 17) Progressions
SATM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT   114
# 2:                    ALGEBRA_II.EOCT     4
# 3:                      GEOMETRY.EOCT    26
# 4:             INTEGRATED_MATH_1.EOCT    16
# 5:                     MATHEMATICS.08     1
# 6:             MATHEMATICS_PSAT_10.10 51883

###   Viable 2 Prior (Spring 17 + Spring 16) Progressions
SATM[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 1500]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:             MATHEMATICS_PSAT_10.10                     ALGEBRA_I.EOCT 21085
# 2:             MATHEMATICS_PSAT_10.10                    ALGEBRA_II.EOCT  2186
# 3:             MATHEMATICS_PSAT_10.10                      GEOMETRY.EOCT  7614
# 4:             MATHEMATICS_PSAT_10.10             INTEGRATED_MATH_1.EOCT  5965


####
####     ELA
####

###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2018']])

sum(ela.prog$BACKWARD[['2018']]$ELA_PSAT_9.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #  50,794
sum(ela.prog$BACKWARD[['2018']]$ELA_PSAT_9.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1!="ELA.08"]$COUNT)   #     732
sum(ela.prog$BACKWARD[['2018']]$ELA_PSAT_9.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.07"]$COUNT)   #  46398
sum(ela.prog$BACKWARD[['2018']]$ELA_PSAT_10.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #  44448
sum(ela.prog$BACKWARD[['2018']]$ELA_PSAT_10.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1!="ELA.09"]$COUNT)   #    268
sum(ela.prog$BACKWARD[['2018']]$ELA_PSAT_10.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.08"]$COUNT)  #  38746
sum(ela.prog$BACKWARD[['2018']]$ELA_SAT.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA_PSAT_10.10"]$COUNT)   #  51882
sum(ela.prog$BACKWARD[['2018']]$ELA_SAT.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1!="ELA_PSAT_10.10"]$COUNT)   #    298
sum(ela.prog$BACKWARD[['2018']]$ELA_SAT.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA_PSAT_10.10" & CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09"]$COUNT) # 38290
