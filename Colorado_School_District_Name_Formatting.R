######
###   Clean up SCHOOL_NAME and DISTRICT_NAME
###   Check levels first to confirm special.words
###   Clean Well for ISRs
######

###  Schools
new.sch.levs <- gsub("/", " / ", new.sch.levs)

sch.specials <-
  c("AIM", "APS", "AUL", "AXIS", "AXL", "BOCES", "CCH", "CEC", "CIVICA",
    "CMS", "(CMS)", "COVA", "CUBE", "DC", "DCIS", "DSST", "DSST:", "ECE-8",
    "GES", "GOAL", "GVR", "IB", "KIPP", "PK", "PK-8", "PK-12",
    "PSD", "LEAP", "MHCD", "MS", "SHS", "STEM", "TCA", "VSSA", "(VSSA)")

new.sch.levs <- sapply(X = new.sch.levs, USE.NAMES = FALSE,
                       FUN = SGP::capwords, special.words = sch.specials)

new.sch.levs <- gsub(" / ", "/", new.sch.levs)
new.sch.levs <- gsub("''", "'", new.sch.levs)
new.sch.levs <- gsub("- ", " - ", new.sch.levs)
new.sch.levs <- gsub("-  ", "- ", new.sch.levs)
new.sch.levs <- gsub("[']S", "'s", new.sch.levs)
new.sch.levs <- gsub("Prek", "PreK", new.sch.levs)
new.sch.levs <- gsub("Pk-8", "PK-8", new.sch.levs)
new.sch.levs <- gsub("Ece-8", "ECE-8", new.sch.levs)
new.sch.levs <- gsub("Jr Sr", "Jr/Sr", new.sch.levs)
# grep("[(]*?[)]", new.sch.levs, value = TRUE)
new.sch.levs <- gsub("[(]bill[)]", "(Bill)", new.sch.levs)
new.sch.levs <- gsub("[(]high[)]", "(High)", new.sch.levs)
new.sch.levs <- gsub("[(]middle[)]", "(Middle)", new.sch.levs)
new.sch.levs <- gsub("[(]elementary[)]", "(Elementary)", new.sch.levs)

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
new.sch.levs <- gsub("^Aul ", "AUL ", new.sch.levs)
new.sch.levs <- gsub("\"spectra Centers, Inc \"", "Spectra Centers Inc", new.sch.levs)

grep("Re-", new.sch.levs, value = TRUE)
grep("[[:digit:]]j", new.sch.levs, value = TRUE)
new.sch.levs <- gsub("3j", "3J", new.sch.levs)
new.sch.levs <- gsub("27j", "27J", new.sch.levs)
new.sch.levs <- gsub("49jt", "49JT", new.sch.levs)
new.sch.levs <- gsub("ADAMS12", "Adams 12", new.sch.levs)
new.dst.levs <- gsub("Re-", "RE-", new.dst.levs)


###  Districts
new.dst.levs <- gsub("/", " / ", new.dst.levs)
new.dst.levs <- gsub("[-]", " - ", new.dst.levs)

dst.specials <-
    c("1J", "2J", "3J", "4A", "4J", "5J", "6J", "10J", "10JT",
      "11J", "13JT", "22J", "26J", "27J", "28J", "29J", "31J",
      "32J", "33J", "49JT", "50J", "50JT", "60JT", "100J",
      "BOCES", "JT", "RJ", "RD", "RE", "RE1J")

new.dst.levs <- sapply(X = new.dst.levs, USE.NAMES = FALSE,
                       FUN = SGP::capwords, special.words = dst.specials)
# grep("[(]j[)]", new.dst.levs, value = TRUE)
new.dst.levs <- gsub("[(]j[)]", "J", new.dst.levs)
new.dst.levs <- gsub("[(]J[)]", "J", new.dst.levs)
new.dst.levs <- gsub("Re-", "RE-", new.dst.levs)
new.dst.levs <- gsub("RE-1-J", "RE-1J", new.dst.levs)
new.dst.levs <- gsub("RE-1-J", "RE-1J", new.dst.levs)
# grep("Re[:] No|RE No", new.dst.levs, value = TRUE)
new.dst.levs <- gsub("Re[:] No |RE No ", "RE-", new.dst.levs)
new.dst.levs <- gsub(" Jt", "JT", new.dst.levs)
new.dst.levs <- gsub(" JT", "-JT", new.dst.levs)
new.dst.levs <- gsub(" / ", "/", new.dst.levs)
new.dst.levs <- gsub("--", "-", new.dst.levs)
new.dst.levs <- gsub(" - ", "-", new.dst.levs)
new.dst.levs <- gsub("- ", "-", new.dst.levs)
new.dst.levs <- gsub("Mc Clave|Mcclave", "McClave", new.dst.levs)
new.dst.levs <- gsub("Adams- ", "Adams - ", new.dst.levs)

grep("Re ", new.dst.levs, value = TRUE)
# new.dst.levs <- gsub("R- ", "R-", new.dst.levs)
new.dst.levs <- gsub("RE ", "RE-", new.dst.levs)
new.dst.levs <- gsub("Re ", "RE-", new.dst.levs)
grep("j", new.dst.levs, value = TRUE) # Should only leave * Conejos
