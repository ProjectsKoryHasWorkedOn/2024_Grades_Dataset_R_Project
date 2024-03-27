# Setup operations for the Mongo DB database 

# -- Declaration of classes that I'll be using to work with the data
MGDBDataLoader <- DataLoader$new()
MGDBDataTransformer <- DataTransformer$new()
MGDBDataSubsetter <- DataSubsetter$new()
MGDBDataAnalyzer <- DataAnalyzer$new()
MGDBDataViewer <- DataViewer$new()
MGDBDataVisualizer <- DataVisualizer$new()
MGDBDataModeler <- DataModeler$new()
# --

# -- Data loading
MGDBDataLoader$setUserCredentials("fran0618", "WhwdV2u7cMmUJuDj")
MGDBDataLoader$setCluster("comp2031-8031")
MGDBDataLoader$setMongoDBCollection("grades", "sample_training")
mongoDBDataset <- MGDBDataLoader$retrieveDataFromMongoDBCollection()
# --

# -- Data transforming
MGDBDataTransformer$setDataset(mongoDBDataset)
MGDBDataTransformer$unnestAColumn("scores")
mongoDBDataset <- MGDBDataTransformer$returnDataset()
# --

# -- Data viewing
MGDBDataViewer$setDatasetAndDatasetName(mongoDBDataset, "MongoDB dataset")
MGDBDataViewer$viewDataset() # Uncomment this line to not view the dataset
# --