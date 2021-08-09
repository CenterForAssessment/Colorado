#####
###   Configurations for calculating LAGGED PROJECTIONS in 2021
#####


ELA_2021.config <- list(
     ELA.2021 = list(
         sgp.content.areas=c("ELA", "ELA"),
         sgp.baseline.content.areas=c("ELA", "ELA"),
         sgp.panel.years=c("2019", "2021"),
         sgp.baseline.panel.years=c("2019", "2021"),
         sgp.grade.sequences=list(c("3", "5")),
         sgp.baseline.grade.sequences=list(c("3", "5")),
         sgp.projection.sequence="ELA_GRADE_5"),
     # ELA.2021 = list(  ##  Non-existent
     #     sgp.content.areas=c("ELA", "ELA", "ELA"),
     #     sgp.baseline.content.areas=c("ELA", "ELA", "ELA"),
     #     sgp.baseline.panel.years=c("2018", "2019", "2021"),
     #     sgp.panel.years=c("2018", "2019", "2021"),
     #     sgp.grade.sequences=list(c("3", "4", "6")),
     #     sgp.baseline.grade.sequences=list(c("3", "4", "6")),
     #     sgp.projection.sequence="ELA_GRADE_6"),
     ELA.2021 = list(
         sgp.content.areas=c("ELA", "ELA", "ELA"),
         sgp.baseline.content.areas=c("ELA", "ELA", "ELA"),
         sgp.baseline.panel.years=c("2018", "2019", "2021"),
         sgp.panel.years=c("2018", "2019", "2021"),
         sgp.grade.sequences=list(c("4", "5", "7")),
         sgp.baseline.grade.sequences=list(c("4", "5", "7")),
         sgp.projection.sequence="ELA_GRADE_7")#,
     # ELA.2021 = list(  ##  Non-existent
     #     sgp.content.areas=c("ELA", "ELA", "ELA"),
     #     sgp.baseline.content.areas=c("ELA", "ELA", "ELA"),
     #     sgp.baseline.panel.years=c("2018", "2019", "2021"),
     #     sgp.panel.years=c("2018", "2019", "2021"),
     #     sgp.grade.sequences=list(c("5", "6", "8")),
     #     sgp.baseline.grade.sequences=list(c("5", "6", "8")),
     #     sgp.projection.sequence="ELA_GRADE_8")
)

ELA_PSAT_2021.config <- list(
     ELA_PSAT_9.2021 = list(
         sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_9"),
         sgp.baseline.content.areas=c("ELA", "ELA", "ELA_PSAT_9"),
         sgp.baseline.panel.years=c("2018", "2019", "2021"),
         sgp.panel.years=c("2018", "2019", "2021"),
         sgp.grade.sequences=list(c("6", "7", "9")),
         sgp.baseline.grade.sequences=list(c("6", "7", "9")),
         sgp.projection.sequence="ELA_PSAT_9"),

    ELA_PSAT_10.2021 = list(
        sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
        sgp.baseline.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
        sgp.baseline.panel.years=c("2018", "2019", "2021"),
        sgp.panel.years=c("2018", "2019", "2021"),
        sgp.grade.sequences=list(c("7", "8", "10")),
        sgp.baseline.grade.sequences=list(c("7", "8", "10")),
        sgp.projection.sequence="ELA_PSAT_10")
)
