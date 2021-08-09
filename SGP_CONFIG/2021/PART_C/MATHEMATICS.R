#####
###   Configurations for calculating LAGGED PROJECTIONS in 2021
#####


MATHEMATICS_2021.config <- list(
     # MATHEMATICS.2021 = list(  ##  Non-existent
     #     sgp.content.areas=c("MATHEMATICS", "MATHEMATICS"),
     #     sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS"),
     #     sgp.panel.years=c("2019", "2021"),
     #     sgp.baseline.panel.years=c("2019", "2021"),
     #     sgp.grade.sequences=list(c("3", "5")),
     #     sgp.baseline.grade.sequences=list(c("3", "5")),
     #     sgp.projection.sequence="MATHEMATICS_GRADE_5"),
     MATHEMATICS.2021 = list(
         sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
         sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
         sgp.baseline.panel.years=c("2018", "2019", "2021"),
         sgp.panel.years=c("2018", "2019", "2021"),
         sgp.grade.sequences=list(c("3", "4", "6")),
         sgp.baseline.grade.sequences=list(c("3", "4", "6")),
         sgp.projection.sequence="MATHEMATICS_GRADE_6"),
     # MATHEMATICS.2021 = list(  ##  Non-existent
     #     sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
     #     sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
     #     sgp.baseline.panel.years=c("2018", "2019", "2021"),
     #     sgp.panel.years=c("2018", "2019", "2021"),
     #     sgp.grade.sequences=list(c("4", "5", "7")),
     #     sgp.baseline.grade.sequences=list(c("4", "5", "7")),
     #     sgp.projection.sequence="MATHEMATICS_GRADE_7"),
     MATHEMATICS.2021 = list(
         sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
         sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
         sgp.baseline.panel.years=c("2018", "2019", "2021"),
         sgp.panel.years=c("2018", "2019", "2021"),
         sgp.grade.sequences=list(c("5", "6", "8")),
         sgp.baseline.grade.sequences=list(c("5", "6", "8")),
         sgp.projection.sequence="MATHEMATICS_GRADE_8")
)

MATHEMATICS_PSAT_2021.config <- list(
     MATHEMATICS_PSAT_9.2021 = list(
         sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
         sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_9"),
         sgp.baseline.panel.years=c("2018", "2019", "2021"),
         sgp.panel.years=c("2018", "2019", "2021"),
         sgp.grade.sequences=list(c("6", "7", "9")),
         sgp.baseline.grade.sequences=list(c("6", "7", "9")),
         sgp.projection.sequence="MATHEMATICS_PSAT_9"),

    MATHEMATICS_PSAT_10.2021 = list(
        sgp.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_10"),
        sgp.baseline.content.areas=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS_PSAT_10"),
        sgp.baseline.panel.years=c("2018", "2019", "2021"),
        sgp.panel.years=c("2018", "2019", "2021"),
        sgp.grade.sequences=list(c("7", "8", "10")),
        sgp.baseline.grade.sequences=list(c("7", "8", "10")),
        sgp.projection.sequence="MATHEMATICS_PSAT_10")
)
