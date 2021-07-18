####
####		Create New TCAP ISRs on a district and/or school specific basis
####

###  Load the updated WIDE ISR data object - update script to access correct local directory

load("Colorado_studentGrowthPlot_Data_2014.Rdata")

###  set your working directory to location you want to produce plots

###  Run visualizeSGP function to produce new ISRs on a district and/or school specific basis:

visualizeSGP(
	sgp_object=Colorado_studentGrowthPlot_Data,
	state='CO',
	plot.types='studentGrowthPlot',
	sgPlot.front.page="front_page_2014.pdf",
	# sgPlot.districts=c('10'), ##  Change district here.  Only use this line to (re)produce an entire district's ISRs
	sgPlot.schools= '502', #c('309', '9036'), ##  Change/Add schools here to (re)produce specific schools' ISRs
	sgPlot.years='2014',
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SG_PLOTS=12)))


###  If you need to produce .png versions too:
visualizeSGP(Colorado_studentGrowthPlot_Data, 
	plot.types="studentGrowthPlot", 
	sgPlot.output.format="PNG", 
	# sgPlot.districts=c('10'), ##  Change district here.  Only use this line to (re)produce an entire district's ISRs
	sgPlot.schools= c('309', '9036'), ##  Change/Add schools here to (re)produce specific schools' ISRs
	sgPlot.years='2014',
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SG_PLOTS=2)))
