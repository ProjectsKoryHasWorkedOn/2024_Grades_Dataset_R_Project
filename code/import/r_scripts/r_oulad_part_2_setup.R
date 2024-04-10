# Setup operations for the OULAD database 

# -- Declaration of classes that I'll be using to work with the data
OULADDataLoader <- DataLoader$new()
OULADDataCleaner <- DataCleaner$new()
OULADDataAnalyzer <- DataAnalyzer$new()
OULADDataViewer <- DataViewer$new()
OULADDataVisualizer <- DataVisualizer$new()
OULADDataModeler <- DataModeler$new()
OULADDataSupersetter <- DataSupersetter$new()
OULADDataChecker <- DataChecker$new()
OULADDataSubsetter <- DataSubsetter$new()
# --

# -- Declaration of the names of the CSV files and folder 
csvDirectory <- paste(getwd(), "/import/csv_after_processing/", sep = "")

csvFileNames <-
  c(
    "student&Course&AssessmentInfoTables.csv",
    "studentVLETable.csv",
    "VLETable.csv"
  )
# --

# -- Data loading in
OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[1], sep = ""))
studentCourseAssessmentInfoTables <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[2], sep = ""))
studentVLETable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[3], sep = ""))
VLETable <- OULADDataLoader$returnDataset()
# --

# -- Data cleanup
OULADDataCleaner$setDataset(studentCourseAssessmentInfoTables)
OULADDataCleaner$removeJunkColumns(1)
studentCourseAssessmentInfoTables <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(studentVLETable)
OULADDataCleaner$removeJunkColumns(1)
studentVLETable <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(VLETable)
OULADDataCleaner$removeJunkColumns(1)
VLETable <- OULADDataCleaner$returnDataset()
# --

# -- Data viewing
OULADDataViewer$setDatasetAndDatasetName(studentCourseAssessmentInfoTables, "student&Course&AssessmentInfoTables")
OULADDataViewer$viewDataset() # Comment this line to not view the dataset

OULADDataViewer$setDatasetAndDatasetName(studentVLETable, "studentVLETable")
# OULADDataViewer$viewDataset() # Comment this line to not view the dataset

OULADDataViewer$setDatasetAndDatasetName(VLETable, "VLETable")
OULADDataViewer$viewDataset() # Comment this line to not view the dataset
# --


