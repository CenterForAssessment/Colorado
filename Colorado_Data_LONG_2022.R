###############################################################################
###                                                                         ###
###           Prep CMAS/PSAT/SAT data for 2022 Colorado LONG data           ###
###                                                                         ###
###############################################################################

### Load Packages
require(data.table)

##################################################
###                    CMAS                    ###
##################################################

Colorado_CMAS_Data_2022 <-
  fread(file = "Data/Base_Files/CMAS_readin_2022.txt",
        colClasses = rep("character", 26), quote = "'")

###   Tidy up CMAS Data

#   Rename YR
setnames(Colorado_CMAS_Data_2022, "YR", "YEAR")

#   Re-lable CONTENT_AREA values
Colorado_CMAS_Data_2022[, CONTENT_AREA := factor(CONTENT_AREA)]
setattr(Colorado_CMAS_Data_2022$CONTENT_AREA, "levels",
        c("ELA", "MATHEMATICS", "SLA"))
Colorado_CMAS_Data_2022[, CONTENT_AREA := as.character(CONTENT_AREA)]

#   Convert SCALE_SCORE variable to numeric
Colorado_CMAS_Data_2022[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

#   Convert names to factors (temporary to change levels vs values)
Colorado_CMAS_Data_2022[, DISTRICT_NAME := factor(DISTRICT_NAME)]
Colorado_CMAS_Data_2022[, SCHOOL_NAME := factor(SCHOOL_NAME)]
Colorado_CMAS_Data_2022[, FIRST_NAME := factor(FIRST_NAME)]
Colorado_CMAS_Data_2022[, LAST_NAME := factor(LAST_NAME)]

#   Clean up LAST_NAME and FIRST_NAME
setattr(Colorado_CMAS_Data_2022$LAST_NAME, "levels",
        sapply(levels(Colorado_CMAS_Data_2022$LAST_NAME), SGP::capwords))
setattr(Colorado_CMAS_Data_2022$FIRST_NAME, "levels",
       sapply(levels(Colorado_CMAS_Data_2022$FIRST_NAME), SGP::capwords))

####
#   Clean up SCHOOL_NAME and DISTRICT_NAME
#   Check levels first to confirm special.words - Clean Well for ISRs
####

###  Schools
new.sch.levs <- levels(Colorado_CMAS_Data_2022$SCHOOL_NAME)
new.sch.levs <- gsub("/", " / ", new.sch.levs)

sch.specials <- c("AIM", "APS", "AXIS", "AXL", "CCH", "CEC", "CMS", "COVA",
                  "CUBE", "DC", "DCIS", "DSST", "DSST:", "ECE-8", "GES",
                  "GOAL", "GVR", "IB", "KIPP", "PK", "PK-8", "PK-12", "PSD",
                  "LEAP", "MHCD", "MS", "SHS", "STEM", "TCA", "VSSA")

new.sch.levs <- sapply(X = new.sch.levs, USE.NAMES = FALSE,
                       FUN = SGP::capwords, special.words = sch.specials)

new.sch.levs <- gsub(" / ", "/", new.sch.levs)
new.sch.levs <- gsub("''", "'", new.sch.levs)
new.sch.levs <- gsub("[']S", "'s", new.sch.levs)
new.sch.levs <- gsub("Prek", "PreK", new.sch.levs)
new.sch.levs <- gsub("Pk-8", "PK-8", new.sch.levs)

sort(grep("Mc", new.sch.levs, value = TRUE))
new.sch.levs <- gsub("Mc Auliffe", "McAuliffe", new.sch.levs)
new.sch.levs <- gsub("Mcauliffe", "McAuliffe", new.sch.levs)
new.sch.levs <- gsub("Mc Clave", "McClave", new.sch.levs)
new.sch.levs <- gsub("Mcclave", "McClave", new.sch.levs)
new.sch.levs <- gsub("Mc Elwain", "McElwain", new.sch.levs)
new.sch.levs <- gsub("Mcelwain", "McElwain", new.sch.levs)
new.sch.levs <- gsub("Mc Ginnis", "McGinnis", new.sch.levs)
new.sch.levs <- gsub("Mcginnis", "McGinnis", new.sch.levs)
new.sch.levs <- gsub("Mc Glone", "McGlone", new.sch.levs)
new.sch.levs <- gsub("Mcglone", "McGlone", new.sch.levs)
new.sch.levs <- gsub("Mc Graw", "McGraw", new.sch.levs)
new.sch.levs <- gsub("Mcgraw", "McGraw", new.sch.levs)
new.sch.levs <- gsub("Mc Kinley", "McKinley", new.sch.levs)
new.sch.levs <- gsub("Mckinley", "McKinley", new.sch.levs)
new.sch.levs <- gsub("Mc Lain", "McLain", new.sch.levs)
new.sch.levs <- gsub("Mclain", "McLain", new.sch.levs)
new.sch.levs <- gsub("Mc Meen", "McMeen", new.sch.levs)
new.sch.levs <- gsub("Mcmeen", "McMeen", new.sch.levs)

new.sch.levs <- gsub("Ace Community", "ACE Community", new.sch.levs)
new.sch.levs <- gsub("Achieve Online", "ACHIEVE Online", new.sch.levs)
new.sch.levs <- gsub("Allies", "ALLIES", new.sch.levs)
new.sch.levs <- gsub("Apex Home", "APEX Home", new.sch.levs)
# new.sch.levs <- gsub("Canon", "Ca\u{F1}on", new.sch.levs)
new.sch.levs <- gsub("Hope Online", "HOPE Online", new.sch.levs)
new.sch.levs <- gsub("Reach Charter", "REACH Charter", new.sch.levs)
new.sch.levs <- gsub("Soar A", "SOAR A", new.sch.levs)
new.sch.levs <- gsub("Strive Prep", "STRIVE Prep", new.sch.levs)
new.sch.levs <- gsub("Edcsd", "eDCSD", new.sch.levs)

grep("[[:digit:]]", new.sch.levs, value = TRUE)
grep("[[:digit:]]j", new.sch.levs, value = TRUE)
new.sch.levs <- gsub("27j", "27J", new.sch.levs)
new.sch.levs <- gsub("49jt", "49JT", new.sch.levs)

setattr(Colorado_CMAS_Data_2022$SCHOOL_NAME, "levels", new.sch.levs)

###  Districts
grep("J", levels(Colorado_CMAS_Data_2022$DISTRICT_NAME), value = TRUE)
new.dst.levs <- levels(Colorado_CMAS_Data_2022$DISTRICT_NAME)
new.dst.levs <- gsub("/", " / ", new.dst.levs)
new.dst.levs <- gsub("[-]", " - ", new.dst.levs)

dst.specials <- c("1J", "2J", "3J", "4A", "4J", "5J", "6J", "10J", "10JT",
                  "11J", "13JT", "22J", "26J", "27J", "28J", "29J", "31J",
                  "32J", "33J", "49JT", "50J", "50JT", "60JT", "100J",
                  "JT", "RJ", "RD", "RE", "RE1J")

new.dst.levs <- sapply(X = new.dst.levs, USE.NAMES = FALSE,
                       FUN = SGP::capwords, special.words = dst.specials)
new.dst.levs <- gsub("[(]J[)]", "J", new.dst.levs)
new.dst.levs <- gsub("Re-", "RE-", new.dst.levs)
new.dst.levs <- gsub("RE [[:digit:]]", "RE-", new.dst.levs)
new.dst.levs <- gsub("RE-1-J", "RE-1J", new.dst.levs)
new.dst.levs <- gsub(" Jt", "JT", new.dst.levs)
new.dst.levs <- gsub(" JT", "-JT", new.dst.levs)
new.dst.levs <- gsub(" / ", "/", new.dst.levs)
new.dst.levs <- gsub(" - ", "-", new.dst.levs)
new.dst.levs <- gsub("Mc Clave", "McClave", new.dst.levs)
grep("j", new.dst.levs, value = TRUE) # Should only leave * Conejos

setattr(Colorado_CMAS_Data_2022$DISTRICT_NAME, "levels", new.dst.levs)

###   Resolve duplicates
# setkey(Colorado_CMAS_Data_2022,
#        VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
# setkey(Colorado_CMAS_Data_2022,
#        VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
# dup.index <- which(duplicated(Colorado_CMAS_Data_2022,
#                               by = key(Colorado_CMAS_Data_2022)))
# dups <- data.table(Colorado_CMAS_Data_2022[
#                      unique(c(dup.index - 1, dup.index)), ],
#                    key = key(Colorado_CMAS_Data_2022))
# table(dups$VALID_CASE) # 0 duplicates in 2022
# Colorado_CMAS_Data_2022[dup.index, VALID_CASE := "INVALID_CASE"]

##  Missing cases in 2022
round(prop.table(table(
    Colorado_CMAS_Data_2022[CONTENT_AREA != "SLA" & GRADE != "2",
     .(is.na(SCALE_SCORE), CONTENT_AREA), GRADE]), 1) * 100, 1)

Colorado_CMAS_Data_2022 <-
  Colorado_CMAS_Data_2022[CONTENT_AREA != "SLA" & GRADE != "2"]

##  Save 2022 Data - combine with P/SAT data and save as one file below
# assign("Colorado_Data_LONG_2022", Colorado_CMAS_Data_2022)
# rm(Colorado_CMAS_Data_2022)
# save(Colorado_Data_LONG_2022, file = "Data/Colorado_Data_LONG_2022.Rdata")


##################################################
###                  PSAT/SAT                  ###
##################################################

Colorado_PSAT_SAT_Data_2022 <-
  fread(file = "Data/Base_Files/SAT_Growth_Readin_2022.txt",
        colClasses = rep("character", 25), quote = "'")

Colorado_PSAT_SAT_Data_2022[, EDW_DATA_SOURCE := NULL]

#   Rename YR
setnames(Colorado_PSAT_SAT_Data_2022, "YR", "YEAR")

Colorado_PSAT_SAT_Data_2022[, CONTENT_AREA :=
    fcase(CONTENT_AREA == "ELA" & GRADE == 9, "ELA_PSAT_9",
          CONTENT_AREA == "ELA" & GRADE == 10, "ELA_PSAT_10",
          CONTENT_AREA == "ELA" & GRADE == 11, "ELA_SAT",
          CONTENT_AREA == "MAT" & GRADE == 9, "MATHEMATICS_PSAT_9",
          CONTENT_AREA == "MAT" & GRADE == 10, "MATHEMATICS_PSAT_10",
          CONTENT_AREA == "MAT" & GRADE == 11, "MATHEMATICS_SAT")]

#   Convert SCALE_SCORE variable to numeric
Colorado_PSAT_SAT_Data_2022[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

#   Convert names to factors (temporary to change levels vs values for time/memory saving)
Colorado_PSAT_SAT_Data_2022[, DISTRICT_NAME := factor(DISTRICT_NAME)]
Colorado_PSAT_SAT_Data_2022[, SCHOOL_NAME := factor(SCHOOL_NAME)]
Colorado_PSAT_SAT_Data_2022[, FIRST_NAME := factor(FIRST_NAME)]
Colorado_PSAT_SAT_Data_2022[, LAST_NAME := factor(LAST_NAME)]

#   Clean up LAST_NAME and FIRST_NAME
setattr(Colorado_PSAT_SAT_Data_2022$LAST_NAME, "levels",
       sapply(levels(Colorado_PSAT_SAT_Data_2022$LAST_NAME), SGP::capwords))
setattr(Colorado_PSAT_SAT_Data_2022$FIRST_NAME, "levels",
        sapply(levels(Colorado_PSAT_SAT_Data_2022$FIRST_NAME), SGP::capwords))

#   Clean up SCHOOL_NAME and DISTRICT_NAME
new.sch.levs <- toupper(levels(Colorado_PSAT_SAT_Data_2022$SCHOOL_NAME))
new.sch.levs <- gsub("/", " / ", new.sch.levs)

sch.specials <- c("AIM", "APS", "AXIS", "AXL", "CCH", "CEC", "CMS", "COVA",
                  "CUBE", "DC", "DCIS", "DSST", "DSST:", "ECE-8", "GES",
                  "GOAL", "GVR", "IB", "KIPP", "PK", "PK-8", "PK-12", "PSD",
                  "LEAP", "MHCD", "MS", "SHS", "STEM", "TCA", "VSSA")

new.sch.levs <- sapply(X = new.sch.levs, USE.NAMES = FALSE,
                       FUN = SGP::capwords, special.words = sch.specials)

new.sch.levs <- gsub(" / ", "/", new.sch.levs)
new.sch.levs <- gsub("''", "'", new.sch.levs)
new.sch.levs <- gsub("Prek", "PreK", new.sch.levs)
new.sch.levs <- gsub("Pk-8", "PK-8", new.sch.levs)
new.sch.levs <- gsub("Mcauliffe", "McAuliffe", new.sch.levs)
new.sch.levs <- gsub("Mcglone", "McGlone", new.sch.levs)
new.sch.levs <- gsub("Mcgraw", "McGraw", new.sch.levs)
new.sch.levs <- gsub("Mckinley", "McKinley", new.sch.levs)
new.sch.levs <- gsub("Mcmeen", "McMeen", new.sch.levs)
new.sch.levs <- gsub("Mc Clave", "McClave", new.sch.levs)
new.sch.levs <- gsub("Mc Elwain", "McElwain", new.sch.levs)
new.sch.levs <- gsub("Mc Ginnis", "McGinnis", new.sch.levs)
new.sch.levs <- gsub("Achieve Online", "ACHIEVE Online", new.sch.levs)
setattr(Colorado_PSAT_SAT_Data_2022$SCHOOL_NAME, "levels", new.sch.levs)

###  Districts
grep("J", levels(Colorado_PSAT_SAT_Data_2022$DISTRICT_NAME), value = TRUE)
new.dst.levs <- toupper(levels(Colorado_PSAT_SAT_Data_2022$DISTRICT_NAME))
new.dst.levs <- gsub("/", " / ", new.dst.levs)
new.dst.levs <- gsub("[-]", " - ", new.dst.levs)

dst.specials <- c("1J", "2J", "3J", "4A", "4J", "5J", "6J", "10J", "10JT",
                  "11J", "13JT", "22J", "26J", "27J", "28J", "29J", "31J",
                  "32J", "33J", "49JT", "50J", "50JT", "60JT", "100J",
                  "JT", "RJ", "RD", "RE", "RE1J")

new.dst.levs <- sapply(X = new.dst.levs, USE.NAMES = FALSE,
                       FUN = SGP::capwords, special.words = dst.specials)
new.dst.levs <- gsub("[(]J[)]", "J", new.dst.levs)
new.dst.levs <- gsub("Re-", "RE-", new.dst.levs)
new.dst.levs <- gsub("RE [[:digit:]]", "RE-", new.dst.levs)
new.dst.levs <- gsub("RE-1-J", "RE-1J", new.dst.levs)
new.dst.levs <- gsub(" Jt", "JT", new.dst.levs)
new.dst.levs <- gsub(" JT", "-JT", new.dst.levs)
new.dst.levs <- gsub(" / ", "/", new.dst.levs)
new.dst.levs <- gsub(" - ", "-", new.dst.levs)
new.dst.levs <- gsub("Mc Clave", "McClave", new.dst.levs)
grep("j", new.dst.levs, value = TRUE) # Should only leave * Conejos

setattr(Colorado_PSAT_SAT_Data_2022$DISTRICT_NAME, "levels", new.dst.levs)

#  Establish ACHIEVEMENT_LEVEL for PSAT/SAT
Colorado_PSAT_SAT_Data_2022 <-
  SGP:::getAchievementLevel(Colorado_PSAT_SAT_Data_2022, state = "CO")
Colorado_PSAT_SAT_Data_2022[ACHIEVEMENT_LEVEL == "NA",
                            ACHIEVEMENT_LEVEL := "No Score"]
table(Colorado_PSAT_SAT_Data_2022[, ACHIEVEMENT_LEVEL, VALID_CASE])

###   Resolve duplicates
# setkey(Colorado_PSAT_SAT_Data_2022,
#        VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
# setkey(Colorado_PSAT_SAT_Data_2022,
#        VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
# dup.index <- which(duplicated(Colorado_PSAT_SAT_Data_2022,
#                               by = key(Colorado_PSAT_SAT_Data_2022)))
# dups <- data.table(Colorado_PSAT_SAT_Data_2022[
#                      unique(c(dup.index - 1, dup.index)), ],
#                    key = key(Colorado_PSAT_SAT_Data_2022))
# table(dups$VALID_CASE) # 0 duplicates in 2022
# Colorado_PSAT_SAT_Data_2022[dup.index, VALID_CASE := "INVALID_CASE"]

## Save 2022 PSAT_SAT Data
# save(Colorado_PSAT_SAT_Data_2022, file="Data/Colorado_PSAT_SAT_Data_2022.Rdata")


###   Combine CMAS and P/SAT data objects and save
Colorado_Data_LONG_2022 <-
  rbindlist(list(Colorado_CMAS_Data_2022,
                 Colorado_PSAT_SAT_Data_2022),
            fill = TRUE)

setkey(Colorado_Data_LONG_2022, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
save(Colorado_Data_LONG_2022, file = "Data/Colorado_Data_LONG_2022.Rdata")
