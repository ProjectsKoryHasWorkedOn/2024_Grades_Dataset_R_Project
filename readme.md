# Dependencies

**Latest stable version of R (v4.3.3)**

https://cran.r-project.org/bin/windows/base/


Note that v4.3.2 and v.4.4.0 does not work with one's libraries

**Latest version of RStudio Desktop (2023.12.1)**

https://posit.co/download/rstudio-desktop/

# Troubleshooting steps that worked for me when one's working code stopped working

Fix A:

1. Delete .Rhistory file
1. Delete .Rdata file
1. Reload the session

Fix B:

1. Option > Tools > Untick "Restore .RData into workplace at startup"


# Files used to help make the final report, which can be found in `documentation > r_project_report`

`mongodb_dataset_code.R`, `mongodb_dataset_report.Rmd`
* Covers data wrangling, transformation, analysis, and modelling
* Leads to the creation of a report via the R markdown file that speaks about some of the decisions I made when working with the MongoDB dataset

`oulad_dataset_code_part_1.R`, `oulad_dataset_code_part_1_report.Rmd`
* Covers data wrangling and data transformation
* Leads to the creation of some new .CSV files that I load into ''oulad_dataset_code_part_2.R'' from the ''import/csv_after_processing'' folder
* Leads to the creation of a report via the R markdown file that speaks about some of the decisions I made when working with the OULAD dataset

`oulad_dataset_code_part_2.R`, `oulad_dataset_code_part_2_report.Rmd`
* Covers data analysis and data modelling
* Leads to the creation of a report via the R markdown file that speaks about some of the decisions I made when working with the OULAD dataset
