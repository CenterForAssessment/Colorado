require(data.table)
require(SGP)

###  Load data
load("/Users/avi/Dropbox/SGP/Colorado/Data/Colorado_studentGrowthPlot_Data_2014.Rdata")
New_Names <- data.table(read.table("/Users/avi/Dropbox/SGP/Colorado/Data/Base_Files/TCAP_GROWTH_2014_REVISED_NAMES_FOR_ISRs.TXT", colClasses=rep("character", 3), header=TRUE, sep="\t"), key="ID")

load('/media/Data/Dropbox/SGP/Colorado/Data/Colorado_SGP.Rdata')
load("/media/Data/Dropbox/SGP/Colorado/Data/Colorado_studentGrowthPlot_Data_2014.Rdata")
New_Names <- data.table(read.table("/media/Data/Dropbox/SGP/Colorado/Data/Base_Files/TCAP_GROWTH_2014_REVISED_NAMES_FOR_ISRs.TXT", colClasses=rep("character", 3), header=TRUE, sep="\t"), key="ID")

sum(!New_Names$ID %in% Colorado_studentGrowthPlot_Data$ID)
sum(!Colorado_studentGrowthPlot_Data$ID %in% New_Names$ID) # 27 student records (9 students - 3 subjects) with IDs not included in New_Names file.

tmp.names <- New_Names[Colorado_studentGrowthPlot_Data][which(!Colorado_studentGrowthPlot_Data$ID %in% New_Names$ID), list(ID, LAST_NAME.2014, FIRST_NAME.2014)]
setkey(tmp.names)
tmp.names <- tmp.names[!is.na(LAST_NAME.2014) & !duplicated(tmp.names)]
setnames(tmp.names, c("LAST_NAME.2014", "FIRST_NAME.2014"), c("LAST_NAME", "FIRST_NAME"))

New_Names <- rbind(tmp.names, New_Names[New_Names$ID %in% Colorado_studentGrowthPlot_Data$ID])
setkey(New_Names, ID)

Colorado_studentGrowthPlot_Data <- New_Names[Colorado_studentGrowthPlot_Data]

sum(as.character(Colorado_studentGrowthPlot_Data$LAST_NAME) != as.character(Colorado_studentGrowthPlot_Data$LAST_NAME.2014), na.rm=T)

head(Colorado_studentGrowthPlot_Data$LAST_NAME.2014[as.character(Colorado_studentGrowthPlot_Data$LAST_NAME) != as.character(Colorado_studentGrowthPlot_Data$LAST_NAME.2014) & !is.na(Colorado_studentGrowthPlot_Data$LAST_NAME.2014)])
head(Colorado_studentGrowthPlot_Data$LAST_NAME[as.character(Colorado_studentGrowthPlot_Data$LAST_NAME) != as.character(Colorado_studentGrowthPlot_Data$LAST_NAME.2014) & !is.na(Colorado_studentGrowthPlot_Data$LAST_NAME.2014)])

Colorado_studentGrowthPlot_Data[, LAST_NAME.2014 := NULL]
Colorado_studentGrowthPlot_Data[, FIRST_NAME.2014 := NULL]

setnames(Colorado_studentGrowthPlot_Data, c("LAST_NAME", "FIRST_NAME"), c("LAST_NAME.2014", "FIRST_NAME.2014"))


sgp.key <- key(Colorado_SGP@Data)
setkey(Colorado_SGP@Data, ID)
New_Names[, LAST_NAME := as.character(LAST_NAME)]
New_Names[, FIRST_NAME := as.character(FIRST_NAME)]
Colorado_SGP@Data[, LAST_NAME := as.character(LAST_NAME)]
Colorado_SGP@Data[, FIRST_NAME := as.character(FIRST_NAME)]
# Colorado_SGP@Data[which(YEAR=='2014'), LAST_NAME := as.character(NA)]
# Colorado_SGP@Data[which(YEAR=='2014'), FIRST_NAME := as.character(NA)]

tmp <- New_Names[Colorado_SGP@Data]

tmp[which(YEAR=='2014' & !is.na(LAST_NAME)), LAST_NAME.1 := LAST_NAME]
tmp[which(YEAR=='2014' & !is.na(FIRST_NAME)), FIRST_NAME.1 := FIRST_NAME]

tmp[, LAST_NAME := NULL]
tmp[, FIRST_NAME := NULL]

setnames(tmp, c("LAST_NAME.1", "FIRST_NAME.1"), c("LAST_NAME", "FIRST_NAME"))

tmp[, LAST_NAME := factor(LAST_NAME)]
tmp[, FIRST_NAME := factor(FIRST_NAME)]

# Colorado_SGP@Data[which(YEAR=='2014'), LAST_NAME := New_Names[ID[1]][["LAST_NAME"]], by = ID]
# Colorado_SGP@Data[which(YEAR=='2014'), FIRST_NAME := New_Names[ID[1]][["FIRST_NAME"]], by = ID]

setkeyv(tmp, sgp.key)
Colorado_SGP@Data <- tmp

save(Colorado_SGP, file='/media/Data/Dropbox/SGP/Colorado/Data/Colorado_SGP.Rdata')

visualizeSGP(
	sgp_object=Colorado_studentGrowthPlot_Data,
	state='CO',
	plot.types='studentGrowthPlot',
	# sgPlot.districts=c('10'),
	sgPlot.schools= c('309', '9036'),
	sgPlot.years='2014',
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SG_PLOTS=23)))
#)


###  For Josh

###  Load the updated WIDE ISR data object
load("Colorado_studentGrowthPlot_Data_2014.Rdata")

visualizeSGP(
	sgp_object=Colorado_studentGrowthPlot_Data,
	state='CO',
	plot.types='studentGrowthPlot',
	sgPlot.front.page="front_page_2014.pdf",
	# sgPlot.districts=c('10'),
	sgPlot.schools= c('309', '9036'),
	sgPlot.years='2014',
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SG_PLOTS=10)))
