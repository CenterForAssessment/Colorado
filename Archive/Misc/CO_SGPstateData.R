### COLORADO

load("CSEM/Colorado/Colorado_CSEM.Rdata")

SGPstateData[["CO"]][["Achievement"]][["Knots_Boundaries"]] <- 
	list(MATHEMATICS=list(
		boundaries_3=c(150, 700),
		boundaries_4=c(180, 780),
		boundaries_5=c(220, 800),
		boundaries_6=c(240, 830),
		boundaries_7=c(280, 860),
		boundaries_8=c(310, 890),
		boundaries_9=c(340, 920),
		boundaries_10=c(370, 950),
		knots_3=c(392, 440, 481, 529),
		knots_4=c(425, 470, 506, 546),
		knots_5=c(452, 495, 530, 569),
		knots_6=c(465, 509, 546, 588),
		knots_7=c(490, 530, 565, 600),
		knots_8=c(500, 545, 580, 620),
		knots_9=c(515, 560, 595, 630),
		knots_10=c(530, 575, 610, 645),
		loss.hoss_3=c(150, 700),
		loss.hoss_4=c(180, 780),
		loss.hoss_5=c(220, 800),
		loss.hoss_6=c(240, 830),
		loss.hoss_7=c(280, 860),
		loss.hoss_8=c(310, 890),
		loss.hoss_9=c(340, 920),
		loss.hoss_10=c(370, 950)),
	READING=list(
		boundaries_3=c(150, 795),
		boundaries_4=c(180, 940),
		boundaries_5=c(220, 955),
		boundaries_6=c(260, 970),
		boundaries_7=c(300, 980),
		boundaries_8=c(330, 990),
		boundaries_9=c(350, 995),
		boundaries_10=c(370, 999),
		knots_3=c(510, 550, 580, 615),
		knots_4=c(542, 580, 606, 635),
		knots_5=c(562, 602, 632, 665),
		knots_6=c(575, 615, 645, 675),
		knots_7=c(586, 625, 655, 690),
		knots_8=c(605, 642, 670, 702),
		knots_9=c(620, 655, 680, 706),
		knots_10=c(642, 675, 700, 730),
		loss.hoss_3=c(150, 795),
		loss.hoss_4=c(180, 940),
		loss.hoss_5=c(220, 955),
		loss.hoss_6=c(260, 970),
		loss.hoss_7=c(300, 980),
		loss.hoss_8=c(330, 990),
		loss.hoss_9=c(350, 995),
		loss.hoss_10=c(370, 999)),
	WRITING=list(
		boundaries_3=c(150, 680),
		boundaries_4=c(190, 730),
		boundaries_5=c(220, 780),
		boundaries_6=c(230, 840),
		boundaries_7=c(240, 890),
		boundaries_8=c(250, 910),
		boundaries_9=c(260, 930),
		boundaries_10=c(270, 950),
		knots_3=c(430, 460, 480, 515),
		knots_4=c(445, 475, 500, 530),
		knots_5=c(460, 495, 520, 550),
		knots_6=c(475, 510, 540, 575),
		knots_7=c(495, 533, 565, 605),
		knots_8=c(495, 540, 575, 615),
		knots_9=c(505, 550, 585, 629),
		knots_10=c(515, 565, 600, 645),
		loss.hoss_3=c(150, 680),
		loss.hoss_4=c(190, 730),
		loss.hoss_5=c(220, 780),
		loss.hoss_6=c(230, 840),
		loss.hoss_7=c(240, 890),
		loss.hoss_8=c(250, 910),
		loss.hoss_9=c(260, 930),
		loss.hoss_10=c(270, 950)))
						  
SGPstateData[["CO"]][["Achievement"]][["Cutscores"]] <- 
	list(MATHEMATICS=list(
		GRADE_3=c(335, 419, 510),
		GRADE_4=c(383, 455, 538),
		GRADE_5=c(422, 494, 562),
		GRADE_6=c(454, 520, 589),
		GRADE_7=c(487, 559, 614),
		GRADE_8=c(521, 577, 628),
		GRADE_9=c(548, 602, 652),
		GRADE_10=c(562, 627, 692)),
	READING=list(
		GRADE_3=c(466, 526, 656),
		GRADE_4=c(517, 572, 671),
		GRADE_5=c(538, 588, 691),
		GRADE_6=c(543, 600, 696),
		GRADE_7=c(567, 620, 716),
		GRADE_8=c(578, 632, 724),
		GRADE_9=c(585, 642, 739),
		GRADE_10=c(607, 663, 747)),
	WRITING=list(
		GRADE_3=c(393, 465, 533),
		GRADE_4=c(414, 485, 554),
		GRADE_5=c(418, 498, 576),
		GRADE_6=c(423, 513, 600),
		GRADE_7=c(430, 539, 629),
		GRADE_8=c(434, 556, 651),
		GRADE_9=c(436, 563, 672),
		GRADE_10=c(459, 578, 690)))

SGPstateData[["CO"]][["Achievement"]][["Levels"]] <- 
	list(
	Labels=c("Unsatisfactory", "Partially Proficient", "Proficient", "Advanced", "No Score"),
	Proficient=c("Not Proficient", "Not Proficient", "Proficient", "Proficient", NA))

SGPstateData[["CO"]][["Growth"]][["Levels"]] <- c("Low", "Typical", "High")

SGPstateData[["CO"]][["Growth"]][["System_Type"]] <- "Cohort Referenced"

SGPstateData[["CO"]][["Growth"]][["Cutscores"]] <- 
	list(
	Cuts=c(35, 66), 
	Labels=c("1st - 34th", "35th - 65th", "66th - 99th"))

SGPstateData[["CO"]][["Assessment_Program_Information"]] <- 
	list(
	Assessment_Name="Colorado Student Assessment Program",
	Assessment_Abbreviation="CSAP",
	Organization=list(
		Name="Colorado Department of Education",
		URL="www.schoolview.org",
		Contact="303-866-6600"),
	Content_Areas=c("Mathematics", "Reading", "Writing"),
	Grades_Tested=c(3,4,5,6,7,8,9,10),
	Assessment_Years=c(2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011),
	Test_Vendor="CTB/McGraw Hill",
	CSEM=Colorado_CSEM)

SGPstateData[["CO"]][["Student_Report_Information"]] <- 
	list(
	Vertical_Scale="Yes",
	Content_Areas_Labels=list(MATHEMATICS="Math", READING="Reading", WRITING="Writing"),
	Grades_Reported=list(MATHEMATICS=c(3,4,5,6,7,8,9,10), READING=c(3,4,5,6,7,8,9,10), WRITING=c(3,4,5,6,7,8,9,10)), 
	Achievement_Level_Labels=list(
		"Unsatisfactory"="Unsatisfactory", 
		"Part Proficient"="Partially Proficient", 
		"Proficient"="Proficient", 
		"Advanced"="Advanced"))		
