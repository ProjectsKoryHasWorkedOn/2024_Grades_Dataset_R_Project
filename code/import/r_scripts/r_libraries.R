#R libraries

#Install R libraries if not installed

# See if filepath is an integer of length 0 (i.e. not found)
is.integerOrCharacterOfLength0 <- function(x)
{
  if((is.integer(x) || is.character(x) ) && length(x) == 0L){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}


#Search for "mongolite" package and install if not installed
mongolite_package <- find.package("mongolite", quiet = TRUE)
mongolite_not_installed <- is.integerOrCharacterOfLength0(mongolite_package)
if(mongolite_not_installed == TRUE){
  install.packages("mongolite")
}

#Search for "tidyverse" package and install if not installed
tidyverse_package <- find.package("tidyverse", quiet = TRUE)
tidyverse_not_installed <- is.integerOrCharacterOfLength0(tidyverse_package)
if(tidyverse_not_installed == TRUE){
  install.packages("tidyverse", dependencies=T)
}

#Search for "R6" package and install if not installed
r6 <- find.package("R6", quiet = TRUE)
r6_not_installed <- is.integerOrCharacterOfLength0(r6)
if(r6_not_installed == TRUE){
  install.packages("R6")
}

#Search for "sqldf" package and install if not installed
sqldf_package <- find.package("sqldf", quiet = TRUE)
sqldf_not_installed <- is.integerOrCharacterOfLength0(sqldf_package)
if(sqldf_not_installed == TRUE){
  install.packages("sqldf")
}

#Search for "colourvalues" package and install if not installed
colourvalues <- find.package("colourvalues", quiet = TRUE)
colourvalues_not_installed <- is.integerOrCharacterOfLength0(colourvalues)
if(colourvalues_not_installed == TRUE){
  install.packages("colourvalues")
}

#Search for "car" package and install if not installed
car_package <- find.package("car", quiet = TRUE)
car_not_installed <- is.integerOrCharacterOfLength0(car_package)
if(car_not_installed == TRUE){
  install.packages("car")
}

ggrepel_package <- find.package("ggrepel", quiet = TRUE)
ggrepel_not_installed <- is.integerOrCharacterOfLength0(ggrepel_package)
if(ggrepel_not_installed == TRUE){
  install.packages("ggrepel")
}


waffle_package <- find.package("waffle", quiet = TRUE)
waffle_not_installed <- is.integerOrCharacterOfLength0(waffle_package)
if(waffle_not_installed == TRUE){
  install.packages("waffle")
}



sf_package <- find.package("sf", quiet = TRUE)
sf_not_installed <- is.integerOrCharacterOfLength0(sf_package)
if(sf_not_installed == TRUE){
  install.packages("sf")
}

rnaturalearth_package <- find.package("rnaturalearth", quiet = TRUE)
rnaturalearth_not_installed <- is.integerOrCharacterOfLength0(rnaturalearth_package)
if(rnaturalearth_not_installed == TRUE){
  install.packages("rnaturalearth")
}

devtools_package <- find.package("devtools", quiet = TRUE)
devtools_not_installed <- is.integerOrCharacterOfLength0(devtools_package)
if(devtools_not_installed == TRUE){
  install.packages("devtools")
}

#Load in R libraries
library(devtools)

rnaturalearthhires_package <- find.package("rnaturalearthhires", quiet = TRUE)
rnaturalearthhires_not_installed <- is.integerOrCharacterOfLength0(rnaturalearthhires_package)
if(rnaturalearthhires_not_installed == TRUE){
  devtools::install_github("ropensci/rnaturalearthhires")
}

#Load in R libraries
library(mongolite)
library(tidyverse) # contains ggplot, etc.
library(R6)
library(sqldf)
library(colourvalues)
library(car)
library(ggrepel)
library(waffle)
library(sf)
library(rnaturalearth) 