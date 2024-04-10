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
    "studentCourseAssessmentInfoTables.csv",
    "studentVLETable.csv",
    "VLETable.csv",
    "studentModulePresentationGradeTable.csv",
    "studentCumulativeGPAsTable.csv"
  )
# --

# -- Data loading in
OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[1], sep = ""))
studentCourseAssessmentInfoTables <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[2], sep = ""))
studentVLETable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[3], sep = ""))
VLETable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[4], sep = ""))
studentModulePresentationGradeTable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[5], sep = ""))
studentCumulativeGPAsTable <- OULADDataLoader$returnDataset()


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


# -- Indicate the ordering of the grades so they're in order when graphing them
studentModulePresentationGradeTable$grade = factor(
  studentModulePresentationGradeTable$grade,
  levels = c("WNF", "F", "P", "Cr", "D", "HD"),
  ordered = TRUE
)
# --

# -- Data viewing
OULADDataViewer$setDatasetAndDatasetName(studentCourseAssessmentInfoTables, "studentCourseAssessmentInfoTables")
OULADDataViewer$viewDataset() # Comment this line to not view the dataset

OULADDataViewer$setDatasetAndDatasetName(studentVLETable, "studentVLETable")
# OULADDataViewer$viewDataset() # Remove the comment on this line to view the dataset

OULADDataViewer$setDatasetAndDatasetName(VLETable, "VLETable")
OULADDataViewer$viewDataset() # Comment this line to not view the dataset
# --


