###############################################################################
###                                                                         ###
###           Prep CMAS/PSAT/SAT data for 2023 Colorado LONG data           ###
###                                                                         ###
###############################################################################

### Load Packages
require(data.table)

###############################################################################
###                                  CMAS                                   ###
###############################################################################

Colorado_CMAS_Data_2023 <-
    fread(
        file = "Data/Base_Files/CMAS_GRO_READIN_2023_20230630.txt",
        colClasses = rep("character", 26), quote = "'"
    )

###   Tidy up CMAS Data

##    Rename YR
setnames(Colorado_CMAS_Data_2023, "YR", "YEAR")

##    Re-lable CONTENT_AREA values
Colorado_CMAS_Data_2023[, CONTENT_AREA := factor(CONTENT_AREA)]
setattr(
    Colorado_CMAS_Data_2023$CONTENT_AREA, "levels",
    c("ELA", "MATHEMATICS", "SLA")
)
Colorado_CMAS_Data_2023[, CONTENT_AREA := as.character(CONTENT_AREA)]

##    Convert SCALE_SCORE variable to numeric
Colorado_CMAS_Data_2023[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

##    Convert names to factors (temporary to change levels vs values)
Colorado_CMAS_Data_2023[,
    DISTRICT_NAME := factor(DISTRICT_NAME)
][, SCHOOL_NAME := factor(SCHOOL_NAME)
][, FIRST_NAME := factor(FIRST_NAME)
][, LAST_NAME := factor(LAST_NAME)
]

##    Clean up LAST_NAME and FIRST_NAME
setattr(
    Colorado_CMAS_Data_2023$LAST_NAME, "levels",
    sapply(
        levels(Colorado_CMAS_Data_2023$LAST_NAME),
        SGP::capwords
    )
)
setattr(
    Colorado_CMAS_Data_2023$FIRST_NAME, "levels",
    sapply(
        levels(Colorado_CMAS_Data_2023$FIRST_NAME),
        SGP::capwords
    )
)

##    Clean up SCHOOL_NAME and DISTRICT_NAME

new.sch.levs <- levels(Colorado_CMAS_Data_2023$SCHOOL_NAME)
new.dst.levs <- levels(Colorado_CMAS_Data_2023$DISTRICT_NAME)
# grep("J", new.dst.levs, value = TRUE)

# source("Colorado_School_District_Name_Formating.R")
source("/home/avi/Sync/Center/Github_Repos/Projects/Colorado/Colorado_School_District_Name_Formating.R")

setattr(Colorado_CMAS_Data_2023$SCHOOL_NAME, "levels", new.sch.levs)
setattr(Colorado_CMAS_Data_2023$DISTRICT_NAME, "levels", new.dst.levs)

###   Resolve duplicates
setkey(Colorado_CMAS_Data_2023,
       VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Colorado_CMAS_Data_2023,
       VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
dup.index <- which(duplicated(Colorado_CMAS_Data_2023,
                              by = key(Colorado_CMAS_Data_2023)))
dups <- data.table(Colorado_CMAS_Data_2023[
                     unique(c(dup.index - 1, dup.index)), ],
                   key = key(Colorado_CMAS_Data_2023))
table(dups$VALID_CASE) # 0 duplicates in 2023
# Colorado_CMAS_Data_2023[dup.index, VALID_CASE := "INVALID_CASE"]

##  Missing cases in 2023
round(prop.table(table(
    Colorado_CMAS_Data_2023[CONTENT_AREA != "SLA" & GRADE != "2",
     .(is.na(SCALE_SCORE), CONTENT_AREA), GRADE]), 1) * 100, 1)

Colorado_CMAS_Data_2023 <-
    Colorado_CMAS_Data_2023[
        CONTENT_AREA != "SLA" &
        !GRADE %in% c("1", "2", "10")
    ]

###  Save 2023 CMAS Data
save(Colorado_CMAS_Data_2023, file = "Data/Colorado_CMAS_Data_2023.Rdata")


###############################################################################
###                                PSAT/SAT                                 ###
###############################################################################

Colorado_PSAT_Data_2023 <-
    fread(
        file = "Data/Base_Files/SAT_GRO_READIN_2023_20230717.txt",
        colClasses = rep("character", 26), quote = "'"
    )

Colorado_PSAT_Data_2023[,
    EDW_DATA_SOURCE := NULL
][, VENDOR_STUDENT_ID := NULL
]

##   Rename YR
setnames(Colorado_PSAT_Data_2023, "YR", "YEAR")

Colorado_PSAT_Data_2023[,
    CONTENT_AREA :=
        fcase(
            CONTENT_AREA == "ELA" & GRADE == 9,  "ELA_PSAT_9",
            CONTENT_AREA == "ELA" & GRADE == 10, "ELA_PSAT_10",
            CONTENT_AREA == "ELA" & GRADE == 11, "ELA_SAT",
            CONTENT_AREA == "MAT" & GRADE == 9,  "MATHEMATICS_PSAT_9",
            CONTENT_AREA == "MAT" & GRADE == 10, "MATHEMATICS_PSAT_10",
            CONTENT_AREA == "MAT" & GRADE == 11, "MATHEMATICS_SAT"
        )
]

##   Convert SCALE_SCORE variable to numeric
Colorado_PSAT_Data_2023[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

##    Convert names to factors (temporary to change levels vs values)
Colorado_PSAT_Data_2023[,
    DISTRICT_NAME := factor(DISTRICT_NAME)
][, SCHOOL_NAME := factor(SCHOOL_NAME)
][, FIRST_NAME := factor(FIRST_NAME)
][, LAST_NAME := factor(LAST_NAME)
]

##    Clean up LAST_NAME and FIRST_NAME
setattr(
    Colorado_PSAT_Data_2023$LAST_NAME, "levels",
    sapply(
        levels(Colorado_PSAT_Data_2023$LAST_NAME),
        SGP::capwords
    )
)
setattr(
    Colorado_PSAT_Data_2023$FIRST_NAME, "levels",
    sapply(
        levels(Colorado_PSAT_Data_2023$FIRST_NAME),
        SGP::capwords
    )
)

##    Clean up SCHOOL_NAME and DISTRICT_NAME
new.sch.levs <- toupper(levels(Colorado_PSAT_Data_2023$SCHOOL_NAME))
new.dst.levs <- toupper(levels(Colorado_PSAT_Data_2023$DISTRICT_NAME))
# grep("J", new.dst.levs, value = TRUE)

# source("Colorado_School_District_Name_Formating.R")
source("/home/avi/Sync/Center/Github_Repos/Projects/Colorado/Colorado_School_District_Name_Formating.R")
setattr(Colorado_PSAT_Data_2023$SCHOOL_NAME, "levels", new.sch.levs)
setattr(Colorado_PSAT_Data_2023$DISTRICT_NAME, "levels", new.dst.levs)

##    Establish ACHIEVEMENT_LEVEL for PSAT/SAT
Colorado_PSAT_Data_2023 <-
  SGP:::getAchievementLevel(Colorado_PSAT_Data_2023, state = "CO")
Colorado_PSAT_Data_2023[
    ACHIEVEMENT_LEVEL == "NA", ACHIEVEMENT_LEVEL := "No Score"
]
table(Colorado_PSAT_Data_2023[, ACHIEVEMENT_LEVEL, VALID_CASE])

###   Resolve duplicates
setkey(Colorado_PSAT_Data_2023,
       VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Colorado_PSAT_Data_2023,
       VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
dup.index <- which(duplicated(Colorado_PSAT_Data_2023,
                              by = key(Colorado_PSAT_Data_2023)))
dups <- data.table(Colorado_PSAT_Data_2023[
                     unique(c(dup.index - 1, dup.index)), ],
                   key = key(Colorado_PSAT_Data_2023))
table(dups$VALID_CASE) # 0 (valid) duplicates in 2023
# Colorado_PSAT_Data_2023[dup.index, VALID_CASE := "INVALID_CASE"]


###   Save 2023 PSAT_SAT Data
save(Colorado_PSAT_Data_2023, file="Data/Colorado_PSAT_Data_2023.Rdata")

###   Combine CMAS and P/SAT data objects and save
# Colorado_Data_LONG_2023 <-
#     rbindlist(
#         list(
#             Colorado_CMAS_Data_2023,
#             Colorado_PSAT_Data_2023
#         ),
#         fill = TRUE
#     )

# setkey(Colorado_Data_LONG_2023, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
# save(Colorado_Data_LONG_2023, file = "Data/Colorado_Data_LONG_2023.Rdata")
