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


# -- Data wrangling
OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[1], sep = ""))
OULADDataLoader$setNamesOfColumns(
  c(
    "module_id",
    "presentation_id",
    "assessment_id",
    "assessment_type",
    "assessment_days_since_the_module_began_due_date",
    "assessment_weight"
  )
)
assessmentsTable <- OULADDataLoader$returnDataset()
# view(assessmentsTable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[2], sep = ""))
OULADDataLoader$setNamesOfColumns(c(
  "module_id",
  "presentation_id",
  "module_days_it_goes_for"
))
coursesTable <- OULADDataLoader$returnDataset()
# view(coursesTable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[3], sep = ""))
OULADDataLoader$setNamesOfColumns(
  c(
    "assessment_id",
    "student_id",
    "student_days_it_took_to_submit_assessment",
    "assessment_result_same_as_previous_attempt",
    "student_score"
  )
)

studentAssessmentTable <- OULADDataLoader$returnDataset()
# view(studentAssessmentTable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[4], sep = ""))
OULADDataLoader$setNamesOfColumns(
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
studentInfoTable <- OULADDataLoader$returnDataset()
# view(studentInfoTable)



OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[5], sep = ""))
OULADDataLoader$setNamesOfColumns(
  c(
    "module_id",
    "presentation_id",
    "student_id",
    "student_days_it_took_them_to_register_relative_to_the_module_starting_day",
    "student_days_it_took_them_to_unregister_relative_to_the_module_starting_day"
  )
)
studentRegistrationTable <- OULADDataLoader$returnDataset()
# view(studentRegistrationTable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[6], sep = ""))
OULADDataLoader$setNamesOfColumns(
  c(
    "module_id",
    "presentation_id",
    "student_id",
    "vle_material_id",
    "student_days_it_took_them_to_engage_with_the_vle_material_relative_to_the_module_starting_day",
    "student_times_interacted_with_vle_material"
  )
)
studentVLETable <- OULADDataLoader$returnDataset()
# view(studentVLETable)

OULADDataLoader$storeDataFromCSVFile(paste(csvDirectory, csvFileNames[7], sep = ""))
OULADDataLoader$setNamesOfColumns(
  c(
    "vle_material_id",
    "module_id",
    "presentation_id",
    "vle_resource_type",
    "vle_week_the_material_is_first_used",
    "vle_week_material_stops_being_used"
  )
)

VLETable <- OULADDataLoader$returnDataset()
# view(VLETable)
# --