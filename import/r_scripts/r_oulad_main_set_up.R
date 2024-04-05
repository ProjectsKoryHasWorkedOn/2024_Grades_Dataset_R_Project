# Setup operations for the OULAD database 

# -- Declaration of classes that I'll be using to work with the data
OULADDataLoader <- DataLoader$new()
OULADDataTransformer <- DataTransformer$new()
OULADDataAnalyzer <- DataAnalyzer$new()
OULADDataViewer <- DataViewer$new()
OULADDataVisualizer <- DataVisualizer$new()
OULADDataModeler <- DataModeler$new()
# --

# -- Declaration of the names of the CSV files and folder 
csvDirectory <- paste(getwd(), "/import/csv_after_processing/", sep = "")

csvFileNames <-
  c(
    "mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable.csv",
    "studentVLETable.csv",
    "VLETable.csv"
  )
# --

# -- Data wrangling
OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[1], sep = ""))
mergeOfAllButTwoTables <- OULADDataLoader$returnDataset()
# view(mergeOfAllButTwoTables)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[2], sep = ""))
studentVLETable <- OULADDataLoader$returnDataset()
# view(studentVLETable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[3], sep = ""))
VLETable <- OULADDataLoader$returnDataset()
# view(VLETable)

