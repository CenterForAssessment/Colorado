#+ include = FALSE, purl = FALSE, eval = FALSE
###############################################################################
###                                                                         ###
###           Prep CMAS/PSAT/SAT data for 2025 Colorado LONG data           ###
###                                                                         ###
###############################################################################

#' ## Data Preparation
#'
#' The data preparation step involves taking data provided by the CDE and
#' producing a `.Rdata` file that will subsequently be analyzed using the `SGP`
#' software. This process is carried out annually as new data becomes available
#' from the Colorado `r params$test.abv` assessment program.
#'
#' The data received from CDE is pre-processed and requires minimal formatting
#' prior to running SGP analyses. For the `r params$report.year` `r params$test.abv`
#' data preparation and cleaning, we ensure that all data fields have been read
#' in as the correct type (e.g., scale scores are `numeric` values) and format
#' demographic and student information to match values used in the historical
#' data set. All variable names were confirmed to conform to the `SGP` required
#' package conventions.
#'
#' Invalid records were identified based on the following criteria:
#'
#' * Students with duplicate records. In these instances, a student's highest
#'   scale score is retained as the "valid" case in the analyses.
#' * Cases with missing student identifiers.
#' * Cases with missing scale scores.


#+ include = FALSE, purl = FALSE, eval = FALSE
### Load Packages
require(data.table)

###############################################################################
###                                  CMAS                                   ###
###############################################################################

Colorado_CMAS_Data_2025 <-
    fread(
        file = "Data/Base_Files/CMAS_GRO_READIN_2025_20250616.txt",
        colClasses = rep("character", 26), quote = "'"
    )

###   Tidy up CMAS Data

##    Rename YR
setnames(Colorado_CMAS_Data_2025, "YR", "YEAR")

##    Re-label CONTENT_AREA values
Colorado_CMAS_Data_2025[, CONTENT_AREA := factor(CONTENT_AREA)]
setattr(
    Colorado_CMAS_Data_2025$CONTENT_AREA, "levels",
    c("ELA", "MATHEMATICS", "SLA")
)
Colorado_CMAS_Data_2025[, CONTENT_AREA := as.character(CONTENT_AREA)]

##    Convert SCALE_SCORE variable to numeric
Colorado_CMAS_Data_2025[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

##    Convert names to factors (temporary to change levels vs values)
Colorado_CMAS_Data_2025[,
    DISTRICT_NAME := factor(DISTRICT_NAME)
][, SCHOOL_NAME := factor(SCHOOL_NAME)
][, FIRST_NAME := factor(FIRST_NAME)
][, LAST_NAME := factor(LAST_NAME)
]

##    Clean up LAST_NAME and FIRST_NAME
setattr(
    Colorado_CMAS_Data_2025$LAST_NAME, "levels",
    sapply(
        levels(Colorado_CMAS_Data_2025$LAST_NAME),
        SGP::capwords
    )
)
setattr(
    Colorado_CMAS_Data_2025$FIRST_NAME, "levels",
    sapply(
        levels(Colorado_CMAS_Data_2025$FIRST_NAME),
        SGP::capwords
    )
)

##    Clean up SCHOOL_NAME and DISTRICT_NAME
new.sch.levs <- levels(Colorado_CMAS_Data_2025$SCHOOL_NAME)
new.dst.levs <- levels(Colorado_CMAS_Data_2025$DISTRICT_NAME)

source("../../Github_Repos/Projects/Colorado/Colorado_School_District_Name_Formatting.R")

setattr(Colorado_CMAS_Data_2025$SCHOOL_NAME, "levels", new.sch.levs)
setattr(Colorado_CMAS_Data_2025$DISTRICT_NAME, "levels", new.dst.levs)

###   Resolve duplicates
setkey(Colorado_CMAS_Data_2025,
       VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Colorado_CMAS_Data_2025,
       VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
dup.index <-
    Colorado_CMAS_Data_2025 |>
      duplicated(by = key(Colorado_CMAS_Data_2025)) |> which()
dups <-
    Colorado_CMAS_Data_2025[unique(c(dup.index - 1, dup.index)), ] |>
      data.table(key = key(Colorado_CMAS_Data_2025))
table(dups$VALID_CASE) # 0 duplicates in 2025
# Colorado_CMAS_Data_2025[dup.index, VALID_CASE := "INVALID_CASE"]

##  Missing cases in 2025
outside.grades <- c("1", "2", "9", "10", "11")
round(prop.table(table(
    Colorado_CMAS_Data_2025[
        CONTENT_AREA != "SLA" & !GRADE %in% outside.grades,
        .(is.na(SCALE_SCORE), CONTENT_AREA), GRADE
    ]), 1) * 100, 1)

Colorado_CMAS_Data_2025 <-
    Colorado_CMAS_Data_2025[
        CONTENT_AREA != "SLA" &
        !GRADE %in% outside.grades
    ]

###  Save 2025 CMAS Data
save(Colorado_CMAS_Data_2025, file = "Data/Colorado_CMAS_Data_2025.Rdata")


###############################################################################
###                                PSAT/SAT                                 ###
###############################################################################

Colorado_PSAT_Data_2025 <-
    fread(
        file = "Data/Base_Files/SAT_GRO_READIN_2025_20250616.txt",
        colClasses = rep("character", 26), quote = "'"
    )

Colorado_PSAT_Data_2025[,
    EDW_DATA_SOURCE := NULL
][, VENDOR_STUDENT_ID := NULL
]

##   Rename YR
setnames(Colorado_PSAT_Data_2025, "YR", "YEAR")

Colorado_PSAT_Data_2025[,
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
Colorado_PSAT_Data_2025[, SCALE_SCORE := as.numeric(SCALE_SCORE)]

##    Convert names to factors (temporary to change levels vs values)
Colorado_PSAT_Data_2025[,
    DISTRICT_NAME := factor(DISTRICT_NAME)
][, SCHOOL_NAME := factor(SCHOOL_NAME)
][, FIRST_NAME := factor(FIRST_NAME)
][, LAST_NAME := factor(LAST_NAME)
]

##    Clean up LAST_NAME and FIRST_NAME
setattr(
    Colorado_PSAT_Data_2025$LAST_NAME, "levels",
    sapply(
        levels(Colorado_PSAT_Data_2025$LAST_NAME),
        SGP::capwords
    )
)
setattr(
    Colorado_PSAT_Data_2025$FIRST_NAME, "levels",
    sapply(
        levels(Colorado_PSAT_Data_2025$FIRST_NAME),
        SGP::capwords
    )
)

##    Clean up SCHOOL_NAME and DISTRICT_NAME
new.sch.levs <- toupper(levels(Colorado_PSAT_Data_2025$SCHOOL_NAME))
new.dst.levs <- toupper(levels(Colorado_PSAT_Data_2025$DISTRICT_NAME))

source("../../Github_Repos/Projects/Colorado/Colorado_School_District_Name_Formatting.R")

setattr(Colorado_PSAT_Data_2025$SCHOOL_NAME, "levels", new.sch.levs)
setattr(Colorado_PSAT_Data_2025$DISTRICT_NAME, "levels", new.dst.levs)

##    Establish ACHIEVEMENT_LEVEL for PSAT/SAT
Colorado_PSAT_Data_2025 <-
  SGP:::getAchievementLevel(Colorado_PSAT_Data_2025, state = "CO")
Colorado_PSAT_Data_2025[
    ACHIEVEMENT_LEVEL == "NA", ACHIEVEMENT_LEVEL := "No Score"
]
table(Colorado_PSAT_Data_2025[, ACHIEVEMENT_LEVEL, VALID_CASE])

###   Resolve duplicates
setkey(Colorado_PSAT_Data_2025,
       VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Colorado_PSAT_Data_2025,
       VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
dup.index <- which(duplicated(Colorado_PSAT_Data_2025,
                              by = key(Colorado_PSAT_Data_2025)))
dups <- data.table(Colorado_PSAT_Data_2025[
                     unique(c(dup.index - 1, dup.index)), ],
                   key = key(Colorado_PSAT_Data_2025))
table(dups$VALID_CASE) # 0 (valid) duplicates in 2025
# Colorado_PSAT_Data_2025[dup.index, VALID_CASE := "INVALID_CASE"]


###   Save 2025 PSAT_SAT Data
save(Colorado_PSAT_Data_2025, file="Data/Colorado_PSAT_Data_2025.Rdata")
