#######
# 2018
#######

### Load required packages

require(SGP)
require(Literasee)
require(data.table)

setwd("/Users/avi/Dropbox (SGP)/Github_Repos/Documentation/Colorado/SGP_Reports/2018")

load("/Users/avi/Dropbox (SGP)/SGP/Colorado/Data/Colorado_SGP.Rdata")

Colorado_SGP@Data$Most_Recent_Prior <- as.character(NA)
Colorado_SGP@Data[, Most_Recent_Prior := sapply(strsplit(as.character(Colorado_SGP@Data$SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]


renderMultiDocument(rmd_input = "Colorado_SGP_Report_2018.Rmd",
										report_format = c("HTML", "PDF"),
										# cover_img="../img/cover.jpg",
										# add_cover_title=TRUE, 
										# cleanup_aux_files = FALSE,
										pandoc_args = "--webtex")

renderMultiDocument(rmd_input = "Appendix_A_2018.Rmd",
										report_format = c("HTML", "PDF"))

renderMultiDocument(rmd_input = "Appendix_B.Rmd",
										report_format = c("HTML", "PDF"),
										pandoc_args = "--webtex")

renderMultiDocument(rmd_input = "Appendix_C_2018.Rmd",
										report_format = c("HTML", "PDF"))



#######
# 2015
#######

### Load required packages

require(SGP)
require(data.table)

setwd("/Users/avi/Dropbox (SGP)/Github_Repos/Documentation/Colorado/SGP_Reports/2015")

# load("/Users/avi/Dropbox (SGP)/SGP/Colorado/Data/Colorado_SGP.Rdata")
load("../../Colorado_SGP.Rdata")

Colorado_SGP@Data$Most_Recent_Prior <- as.character(NA)
Colorado_SGP@Data[, Most_Recent_Prior := sapply(strsplit(as.character(Colorado_SGP@Data$SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]


library(SGPreports)
use.data.table()

renderMultiDocument(rmd_input = "Colorado_SGP_Report_2015.Rmd",
										output_format = c("HTML", "PDF"), #"EPUB", 
										# cover_img="../img/cover.jpg",
										# add_cover_title=TRUE, 
										# cleanup_aux_files = FALSE,
										pandoc_args = "--webtex")

renderMultiDocument(rmd_input = "Appendix_A_2015.Rmd",
										output_format = c("HTML", "PDF"))
										# cover_img="../img/cover.jpg",
										# add_cover_title=TRUE)#,
										# cleanup_aux_files = FALSE)

require(Literasee)
renderMultiDocument(rmd_input = "Appendix_B.Rmd",
										report_format = c("HTML", "PDF"),
										pandoc_args = "--webtex")


renderMultiDocument(rmd_input = "Appendix_C_2015.Rmd",
										output_format = c("HTML", "PDF"),
										cleanup_aux_files = FALSE,
										self_contained=FALSE)
										# cover_img="../img/cover.jpg",
										# add_cover_title=TRUE)

renderMultiDocument(rmd_input = "Appendix_B.Rmd",
										output_format = c("LITERASEE"), # c("HTML", "PDF"), 
										# cover_img="../img/cover.jpg",
										# add_cover_title=TRUE,
										# html_template = "/Library/Frameworks/R.framework/Versions/3.3/Resources/library/SGPreports/rmarkdown/templates/multi_document/resources/literasee.html",
										self_contained = FALSE,
										# cleanup_aux_files = FALSE,
										literasee.repo="Norm-and-Criterion-Referenced-Growth",
										literasee.description="An Overview of the SGP Methodology",
										pandoc_args = "--webtex")

system("git remote add origin https://github.com/adamvi/Norm-and-Criterion-Referenced-Growth.git")

dir.create("SGP-Method")
file.copy("LITERASEE", "SGP-Method", recursive=TRUE)
system("git remote add origin https://github.com/adamvi/SGP-Method.git")
system("git push -u origin master")
# renderMultiDocument(rmd_input = "Appendix_C_2015_SS.Rmd",
# 										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
# 										# cleanup_aux_files = FALSE)
# 										cover_img="../img/cover.jpg",
# 										add_cover_title=TRUE)#,
