# What files I share between both R project files
# -- Make sure it searches from directory of "oalad_dataset_main.R"
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# --

# -- Import a file that installs and loads the needed libraries
source(file = paste(getwd(), "/import/r_scripts/r_libraries.R", sep = ""))
# --

# -- Import a file that incorporates the needed classes
source(file = paste(getwd(), "/import/r_scripts/r_classes.R", sep = ""))
# --


# What I've done to the OULAD dataset
# -- Data wrangling and transformation
# source(file = paste(getwd(), "/import/r_scripts/r_oulad_set_up.R", sep = ""))
# --


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
# change to y or n for banked
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


# -- Data analysis 
# Checking for duplicate IDs for PKs
# Worked out PKs through looking at the tables
OULADDataAnalyzer$setDataset(assessmentsTable)
OULADDataAnalyzer$checkForDuplicateValues(3) # assessment_id
export_01_0001 <- OULADDataAnalyzer$returnIfDuplicateValuesWereFound()

OULADDataAnalyzer$setDataset(VLETable)
OULADDataAnalyzer$checkForDuplicateValues(4) # vle_material_id
export_01_0002 <- OULADDataAnalyzer$returnIfDuplicateValuesWereFound()

OULADDataAnalyzer$setDataset(studentInfoTable)
OULADDataAnalyzer$checkForDuplicateValues(3) # student_id
export_01_0003 <- OULADDataAnalyzer$returnIfDuplicateValuesWereFound()
# --

# -- Data transformation
OULADDataTransformer$setDataset(studentAssessmentTable)
OULADDataTransformer$setSecondDataset(assessmentsTable)

mergedAssessmentTableAndStudentAssessmentTable <- OULADDataTransformer$mergeTwoTables("assessment_id")

view(mergedAssessmentTableAndStudentAssessmentTable)



# avoid doing i guess - .x, .y
#OULADDataTransformer$setDataset(mergedAssessmentTableAndStudentAssessmentTable)
#OULADDataTransformer$setSecondDataset(studentRegistrationTable)

#mergedAssessmentTableAndStudentAssessmentAndStudentRegistrationTableTable <- OULADDataTransformer$mergeTwoTables("student_id")

#view(mergedAssessmentTableAndStudentAssessmentAndStudentRegistrationTableTable)

# ask why module_id.x, module_id.y and presentation_id.x, presentation_id.y



# avoid doing i guess - very slow
#OULADDataTransformer$setDataset(studentVLETable)
#OULADDataTransformer$setSecondDataset(VLETable)

#mergedStudentVLEandVLETable <- OULADDataTransformer$mergeTwoTables("vle_material_id")

#view(mergedStudentVLEandVLETable)

# --


#check for duplicates

#remove duplicates

# -- Data transforming
OULADDataTransformer$setDataset(studentInfoTable)
# OULADDataTransformer$correctAges(8)
studentInfoTable <- OULADDataTransformer$returnDataset()
# view(studentInfoTable)
# --


