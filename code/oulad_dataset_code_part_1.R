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
source(file = paste(getwd(), "/import/r_scripts/r_oulad_part_1_setup.R", sep = ""))
# --

# -- Cleanup operations for the studentAssessmentTable in the OULAD database
# Replace missing scores in student assessment table with 0
OULADDataCleaner$setDataset(studentAssessmentTable)
OULADDataCleaner$replaceMissingValueWithAValue(5, 0)
studentAssessmentTable <- OULADDataCleaner$returnDataset()


# Change 0/1 values in the student assessment table to No/Yes for if result is transferred from a previous presentation
OULADDataCleaner$setDataset(studentAssessmentTable)
OULADDataCleaner$replaceValuesEqualToXWithAValueAndNotEqualToXWithAnotherValue(4, 1, 'Yes', 'No')
studentAssessmentTable <- OULADDataCleaner$returnDataset()

# See if those changes worked
# view(studentAssessmentTable)
# --


# -- Cleanup operations for the studentInfoTable in the OULAD database
# Handle wrongly entered age value (55<= should be >55)
OULADDataCleaner$setDataset(studentInfoTable)
OULADDataCleaner$replaceValuesEqualToXWithAValue(8, '55<=', ">55")
studentInfoTable <- OULADDataCleaner$returnDataset()

# Handle wrongly entered IMD band value (missing % sign for 10-20)
OULADDataCleaner$setDataset(studentInfoTable)
OULADDataCleaner$replaceValuesEqualToXWithAValue(7, '10-20', "10-20%")
studentInfoTable <- OULADDataCleaner$returnDataset()


# Handle missing IMD band values
OULADDataChecker$setDataset(studentInfoTable)
OULADDataChecker$calculateWhatUniqueValuesWeHaveInAColumn(7)
whatUniqueValuesWeHaveInIMDBand <-
  OULADDataChecker$returnWhatUniqueValuesWeHaveInAColumn()
# Get a list of what unique values we have for the IMD band values
# [1] "90-100%" "20-30%"  "30-40%"  "50-60%"  "80-90%"  "70-80%"  NA        "60-70%"  "40-50%"  "10-20%"  "0-10%"

# Return what the most common IMD band value is for ONE particular region
returnMostCommonIMDBandValue <- function(regionArg) {
  ZeroToTen <-
    sum(
      str_count(
        regionArg$index_of_multiple_deprivation_for_a_uk_region,
        pattern = '0-10%'
      ),
      na.rm = TRUE
    )
  TenToTwenty <-
    sum(
      str_count(
        regionArg$index_of_multiple_deprivation_for_a_uk_region,
        pattern = '10-20%'
      ),
      na.rm = TRUE
    )
  TwentyToThirty <-
    sum(
      str_count(
        regionArg$index_of_multiple_deprivation_for_a_uk_region,
        pattern = '20-30%'
      ),
      na.rm = TRUE
    )
  ThirtyToFourty <-
    sum(
      str_count(
        regionArg$index_of_multiple_deprivation_for_a_uk_region,
        pattern = '30-40%'
      ),
      na.rm = TRUE
    )
  FourtyToFifty <-
    sum(
      str_count(
        regionArg$index_of_multiple_deprivation_for_a_uk_region,
        pattern = '40-50%'
      ),
      na.rm = TRUE
    )
  FiftyToSixty <-
    sum(
      str_count(
        regionArg$index_of_multiple_deprivation_for_a_uk_region,
        pattern = '50-60%'
      ),
      na.rm = TRUE
    )
  SixtyToSeventy <-
    sum(
      str_count(
        regionArg$index_of_multiple_deprivation_for_a_uk_region,
        pattern = '60-70%'
      ),
      na.rm = TRUE
    )
  SeventyToEighty <-
    sum(
      str_count(
        regionArg$index_of_multiple_deprivation_for_a_uk_region,
        pattern = '70-80%'
      ),
      na.rm = TRUE
    )
  EightyToNinety <-
    sum(
      str_count(
        regionArg$index_of_multiple_deprivation_for_a_uk_region,
        pattern = '90-100%'
      ),
      na.rm = TRUE
    )
  NinetyToHundred <-
    sum(
      str_count(
        regionArg$index_of_multiple_deprivation_for_a_uk_region,
        pattern = '0-10%'
      ),
      na.rm = TRUE
    )
  
  AllTheValues <-
    c(
      ZeroToTen,
      TenToTwenty,
      TwentyToThirty,
      ThirtyToFourty,
      FourtyToFifty,
      FiftyToSixty,
      SixtyToSeventy,
      SeventyToEighty,
      EightyToNinety,
      NinetyToHundred
    )
  
  theBiggestOne <- which.max(AllTheValues)
  returnValue <- switch(
    theBiggestOne,
    '0-10%',
    '10-20%',
    '20-30%',
    '30-40%',
    '40-50%',
    '50-60%',
    '60-70%',
    '70-80%',
    '80-90%',
    '90-100%'
  )
  
  return(returnValue)
}

# Return a list of the most common IMD values for A LIST OF regions
returnMostCommonIMDValuesForAListOfRegions <-
  function(tableArg, regionsArg, numberOfRegionsArg) {
    whatIsMostCommonOne = 0
    
    for (x in 1:numberOfRegionsArg) {
      currentRegion <-
        filter(tableArg,
               region_student_lived_in_while_taking_the_module == regionsArg[x])
      whatIsMostCommonOne[x] <-
        returnMostCommonIMDBandValue(currentRegion)
    }
    
    return(whatIsMostCommonOne)
    
  }

# Get just the studentInfoTable with the columns of interest to us
subsetOfStudentInfoTable <-
  select(
    studentInfoTable,
    student_id,
    region_student_lived_in_while_taking_the_module,
    index_of_multiple_deprivation_for_a_uk_region
  )
# view(subsetOfStudentInfoTable)

# Get just the subsetOfStudentInfoTable with the regions that have missing values for the IMD value
whichRegionsHaveAMissingValue <-
  subset(
    subsetOfStudentInfoTable,
    is.na(
      subsetOfStudentInfoTable$index_of_multiple_deprivation_for_a_uk_region
    )
  )
# view(whichRegionsHaveAMissingValue)

# Get the names of the regions that have missing values for the IMD value
OULADDataChecker$setDataset(whichRegionsHaveAMissingValue)
OULADDataChecker$calculateWhatUniqueValuesWeHaveInAColumn(2)
whatAreTheNamesOfTheseRegions <-
  OULADDataChecker$returnWhatUniqueValuesWeHaveInAColumn()

# Get the number of regions that have missing values for the IMD value
whatIsTheNumberOfTheseRegions = length(whatAreTheNamesOfTheseRegions[[1]])

# Get the common IMD value for regions that have missing values for the IMD value
mostCommonOnes <-
  returnMostCommonIMDValuesForAListOfRegions(
    subsetOfStudentInfoTable,
    whatAreTheNamesOfTheseRegions[[1]],
    whatIsTheNumberOfTheseRegions
  )
names(mostCommonOnes) <- whatAreTheNamesOfTheseRegions[[1]]

# Replace missing IMD values with the name of the region
subsetOfStudentInfoTable$index_of_multiple_deprivation_for_a_uk_region <-
  ifelse(
    is.na(
      subsetOfStudentInfoTable$index_of_multiple_deprivation_for_a_uk_region
    ),
    subsetOfStudentInfoTable$region_student_lived_in_while_taking_the_module,
    subsetOfStudentInfoTable$index_of_multiple_deprivation_for_a_uk_region
  )
# view(subsetOfStudentInfoTable)

# Replace the names of the region with the most common IMD value in that region
for (i in 1:nrow(subsetOfStudentInfoTable)) {
  currentValue <-
    subsetOfStudentInfoTable$index_of_multiple_deprivation_for_a_uk_region[i]
  
  if (currentValue %in% names(mostCommonOnes)) {
    indexValue <- which(currentValue == names(mostCommonOnes))
    subsetOfStudentInfoTable$index_of_multiple_deprivation_for_a_uk_region[i] <-
      mostCommonOnes[indexValue]
  }
}

# view(subsetOfStudentInfoTable)


# Replacing NA values in our studentInfoTable with values in our subsetOfStudentInfoTable that now contain some IMD values we've come up with
studentInfoTable$index_of_multiple_deprivation_for_a_uk_region <-
  subsetOfStudentInfoTable$index_of_multiple_deprivation_for_a_uk_region

# See if those changes worked
# view(studentInfoTable)
# --


# -- Cleanup operations for the studentRegistrationTable in the OULAD database
# Clarify that if the date the student unregistered field is empty then this means that either the student is still in the course or has completed the course
studentRegistrationTable$student_days_it_took_them_to_unregister_relative_to_the_module_starting_day <-
  replace(
    studentRegistrationTable$student_days_it_took_them_to_unregister_relative_to_the_module_starting_day,
    is.na(
      studentRegistrationTable$student_days_it_took_them_to_unregister_relative_to_the_module_starting_day
    ),
    "In/Completed course"
  )

# Make it so if the day the student registered into the course is missing, it is on the day the course started
studentRegistrationTable$student_days_it_took_them_to_register_relative_to_the_module_starting_day <-
  replace(
    studentRegistrationTable$student_days_it_took_them_to_register_relative_to_the_module_starting_day,
    is.na(
      studentRegistrationTable$student_days_it_took_them_to_register_relative_to_the_module_starting_day
    ),
    0
  )

# See if those changes worked
# view(studentRegistrationTable)
# --

# -- Data checking
# Checking for duplicate IDs for PKs
# Worked out PKs through looking at the tables
OULADDataChecker$setDataset(assessmentsTable)
OULADDataChecker$checkForDuplicateValues(3) # assessment_id
wereDuplicateAssessmentIDsFound <-
  OULADDataChecker$returnIfDuplicateValuesWereFound()

OULADDataChecker$setDataset(VLETable)
OULADDataChecker$checkForDuplicateValues(1) # vle_material_id
wereDuplicateVLEMaterialIDsFound <-
  OULADDataChecker$returnIfDuplicateValuesWereFound()

OULADDataChecker$calculateNumberOfMissingValues()
wereMissingValuesFound <- OULADDataChecker$returnNumberOfMissingValues()

# courses table and student info table have duplicates, no PK in them

# --

# Drop column with lots of missing values
OULADDataCleaner$setDataset(VLETable)
OULADDataCleaner$removeJunkColumns(c(5,6))
VLETable <- OULADDataCleaner$returnDataset()
# view(VLETable)
# --

# -- Merge a number of the tables together
# Wasn't able to merge VLETable and StudentVLETables - Wasn't finishing this operation in a reasonable time on one's laptop

# Merge student assessment table + assessments table
OULADDataSupersetter$setDataset(studentAssessmentTable)
OULADDataSupersetter$setSecondDataset(assessmentsTable)
mergedAssessmentTableAndStudentAssessmentTable <-
  OULADDataSupersetter$mergeTwoTables("assessment_id")
# view(mergedAssessmentTableAndStudentAssessmentTable)

# Merge student assessment table + assessments + student registration table
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTable <-
  merge(
    x = mergedAssessmentTableAndStudentAssessmentTable,
    y = studentRegistrationTable,
    by.x = c("student_id", "module_id", "presentation_id"),
    by.y = c("student_id", "module_id", "presentation_id")
  )
# view(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTable)


# Merge student assessment table + assessments + student registration + student info table
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoTable <-
  merge(
    x = mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTable,
    y = studentInfoTable,
    by.x = c("student_id", "module_id", "presentation_id"),
    by.y = c("student_id", "module_id", "presentation_id")
  )
# view(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoTable)


# Merge student assessment table + assessments + student registration + student info + courses table
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable <-
  merge(
    x = mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoTable,
    y = coursesTable,
    by.x = c("module_id", "presentation_id"),
    by.y = c("module_id", "presentation_id")
  )

# view(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable)
# --

# -- Cleanup operations for the mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable in the OULAD database
# Handle missing exam due dates. The end of the last week of the course is the last day of the course. The start of the last week of the course would be days in course - 7
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable$assessment_days_since_the_module_began_due_date <-
  ifelse(
    is.na(
      mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable$assessment_days_since_the_module_began_due_date
    ),
    mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable$module_days_it_goes_for,
    mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable$assessment_days_since_the_module_began_due_date
  )
# --


# -- Data checking
# Check that at least one of student_id, assessment_id, presentation_id, and module_id in the same row is unique
# For testing purposes, we can add a row that shares 4 IDs
# mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable <- rbind(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable, list("AAA", "2013J", 704156, 1752, 18, "No", 67, "TMA", 20, 11, -18, "In/Completed course", "M", "Ireland", "HE Qualification", "90-100%", ">55",0, 120, "N", "Fail", 168))
# view(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable)

# Return a list of rows that share 4 IDs
output <-
  group_by(
    mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable,
    student_id,
    assessment_id,
    presentation_id,
    module_id
  ) %>% filter(n() > 1)

numberOfRowsThatShare4IDS <- nrow(output)
# --

# -- Creation of a new column
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable <- mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable %>%
  mutate(
    weighted_score = ((student_score * assessment_weight)/100),
    .after = assessment_weight
  )
# view(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable)

# --


# -- Write these new files to CSV files
OULADDataExporter$setDataset(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable)
OULADDataExporter$writeToCsvFile("student&Course&AssessmentInfoTables.csv") #Uncomment this line to write the file

OULADDataExporter$setDataset(studentVLETable)
OULADDataExporter$writeToCsvFile("studentVLETable.csv") #Uncomment this line to write the file

OULADDataExporter$setDataset(VLETable)
OULADDataExporter$writeToCsvFile("VLETable.csv") #Uncomment this line to write the file
# --

