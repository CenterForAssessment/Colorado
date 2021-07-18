  if (!is.null(transition.grade)) {
    if (identical(toupper(Report_Parameters[['Assessment_Transition']][['Assessment_Transition_Type']][1]), "NO")) {
      tmp.cutscore.year <- tail(head(sort(unique(Cutscores[['YEAR']]), na.last=FALSE), -1), 1)
      tmp.cutscore.grade <- grade.values[['interp.df']][['GRADE']][which(grade.values[['years']]==Report_Parameters[['Assessment_Transition']][['Year']])]
      if (!tmp.cutscore.grade %in% Cutscores[['GRADE']]) {
        tmp.grades.reported <- SGP::SGPstateData[[Report_Parameters$State]][["Student_Report_Information"]][["Grades_Reported"]][[Report_Parameters$Content_Area]]
        tmp.cutscore.grade <-
          tmp.grades.reported[which.max(as.numeric(grade.values[['interp.df']][['GRADE']][which(grade.values[['years']]==Report_Parameters[['Assessment_Transition']][['Year']])]) < tmp.grades.reported)-1]
      }
      if (is.na(tmp.cutscore.year)) {
        Cutscores[is.na(YEAR), CUTSCORES := Cutscores[GRADE==tmp.cutscore.grade & is.na(YEAR)][['CUTSCORES']]]
      } else {
        Cutscores[is.na(YEAR) | YEAR < Report_Parameters$Assessment_Transition$Year,
          CUTSCORES:=Cutscores[GRADE==tmp.cutscore.grade & YEAR==tmp.cutscore.year][['CUTSCORES']]]
      }
    }
    if (identical(toupper(Report_Parameters[['Assessment_Transition']][['Assessment_Transition_Type']][2]), "NO")) {
      tmp.cutscore.grade <- Grades[which(Years==Report_Parameters[['Assessment_Transition']][['Year']])]
      if (is.na(tmp.cutscore.grade)) {
        tmp.cutscore.grade <- grade.values[['interp.df']][['GRADE']][which(grade.values[['years']]==Report_Parameters[['Assessment_Transition']][['Year']])]
      }
      Cutscores[!is.na(YEAR) & YEAR >= Report_Parameters$Assessment_Transition$Year,
        CUTSCORES:=Cutscores[GRADE==tmp.cutscore.grade & YEAR >= Report_Parameters$Assessment_Transition$Year][['CUTSCORES']]]
    }
  }
