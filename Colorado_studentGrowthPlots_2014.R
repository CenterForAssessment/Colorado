#######################################################################
###
### Script to produce 2014 student report for Colorado
###
#######################################################################

### Load SGP Package

require(SGP)


### Load Data

#load("Data/Colorado_SGP.Rdata")
load("Data/Colorado_studentGrowthPlot_Data.Rdata")


### Create studentGrowthPlot Data

visualizeSGP(Colorado_SGP, plot.types="studentGrowthPlot", sgPlot.save.sgPlot.data=TRUE, sgPlot.produce.plots=FALSE)


### Create PDF student reports

visualizeSGP(Colorado_studentGrowthPlot_Data, plot.types="studentGrowthPlot", sgPlot.front.page="front_page_2014.pdf", parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SG_PLOTS=30)))


### Create PNG student reports

visualizeSGP(Colorado_studentGrowthPlot_Data, plot.types="studentGrowthPlot", sgPlot.output.format="PNG", parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SG_PLOTS=30)))
