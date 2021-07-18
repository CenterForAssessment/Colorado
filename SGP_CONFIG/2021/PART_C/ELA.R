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
     # ELA.2021 = list(
     #             sgp.content.areas=c("ELA", "ELA", "ELA"),
     #             sgp.baseline.content.areas=c("ELA", "ELA", "ELA"),
     #             sgp.baseline.panel.years=c("2018", "2019", "2021"),
     #             sgp.panel.years=c("2018", "2019", "2021"),
     #             sgp.grade.sequences=list(c("3", "4", "6")),
     #             sgp.baseline.grade.sequences=list(c("3", "4", "6")),
     #             sgp.projection.sequence="ELA_GRADE_6"),
     ELA.2021 = list(
                 sgp.content.areas=c("ELA", "ELA", "ELA"),
                 sgp.baseline.content.areas=c("ELA", "ELA", "ELA"),
                 sgp.baseline.panel.years=c("2018", "2019", "2021"),
                 sgp.panel.years=c("2018", "2019", "2021"),
                 sgp.grade.sequences=list(c("4", "5", "7")),
                 sgp.baseline.grade.sequences=list(c("4", "5", "7")),
                 sgp.projection.sequence="ELA_GRADE_7")#,
)                 
     # ELA.2021 = list(
     #             sgp.content.areas=c("ELA", "ELA", "ELA"),
     #             sgp.baseline.content.areas=c("ELA", "ELA", "ELA"),
     #             sgp.baseline.panel.years=c("2018", "2019", "2021"),
     #             sgp.panel.years=c("2018", "2019", "2021"),
     #             sgp.grade.sequences=list(c("5", "6", "8")),
     #             sgp.baseline.grade.sequences=list(c("5", "6", "8")),
     #             sgp.projection.sequence="ELA_GRADE_8"))
