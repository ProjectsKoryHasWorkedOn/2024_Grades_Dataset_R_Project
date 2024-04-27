# Setup operations for the OULAD database 

# -- Declaration of classes that I'll be using to work with the data
OULADDataLoader <- DataLoader$new()
OULADDataCleaner <- DataCleaner$new()
OULADDataAnalyzer <- DataAnalyzer$new()
OULADDataViewer <- DataViewer$new()
OULADDataVisualizer <- DataVisualizer$new()
OULADDataModeler <- DataModeler$new()
OULADDataSupersetter <- DataSupersetter$new()
OULADDataSubsetter <- DataSubsetter$new()
OULADDataChecker <- DataChecker$new()
OULADDatasetQuerier <- DatasetQuerier$new()
# --

# -- Declaration of the names of the CSV files and folder 
csvDirectory <- paste(getwd(), "/import/csv_after_processing/", sep = "")

csvFileNames <-
  c(
    "studentCourseAssessmentInfoTables.csv",
    "VLETable.csv",
    "studentModulePresentationGradeTable.csv",
    "studentCumulativeGPAsTable.csv",
    "studentVLETableSubset1.csv",
    "studentVLETableSubset2.csv",
    "studentVLETableSubset3.csv",
    "studentVLETableSubset4.csv",
    "studentVLETableSubset5.csv",
    "studentVLETableSubset6.csv",
    "studentVLETableSubset7.csv",
    "studentVLETableSubset8.csv" # ,
    # "studentVLETable.csv"
  )
# --

# -- Data loading in
OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[1], sep = ""))
studentCourseAssessmentInfoTables <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[2], sep = ""))
VLETable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[3], sep = ""))
studentModulePresentationGradeTable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[4], sep = ""))
studentCumulativeGPAsTable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[5], sep = ""))
subset1OfStudentVLETTable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[6], sep = ""))
subset2OfStudentVLETTable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[7], sep = ""))
subset3OfStudentVLETTable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[8], sep = ""))
subset4OfStudentVLETTable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[9], sep = ""))
subset5OfStudentVLETTable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[10], sep = ""))
subset6OfStudentVLETTable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[11], sep = ""))
subset7OfStudentVLETTable <- OULADDataLoader$returnDataset()

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[12], sep = ""))
subset8OfStudentVLETTable <- OULADDataLoader$returnDataset()

# --

# -- Data cleanup
OULADDataCleaner$setDataset(studentCourseAssessmentInfoTables)
OULADDataCleaner$removeJunkColumns(1)
studentCourseAssessmentInfoTables <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(VLETable)
OULADDataCleaner$removeJunkColumns(1)
VLETable <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(studentModulePresentationGradeTable)
OULADDataCleaner$removeJunkColumns(1)
studentModulePresentationGradeTable <- OULADDataCleaner$returnDataset()





OULADDataCleaner$setDataset(studentCumulativeGPAsTable)
OULADDataCleaner$removeJunkColumns(1)
studentCumulativeGPAsTable <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(subset1OfStudentVLETTable)
OULADDataCleaner$removeJunkColumns(c(1,2))
subset1OfStudentVLETTable <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(subset2OfStudentVLETTable)
OULADDataCleaner$removeJunkColumns(c(1,2))
subset2OfStudentVLETTable <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(subset3OfStudentVLETTable)
OULADDataCleaner$removeJunkColumns(c(1,2))
subset3OfStudentVLETTable <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(subset4OfStudentVLETTable)
OULADDataCleaner$removeJunkColumns(c(1,2))
subset4OfStudentVLETTable <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(subset5OfStudentVLETTable)
OULADDataCleaner$removeJunkColumns(c(1,2))
subset5OfStudentVLETTable <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(subset6OfStudentVLETTable)
OULADDataCleaner$removeJunkColumns(c(1,2))
subset6OfStudentVLETTable <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(subset7OfStudentVLETTable)
OULADDataCleaner$removeJunkColumns(c(1,2))
subset7OfStudentVLETTable <- OULADDataCleaner$returnDataset()

OULADDataCleaner$setDataset(subset8OfStudentVLETTable)
OULADDataCleaner$removeJunkColumns(c(1,2))
subset8OfStudentVLETTable <- OULADDataCleaner$returnDataset()
# --


# -- Indicate the ordering of the grades so they're in order when graphing them
studentModulePresentationGradeTable$grade = factor(
  studentModulePresentationGradeTable$grade,
  levels = c("WNF", "F", "P", "Cr", "D", "HD"),
  ordered = TRUE
)
# --

# -- Indicate the ordering of the education levels so they're in order when graphing them
studentCourseAssessmentInfoTables$student_highest_education_level_on_entry_to_the_module = factor(
  studentCourseAssessmentInfoTables$student_highest_education_level_on_entry_to_the_module,
  levels = c("No recognized qualifications", "Lower Than A Level", "A Level or Equivalent", "HE Qualification", "Post Graduate Qualification")
)

# --


# get total times student interacted with the learning material
OULADDatasetQuerier$setQuery("SELECT 
  student_id, 
  sum(student_times_interacted_with_vle_material) AS 'sum_vle_interaction_times'
FROM 
  subset1OfStudentVLETTable
GROUP BY
  student_id")

subset1OfStudentVLETTableSUM <- OULADDatasetQuerier$returnQueryResultKeepColNames()

OULADDatasetQuerier$setQuery("SELECT 
  student_id, 
  sum(student_times_interacted_with_vle_material) AS 'sum_vle_interaction_times'
FROM 
  subset2OfStudentVLETTable
GROUP BY
  student_id")

subset2OfStudentVLETTableSUM <- OULADDatasetQuerier$returnQueryResultKeepColNames()

OULADDatasetQuerier$setQuery("SELECT 
  student_id, 
  sum(student_times_interacted_with_vle_material) AS 'sum_vle_interaction_times'
FROM 
  subset3OfStudentVLETTable
GROUP BY
  student_id")

subset3OfStudentVLETTableSUM <- OULADDatasetQuerier$returnQueryResultKeepColNames()

OULADDatasetQuerier$setQuery("SELECT 
  student_id, 
  sum(student_times_interacted_with_vle_material) AS 'sum_vle_interaction_times'
FROM 
  subset4OfStudentVLETTable
GROUP BY
  student_id")

subset4OfStudentVLETTableSUM <- OULADDatasetQuerier$returnQueryResultKeepColNames()

OULADDatasetQuerier$setQuery("SELECT 
  student_id, 
  sum(student_times_interacted_with_vle_material) AS 'sum_vle_interaction_times'
FROM 
  subset5OfStudentVLETTable
GROUP BY
  student_id")

subset5OfStudentVLETTableSUM <- OULADDatasetQuerier$returnQueryResultKeepColNames()

OULADDatasetQuerier$setQuery("SELECT 
  student_id, 
  sum(student_times_interacted_with_vle_material) AS 'sum_vle_interaction_times'
FROM 
  subset6OfStudentVLETTable
GROUP BY
  student_id")

subset6OfStudentVLETTableSUM <- OULADDatasetQuerier$returnQueryResultKeepColNames()

OULADDatasetQuerier$setQuery("SELECT 
  student_id, 
  sum(student_times_interacted_with_vle_material) AS 'sum_vle_interaction_times'
FROM 
  subset7OfStudentVLETTable
GROUP BY
  student_id")

subset7OfStudentVLETTableSUM <- OULADDatasetQuerier$returnQueryResultKeepColNames()


OULADDatasetQuerier$setQuery("SELECT 
  student_id, 
  sum(student_times_interacted_with_vle_material) AS 'sum_vle_interaction_times'
FROM 
  subset8OfStudentVLETTable
GROUP BY
  student_id")

subset8OfStudentVLETTableSUM <- OULADDatasetQuerier$returnQueryResultKeepColNames()


# -- Merging the subsets
mergedSubsetSums <- do.call("rbind", list(
  subset1OfStudentVLETTableSUM, 
  subset2OfStudentVLETTableSUM,
  subset3OfStudentVLETTableSUM,
  subset4OfStudentVLETTableSUM,
  subset5OfStudentVLETTableSUM,
  subset6OfStudentVLETTableSUM,
  subset7OfStudentVLETTableSUM,
  subset8OfStudentVLETTableSUM
  ))

OULADDatasetQuerier$setQuery("SELECT student_id, SUM(sum_vle_interaction_times) AS 'sum_vle_interaction_times'
FROM mergedSubsetSums
GROUP BY student_id")

fixedUpMergedSubsetSums <- OULADDatasetQuerier$returnQueryResultKeepColNames()

# --

# -- Data viewing
OULADDataViewer$setDatasetAndDatasetName(studentCourseAssessmentInfoTables, "studentCourseAssessmentInfoTables")
# OULADDataViewer$viewDataset() # Comment this line to not view the dataset

# OULADDataViewer$setDatasetAndDatasetName(studentVLETable, "studentVLETable")
# OULADDataViewer$viewDataset() # Remove the comment on this line to view the dataset

OULADDataViewer$setDatasetAndDatasetName(VLETable, "VLETable")
# OULADDataViewer$viewDataset() # Comment this line to not view the dataset
# --


