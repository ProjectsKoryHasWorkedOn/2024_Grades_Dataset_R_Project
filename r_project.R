# Installs and load the needed libraries
source(file=paste(getwd(),"/import/r_scripts/r_libraries.R", sep="")) 

# Import the needed classes
source(file=paste(getwd(),"/import/r_scripts/r_classes.R", sep="")) #Libraries installer/loader R script

# Declare a few classes that I'll be using to work with data
MyDataLoader <- DataLoader$new()
MyDataTransformer <- DataTransformer$new()
MyDataAnalyzer <- DataAnalyzer$new()
MyDataViewer <- DataViewer$new()
MyDataVisualizer <- DataVisualizer$new()
# MyDataModeler <- DataModeler

# What I've done to the Mongo DB dataset
# -- Data loading
MyDataLoader$setUserCredentials("fran0618", "WhwdV2u7cMmUJuDj")
MyDataLoader$setCluster("comp2031-8031")
MyDataLoader$setMongoDBCollection("grades", "sample_training")
mongoDBDataset <- MyDataLoader$retrieveDataFromMongoDBCollection()
# --

# -- Data transforming
MyDataTransformer$setDataset(mongoDBDataset)
MyDataTransformer$unnestAColumn("scores")
mongoDBDataset <- MyDataTransformer$returnDataset()
# --

# -- Data analysis
MyDataAnalyzer$setDataset(mongoDBDataset)

MyDataAnalyzer$calculateNumberOfColumns()

MyDataAnalyzer$calculateNumberOfRows()
MyDataAnalyzer$setNamesOfRows()

MyDataAnalyzer$calculateNumberOfMissingValues()

MyDataAnalyzer$calculateMean(mongoDBDataset$score)
MyDataAnalyzer$calculateMedian(mongoDBDataset$score)
MyDataAnalyzer$calculateMaximum(mongoDBDataset$score)
MyDataAnalyzer$calculateMinimum(mongoDBDataset$score)
MyDataAnalyzer$calculateMedian(mongoDBDataset$score)
MyDataAnalyzer$calculate1stQuartile(mongoDBDataset$score)
MyDataAnalyzer$calculate3rdQuartile(mongoDBDataset$score)
MyDataAnalyzer$calculateStandardDeviation(mongoDBDataset$score)
MyDataAnalyzer$calculateZScore(mongoDBDataset$score[8]) # keep after mean and standard deviation calculation
# --

# -- Data visualization
MyDataVisualizer$setDataset(mongoDBDataset)
# --

# What functions can be called for testing purposes
# -- Data viewing
# MyDataViewer$setDatasetAndDatasetName(mongoDBDataset, "MongoDB dataset")
# MyDataViewer$viewDataset()
# --

# -- Data analysis
# MyDataAnalyzer$outputNumberOfRows()
# MyDataAnalyzer$outputNumberOfMissingValues()
# MyDataAnalyzer$outputNumberOfColumns()
# MyDataAnalyzer$outputMean()
# MyDataAnalyzer$outputMedian()
# MyDataAnalyzer$outputMaximum()
# MyDataAnalyzer$outputMinimum()
# MyDataAnalyzer$outputMedian()
# MyDataAnalyzer$output1stQuartile()
# MyDataAnalyzer$output3rdQuartile()
# MyDataAnalyzer$outputStandardDeviation()
# MyDataAnalyzer$outputZScore()
# --
