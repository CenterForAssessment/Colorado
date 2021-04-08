################################################################################
###                                                                          ###
###             Identify 2019 Progressions for Colorado PSAT/SAT             ###
###                                                                          ###
################################################################################

library(SGP)
library(data.table)

###  Load Data
load("Data/Colorado_SGP.Rdata") # Already has 2019 CMAS data
load("Data/Colorado_Data_LONG_PSAT_SAT_2019.Rdata")

Colorado_Data_LONG <- rbindlist(list(Colorado_SGP@Data, Colorado_Data_LONG_PSAT_SAT_2019), fill=TRUE)

content.areas <- names(table(Colorado_Data_LONG[, CONTENT_AREA]))

##  Remove _SS tag to make things easier/legible
Colorado_Data_LONG[, CONTENT_AREA := gsub("_SS", "", CONTENT_AREA)]

ela.prog <- courseProgressionSGP(Colorado_Data_LONG[CONTENT_AREA %in% grep("ELA", content.areas, value=T)], lag.direction="BACKWARD", year='2019')
math.prog<- courseProgressionSGP(Colorado_Data_LONG[!CONTENT_AREA %in% grep("ELA", content.areas, value=T)], lag.direction="BACKWARD", year='2019')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the Spring 17 data
names(math.prog$BACKWARD[['2019']])

###
###   MATHEMATICS_PSAT_9
###

MPSAT9 <- math.prog$BACKWARD[['2019']]$MATHEMATICS_PSAT_9.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_PSAT_9.09"]
MPSAT9 <- MPSAT9[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "MATHEMATICS_PSAT_9.09"]
table(MPSAT9$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
MPSAT9[COUNT > 1000]  #  Major progressions

###   Viable 1 Prior MATHEMATICS_PSAT_9 Progressions ( > 1000 kids)
MPSAT9[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)][Total > 1000]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     ALGEBRA_I.EOCT  6087
# 2:                      GEOMETRY.EOCT  1476
# 3:                     MATHEMATICS.08 39979


###   Viable 2 Prior MATHEMATICS_PSAT_9 Progressions ( > 1000 kids)
MPSAT9[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 1000]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                     ALGEBRA_I.EOCT                     MATHEMATICS.07  5945
# 2:                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT  1402
# 3:                     MATHEMATICS.08                     MATHEMATICS.07 39256

###   Viable 3 Prior MATHEMATICS_PSAT_9 Progressions ( > 1000 kids)
MPSAT9[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.3), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 1000]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 Total
# 1:                     ALGEBRA_I.EOCT                     MATHEMATICS.07                     MATHEMATICS.06  5574
# 2:                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT                     MATHEMATICS.06  1342
# 3:                     MATHEMATICS.08                     MATHEMATICS.07                     MATHEMATICS.06 36521

###
###   MATHEMATICS_PSAT_10 (No Repeaters)
###

MPSAT10 <- math.prog$BACKWARD[['2019']]$MATHEMATICS_PSAT_10.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_PSAT_10.10"]
MPSAT10 <- MPSAT10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "MATHEMATICS_PSAT_10.10"]
table(MPSAT10$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
MPSAT10[COUNT > 1000]  #  Major progressions

###   Viable 1 Prior MATHEMATICS_PSAT_10 Progressions ( > 1000 kids)
MPSAT10[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                     MATHEMATICS.08     7
# 2:              MATHEMATICS_PSAT_9.09 46154
# 3:                 MATHEMATICS_SAT.11     1

###  0 kids with Algebra I or Geometry Priors in 2019
MPSAT10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT"] # 0
MPSAT10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.EOCT"] # 0

###   Viable 2 Prior MATHEMATICS_PSAT_10 Progressions ( > 1000 kids)
MPSAT10[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 50]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:              MATHEMATICS_PSAT_9.09                     ALGEBRA_I.EOCT  8304
# 2:              MATHEMATICS_PSAT_9.09                      GEOMETRY.EOCT  2121
# 3:              MATHEMATICS_PSAT_9.09             INTEGRATED_MATH_1.EOCT  1311
# 4:              MATHEMATICS_PSAT_9.09             INTEGRATED_MATH_2.EOCT   141
# 5:              MATHEMATICS_PSAT_9.09                     MATHEMATICS.08 34238

###   Viable 3 Prior MATHEMATICS_PSAT_10 Progressions ( > 1000 kids)
MPSAT10[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.3), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 1000]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 Total
# 1:              MATHEMATICS_PSAT_9.09                     ALGEBRA_I.EOCT                     MATHEMATICS.07  7403
# 2:              MATHEMATICS_PSAT_9.09                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT  1754
# 3:              MATHEMATICS_PSAT_9.09             INTEGRATED_MATH_1.EOCT                     MATHEMATICS.07  1192
# 4:              MATHEMATICS_PSAT_9.09                     MATHEMATICS.08                     MATHEMATICS.07 31389


###
###   MATHEMATICS_SAT (No Repeaters)
###

MSAT <- math.prog$BACKWARD[['2019']]$MATHEMATICS_SAT.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "MATHEMATICS_SAT.11"] #  Keep NA's for Fall to Fall checks
MSAT <- MSAT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "MATHEMATICS_SAT.11"]

MSAT[COUNT > 1000]  #  Major progressions

###   Viable 1 Prior MATHEMATICS_SAT Progressions ( > 1000 kids)
MSAT[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)][Total > 1000]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:             MATHEMATICS_PSAT_10.10 40124

###   Viable 2 Prior MATHEMATICS_SAT Progressions ( > 1000 kids)
MSAT[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 1000]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2  Total
# 1:             MATHEMATICS_PSAT_10.10                     ALGEBRA_I.EOCT  22376
# 2:             MATHEMATICS_PSAT_10.10                    ALGEBRA_II.EOCT   2088
# 3:             MATHEMATICS_PSAT_10.10                      GEOMETRY.EOCT   7553
# 4:             MATHEMATICS_PSAT_10.10             INTEGRATED_MATH_1.EOCT   6491
# 5:             MATHEMATICS_PSAT_10.10             INTEGRATED_MATH_2.EOCT   1343  XXX

###   Viable 3 Prior MATHEMATICS_SAT Progressions ( > 1000 kids)
MSAT[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.3), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.3")][Total > 1000]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 CONTENT_AREA_by_GRADE_PRIOR_YEAR.3 Total
# 1:             MATHEMATICS_PSAT_10.10                     ALGEBRA_I.EOCT                     ALGEBRA_I.EOCT  1083  XXX
# 2:             MATHEMATICS_PSAT_10.10                     ALGEBRA_I.EOCT                     MATHEMATICS.08 18404
# 3:             MATHEMATICS_PSAT_10.10                    ALGEBRA_II.EOCT                      GEOMETRY.EOCT  1415  XXX
# 4:             MATHEMATICS_PSAT_10.10                      GEOMETRY.EOCT                     ALGEBRA_I.EOCT  4743
# 5:             MATHEMATICS_PSAT_10.10                      GEOMETRY.EOCT                     MATHEMATICS.08  1618  XXX
# 6:             MATHEMATICS_PSAT_10.10             INTEGRATED_MATH_1.EOCT                     MATHEMATICS.08  5784

####
####     ELA
####

###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2019']])

###
###   ELA_PSAT_9
###

EPSAT9 <- ela.prog$BACKWARD[['2019']]$ELA_PSAT_9.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ELA_PSAT_9.09"]
EPSAT9 <- EPSAT9[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "ELA_PSAT_9.09"]
table(EPSAT9$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
EPSAT9[COUNT > 1000]  #  Major progressions

###   Viable 1 Prior ELA_PSAT_9 Progressions
EPSAT9[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                             ELA.07    38
# 2:                             ELA.08 48264
# 3:                     ELA_PSAT_10.10     6
# 4:                         ELA_SAT.11     3


###   Viable 2 Prior ELA_PSAT_9 Progressions
EPSAT9[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 100]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                             ELA.08                             ELA.07 4818


###
###   ELA_PSAT_10 (No Repeaters)
###

EPSAT10 <- ela.prog$BACKWARD[['2019']]$ELA_PSAT_10.10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ELA_PSAT_10.10"]
EPSAT10 <- EPSAT10[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "ELA_PSAT_10.10"]
table(EPSAT10$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
EPSAT10[COUNT > 1000]  #  Major progressions

###   Viable 1 Prior ELA_PSAT_10 Progressions
EPSAT10[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                             ELA.08     7
# 2:                      ELA_PSAT_9.09 46172
# 3:                         ELA_SAT.11     2

###   Viable 2 Prior ELA_PSAT_10 Progressions
EPSAT10[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 50]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 Total
# 1:                      ELA_PSAT_9.09                             ELA.08 45982
# 2:                      ELA_PSAT_9.09                             ELA.09   147

###
###   ELA_SAT (No Repeaters)
###

ESAT <- ela.prog$BACKWARD[['2019']]$ELA_SAT.11[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ELA_SAT.11"]
ESAT <- ESAT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2 != "ELA_SAT.11"]

ESAT[COUNT > 1000]  #  Major progressions

###   Viable 1 Prior ELA_SAT Progressions
ESAT[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
# CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 Total
# 1:                             ELA.08     1
# 2:                     ELA_PSAT_10.10 40228
# 3:                      ELA_PSAT_9.09   118

###   Viable 2 Prior ELA_SAT Progressions
ESAT[!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1) & !is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.2), list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1", "CONTENT_AREA_by_GRADE_PRIOR_YEAR.2")][Total > 50]
#    CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 CONTENT_AREA_by_GRADE_PRIOR_YEAR.2  Total
# 1:                     ELA_PSAT_10.10                             ELA.09 40133
# 2:                     ELA_PSAT_10.10                     ELA_PSAT_10.10    89
# 3:                      ELA_PSAT_9.09                             ELA.09    92
