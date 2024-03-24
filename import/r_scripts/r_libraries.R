#R libraries

#Install R libraries if not installed

#Search for "mongolite" package and install if not installed
mongolite <- find.package("mongolite", quiet = TRUE)
mongolite_installed <- ifelse((nchar(mongolite) == 0),FALSE,TRUE)
if(!mongolite_installed){
  install.packages("mongolite")
}

#Search for "tidyverse" package and install if not installed
tidyplot <- find.package("tidyverse", quiet = TRUE)
tidyplot_installed <- ifelse((nchar(tidyplot) == 0),FALSE,TRUE)
if(!tidyplot_installed){
  install.packages("tidyverse", dependencies=T)
}

#Search for "R6" package and install if not installed
r6 <- find.package("R6", quiet = TRUE)
r6_installed <- ifelse((nchar(r6) == 0),FALSE,TRUE)
if(!r6_installed){
  install.packages("R6")
}

#Load in R libraries
library(mongolite)
library(tidyverse) # contains ggplot, etc.
library(R6)



