#R libraries

#Install R libraries if not installed

# See if filepath is an integer of length 0 (i.e. not found)
is.integer0 <- function(x)
{
  is.integer(x) && length(x) == 0L
}


#Search for "mongolite" package and install if not installed
mongolite <- find.package("mongolite", quiet = TRUE)
mongolite_not_installed <- is.integer0(mongolite)
if(mongolite_not_installed == TRUE){
  install.packages("mongolite")
}

#Search for "tidyverse" package and install if not installed
tidyplot <- find.package("tidyverse", quiet = TRUE)
tidyplot_not_installed <- is.integer0(tidyplot)
if(tidyplot_not_installed == TRUE){
  install.packages("tidyverse", dependencies=T)
}

#Search for "R6" package and install if not installed
r6 <- find.package("R6", quiet = TRUE)
r6_not_installed <- is.integer0(r6)
if(r6_not_installed == TRUE){
  install.packages("R6")
}

#Search for "sqldf" package and install if not installed
sqldf <- find.package("sqldf", quiet = TRUE)
sqldf_not_installed <- is.integer0(sqldf)
if(sqldf_not_installed == TRUE){
  install.packages("sqldf")
}

#Search for "colourvalues" package and install if not installed
colourvalues <- find.package("colourvalues", quiet = TRUE)
colourvalues_not_installed <- is.integer0(colourvalues)
if(colourvalues_not_installed == TRUE){
  install.packages("colourvalues")
}

#Load in R libraries
library(mongolite)
library(tidyverse) # contains ggplot, etc.
library(R6)
library(sqldf)
library(colourvalues)




