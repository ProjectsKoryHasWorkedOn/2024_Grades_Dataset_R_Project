# Setup operations for the Mongo DB database 

# -- Declaration of classes that I'll be using to work with the data
MGDBDataLoader <- DataLoader$new()
MGDBDataCleaner <- DataCleaner$new()
MGDBDataSubsetter <- DataSubsetter$new()
MGDBDataAnalyzer <- DataAnalyzer$new()
MGDBDataViewer <- DataViewer$new()
MGDBDataVisualizer <- DataVisualizer$new()
MGDBDataModeler <- DataModeler$new()
MGDBDataChecker <- DataChecker$new()
# --

# -- Data loading
MGDBDataLoader$setUserCredentials("fran0618", "WhwdV2u7cMmUJuDj")
MGDBDataLoader$setCluster("comp2031-8031")
MGDBDataLoader$setMongoDBCollection("grades", "sample_training")
mongoDBDataset <- MGDBDataLoader$retrieveDataFromMongoDBCollection()
# --

# -- Data viewing - # Uncomment these lines to view the nested score column
# MGDBDataViewer$setDatasetAndDatasetName(mongoDBDataset, "MongoDB dataset")
# MGDBDataViewer$viewDataset() 
# --

# -- Data cleaning
MGDBDataCleaner$setDataset(mongoDBDataset)
MGDBDataCleaner$unnestAColumn("scores")
mongoDBDataset <- MGDBDataCleaner$returnDataset()

# Addition of a new column that indicates what grade a student received for each assessment item
mongoDBDataset <- mongoDBDataset %>%
  mutate(
    grade = (score = case_when(
      score >= 85 ~ "HD",
      score < 85 & score > 74 ~ "D",
      score < 75 & score > 64 ~ "Cr",
      score < 65 & score > 49 ~ "P",
      score <= 49 ~ "F")),
    .after = score
  )
# --

# -- Data viewing
MGDBDataViewer$setDatasetAndDatasetName(mongoDBDataset, "MongoDB dataset")
MGDBDataViewer$viewDataset() # Comment this line to not view the dataset
# --

