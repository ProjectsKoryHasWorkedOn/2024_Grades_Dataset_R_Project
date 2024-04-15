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
OULADDatasetQuerier <- DatasetQuerier$new()
OULADDataExporter <- DataExporter$new()
# --

# -- Declaration of the names of the CSV files and folder 
csvDirectory <- paste(getwd(), "/import/csv/", sep = "")

csvFileNames <-
  c(
    "assessments.csv",
    "courses.csv",
    "student_assessment.csv",
    "student_info.csv",
    "student_registration.csv",
    "student_vle.csv",
    "vle.csv"
  )
# --


# -- Data loading in
OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[1], sep = ""))
assessmentsTable <-OULADDataLoader$returnDataset()

OULADDataCleaner$setDataset(assessmentsTable)
OULADDataCleaner$setNamesOfColumns(
  c(
    "module_id",
    "presentation_id",
    "assessment_id",
    "assessment_type",
    "assessment_days_since_the_module_began_due_date",
    "assessment_weight"
  )
)
assessmentsTable <- OULADDataCleaner$returnDataset()
# view(assessmentsTable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[2], sep = ""))
coursesTable <- OULADDataLoader$returnDataset()
OULADDataCleaner$setDataset(coursesTable)
OULADDataCleaner$setNamesOfColumns(c(
  "module_id",
  "presentation_id",
  "module_days_it_goes_for"
))
coursesTable <- OULADDataCleaner$returnDataset()
# view(coursesTable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[3], sep = ""))
studentAssessmentTable <- OULADDataLoader$returnDataset()
OULADDataCleaner$setDataset(studentAssessmentTable)
OULADDataCleaner$setNamesOfColumns(
  c(
    "assessment_id",
    "student_id",
    "student_days_it_took_to_submit_assessment",
    "assessment_result_same_as_previous_attempt",
    "student_score"
  )
)

studentAssessmentTable <- OULADDataCleaner$returnDataset()
# view(studentAssessmentTable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[4], sep = ""))
studentInfoTable <- OULADDataLoader$returnDataset()
OULADDataCleaner$setDataset(studentInfoTable)
OULADDataCleaner$setNamesOfColumns(
  c(
    "module_id",
    "presentation_id",
    "student_id",
    "gender",
    "region_student_lived_in_while_taking_the_module",
    "student_highest_education_level_on_entry_to_the_module",
    "index_of_multiple_deprivation_for_a_uk_region",
    "student_age",
    "number_of_times_the_student_has_attempted_this_module",
    "number_of_credits_the_module_is_worth",
    "student_has_a_disability",
    "student_final_result_for_the_module"
  )
)
studentInfoTable <- OULADDataCleaner$returnDataset()
# view(studentInfoTable)



OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[5], sep = ""))
studentRegistrationTable <- OULADDataLoader$returnDataset()
OULADDataCleaner$setDataset(studentRegistrationTable)
OULADDataCleaner$setNamesOfColumns(
  c(
    "module_id",
    "presentation_id",
    "student_id",
    "student_days_it_took_them_to_register_relative_to_the_module_starting_day",
    "student_days_it_took_them_to_unregister_relative_to_the_module_starting_day"
  )
)
studentRegistrationTable <- OULADDataCleaner$returnDataset()
# view(studentRegistrationTable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[6], sep = ""))
studentVLETable <- OULADDataLoader$returnDataset()
OULADDataCleaner$setDataset(studentVLETable)
OULADDataCleaner$setNamesOfColumns(
  c(
    "module_id",
    "presentation_id",
    "student_id",
    "vle_material_id",
    "student_days_it_took_them_to_engage_with_the_vle_material_relative_to_the_module_starting_day",
    "student_times_interacted_with_vle_material"
  )
)
studentVLETable <- OULADDataCleaner$returnDataset()
# view(studentVLETable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[7], sep = ""))
VLETable <- OULADDataLoader$returnDataset()
OULADDataCleaner$setDataset(VLETable)
OULADDataCleaner$setNamesOfColumns(
  c(
    "vle_material_id",
    "module_id",
    "presentation_id",
    "vle_resource_type",
    "vle_week_the_material_is_first_used",
    "vle_week_material_stops_being_used"
  )
)

VLETable <- OULADDataCleaner$returnDataset()
# view(VLETable)
# --
