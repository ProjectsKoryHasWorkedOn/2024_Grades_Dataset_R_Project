#R libraries

#Install R libraries if not installed
hello <- "hello"
hello

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

#Search for "cowplot" package and install if not installed
cowplot <- find.package("cowplot", quiet = TRUE)
cowplot_installed <- ifelse((nchar(cowplot) == 0),FALSE,TRUE)
if(!cowplot_installed){
  install.packages("cowplot")
}

#Search for "aoos" package and install if not installed
aoos <- find.package("aoos", quiet = TRUE)
aoos_installed <- ifelse((nchar(aoos) == 0),FALSE,TRUE)
if(!aoos_installed){
  install.packages("aoos")
}

#Load in R libraries
library(mongolite)
library(tidyverse) # contains ggplot, etc.
library(cowplot)
library(aoos)
