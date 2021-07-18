################################################################################
###                                                                          ###
###                Produce 2019 Colorado ISRs for CMAS data                  ###
###                                                                          ###
################################################################################
ssh -i "~/CO_ISR_2017.pem" ec2-user@54.87.23.200
ssh -i "~/CO_ISR_2018.pem" ec2-user@34.229.219.224

cd /home/ec2-user
mkdir Colorado
sudo mkfs -t ext4 /dev/sdg
sudo mount /dev/sdg Colorado
sudo mkdir Colorado/Visualizations
sudo mkdir Colorado/Visualizations/Misc
sudo cp -avr #  Copy over cover pages


###  Before opening R set `ulimit -S -n 4096` to avoid error about too many files open in pdflatex  - also lowered par workers to 30.

###   Load required data and packages
load("Data/Colorado_SGP.Rdata")

require(SGP)
require(data.table)

options(error=recover)

SGPstateData[["CO"]][["Student_Report_Information"]][["Earliest_Year_Reported"]] <- NULL
SGPstateData[["CO"]][["Assessment_Program_Information"]][["Assessment_Transition"]]  <- NULL

###   Run before P/SAT analyses - CMAS kids ONLY!
###   Still need to remove prior PSAT/SAT/EOCT courses for some kids (avoid 'duplicates' where kids took PSAT and CMAS - domain dups)
Colorado_SGP@Data <- Colorado_SGP@Data[CONTENT_AREA %in% c("ELA", "MATHEMATICS")]

####
#   Clean up SCHOOL_NAME and DISTRICT_NAME
#   Check levels first to confirm special.words - Clean Well for ISRs
####

###  Schools
grep("Ece", levels(Colorado_SGP@Data$SCHOOL_NAME), value=T)

new.sch.levs <- toupper(levels(Colorado_SGP@Data$SCHOOL_NAME))
new.sch.levs <- gsub("/", " / ", new.sch.levs)

new.sch.levs <- sapply(new.sch.levs, SGP::capwords, special.words = c('AIM', 'AXL', 'CCH', 'CMS', 'DC', 'DCIS', 'DSST', 'DSST:', 'ECE-8', 'GVR', 'IB', 'KIPP', 'PK', 'PK-8', 'PK-12', 'PSD', 'LEAP', 'MHCD', 'STEM', 'TCA', 'VSSA'), USE.NAMES=FALSE)
new.sch.levs <- gsub(" / ", "/", new.sch.levs)
new.sch.levs <- gsub("Prek", "PreK", new.sch.levs)
new.sch.levs <- gsub("Mcauliffe", "McAuliffe", new.sch.levs)
new.sch.levs <- gsub("Mcglone", "McGlone", new.sch.levs)
new.sch.levs <- gsub("Mcgraw", "McGraw", new.sch.levs)
new.sch.levs <- gsub("Mckinley", "McKinley", new.sch.levs)
new.sch.levs <- gsub("Mcmeen", "McMeen", new.sch.levs)
new.sch.levs <- gsub("Mc Clave", "McClave", new.sch.levs)
new.sch.levs <- gsub("Mc Elwain", "McElwain", new.sch.levs)
new.sch.levs <- gsub("Mc Ginnis", "McGinnis", new.sch.levs)
new.sch.levs <- gsub("Achieve Online", "ACHIEVE Online", new.sch.levs)
setattr(Colorado_SGP@Data$SCHOOL_NAME, "levels", new.sch.levs)

###  Districts
grep("J", levels(Colorado_SGP@Data$DISTRICT_NAME), value=T)
new.dst.levs <- toupper(levels(Colorado_SGP@Data$DISTRICT_NAME))
new.dst.levs <- gsub("/", " / ", new.dst.levs)
new.dst.levs <- gsub("[-]", " - ", new.dst.levs)

new.dst.levs <- sapply(new.dst.levs, SGP::capwords, special.words = c('1J', '2J', '3J', '4J', '5J', '6J', '11J', '22J', '27J', '28J', '29J', '31J', '33J', '100J', 'JT', '32J', 'RJ', '26J', '49JT', '4A', 'RD', 'RE', 'RE1J'), USE.NAMES=FALSE)
new.dst.levs <- gsub(" / ", "/", new.dst.levs)
new.dst.levs <- gsub(" - ", "-", new.dst.levs)
new.dst.levs <- gsub("Mc Clave", "McClave", new.dst.levs)
grep("j", new.dst.levs, value=T) # Should only leave * Conejos

setattr(Colorado_SGP@Data$DISTRICT_NAME, "levels", new.dst.levs)


###
###   Produce ISRs using visualizeSGP function
###

visualizeSGP(
	Colorado_SGP,
	plot.types=c("studentGrowthPlot"),
	sgPlot.content_areas = c("ELA", "MATHEMATICS"),
	# sgPlot.demo.report = TRUE,
	# sgPlot.districts = "0880", # "0100", #
	# sgPlot.schools = missing.schools, # "9389", # "2223"
	sgPlot.front.page = "Visualizations/Misc/2019_CMAS_ISR_Cover_Page.pdf",
	sgPlot.header.footer.color="#6EC4E8",
	parallel.config=list(
		BACKEND="PARALLEL",
		WORKERS=list(SG_PLOTS = 30)))

###
###   Post-Hoc checks for missing schools/districs
###

require(data.table)
dist <- system("ls /home/ec2-user/Colorado/Visualizations/studentGrowthPlots/School/2019", intern=TRUE)
dat.dist <- unique(Colorado_SGP_LONG_Data_2019[!is.na(SGP)]$DISTRICT_NUMBER)
miss <- setdiff(dat.dist, dist)
m <- Colorado_SGP_LONG_Data_2019[!is.na(SGP) & DISTRICT_NUMBER %in% miss]
table(m[, GRADE, CONTENT_AREA]) #  0

problem.districts <- list()
for (d in dist) {
	data.schools <- unique(Colorado_SGP_LONG_Data_2019[DISTRICT_NUMBER == d, SCHOOL_NUMBER])
	file.schools <- system(paste0("ls /home/ec2-user/Colorado/Visualizations/studentGrowthPlots/School/2019/", d), intern=TRUE)
	file.schools <- gsub("[.]zip", "", file.schools)
	if (!(all(file.schools %in% data.schools) | all(data.schools %in% file.schools))) {
		missing.schools <- setdiff(data.schools, file.schools)
		problem.districts[[d]] <- missing.schools
	}
}

#  No Problem Schools within Districts :-)
