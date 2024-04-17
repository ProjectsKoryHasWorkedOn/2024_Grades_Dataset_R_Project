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
# --

# -- Cleanup operations for the studentInfoTable in the OULAD database
# Handle wrongly entered age value (55<= should be >55)
OULADDataCleaner$setDataset(studentInfoTable)
OULADDataCleaner$replaceValuesEqualToXWithAValue(8, '55<=', ">55")
studentInfoTable <- OULADDataCleaner$returnDataset()

# Handle poorly entered qualification levels
OULADDataCleaner$setDataset(studentInfoTable)
OULADDataCleaner$replaceValuesEqualToXWithAValue(6, 'No Formal quals', "No recognized qualifications")
studentInfoTable <- OULADDataCleaner$returnDataset()

# Handle wrongly entered IMD band value ('10-20' value is missing a % sign, it should be '10-20%')
OULADDataCleaner$setDataset(studentInfoTable)
OULADDataCleaner$replaceValuesEqualToXWithAValue(7, '10-20', "10-20%")
studentInfoTable <- OULADDataCleaner$returnDataset()





# Handle missing IMD band values
OULADDataChecker$setDataset(studentInfoTable)
OULADDataChecker$calculateWhatUniqueValuesWeHaveInAColumn(7)
whatUniqueValuesWeHaveInIMDBand <-
  OULADDataChecker$returnWhatUniqueValuesWeHaveInAColumn()
# Can see that there are 'NA' values so that's what we'll be dealing with
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

# Get just the subsetOfStudentInfoTable with the regions that have missing values for the IMD value
whichRegionsHaveAMissingValue <-
  subset(
    subsetOfStudentInfoTable,
    is.na(
      subsetOfStudentInfoTable$index_of_multiple_deprivation_for_a_uk_region
    )
  )

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

# Replacing NA values in our studentInfoTable with values in our subsetOfStudentInfoTable
# that now contain some IMD values we've come up with
studentInfoTable$index_of_multiple_deprivation_for_a_uk_region <-
  subsetOfStudentInfoTable$index_of_multiple_deprivation_for_a_uk_region
# --


# -- Cleanup operations for the studentRegistrationTable in the OULAD database
# Clarify that if the date the student unregistered field is empty then this means that
# either the student is still in the course or has completed the course
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
wereMissingValuesFound <-
  OULADDataChecker$returnNumberOfMissingValues()

# courses table and student info table have duplicates, no PK in them

# --

# Drop columns with lots of missing values
OULADDataCleaner$setDataset(VLETable)
OULADDataCleaner$removeJunkColumns(c(5, 6))
VLETable <- OULADDataCleaner$returnDataset()
# --


# -- Merge a number of the tables together
# Wasn't able to merge VLETable and StudentVLETables - Wasn't finishing this operation in a reasonable time on one's laptop

# Merge student assessment table + assessments table
OULADDataSupersetter$setDataset(studentAssessmentTable)
OULADDataSupersetter$setSecondDataset(assessmentsTable)
mergedAssessmentTableAndStudentAssessmentTable <-
  OULADDataSupersetter$mergeTwoTables("assessment_id")

# Merge student assessment table + assessments + student registration table
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTable <-
  merge(
    x = mergedAssessmentTableAndStudentAssessmentTable,
    y = studentRegistrationTable,
    by.x = c("student_id", "module_id", "presentation_id"),
    by.y = c("student_id", "module_id", "presentation_id")
  )

# Merge student assessment table + assessments + student registration + student info table
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoTable <-
  merge(
    x = mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTable,
    y = studentInfoTable,
    by.x = c("student_id", "module_id", "presentation_id"),
    by.y = c("student_id", "module_id", "presentation_id")
  )

# Merge student assessment table + assessments + student registration + student info + courses table
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable <-
  merge(
    x = mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoTable,
    y = coursesTable,
    by.x = c("module_id", "presentation_id"),
    by.y = c("module_id", "presentation_id")
  )
# --

# -- Cleanup operations for the mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable
# Handle missing exam due dates. The end of the last week of the course is the last day of the course. 
# The start of the last week of the course would be days in course - 7
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
# For testing purposes, I added a row that shares 4 IDs to see if my code would detect the duplicate row
# mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable <- rbind(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable, list("AAA", "2013J", 704156, 1752, 18, "No", 67, "TMA", 20, 11, -18, "In/Completed course", "M", "Ireland", "HE Qualification", "90-100%", ">55",0, 120, "N", "Fail", 168))

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

# -- Work out whether the original weighted value even adds up to 100 
expression <-
"SELECT 
  module_id, 
  presentation_id, 
  student_id, 
  SUM(assessment_weight) AS 'sum_assessment_weight',
  CASE 
    WHEN SUM(assessment_weight) != 0 THEN (100 / SUM(assessment_weight)) 
  END 'non_zero_weighting_sum_scale_assessment_weightings_by_this_value',
  CASE
    WHEN SUM(assessment_weight) == 0 THEN COUNT(assessment_weight)
  END 'zero_weighting_sum_number_of_assessments_hundred_divide_by_this_value_for_each_assessment'
FROM 
  mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable
WHERE 
  assessment_type NOT LIKE '%Exam%'
GROUP BY 
  module_id, 
  presentation_id, 
  student_id"


checkingAssessmentWeights <- sqldf(expression)


# -- Putting this alongside the original table
mergingAndFixing <- merge(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable, 
      checkingAssessmentWeights, by = c("module_id","presentation_id", "student_id"),all = T)
# view(mergingAndFixing)

expression <- 
"SELECT 
  module_id,
  presentation_id,
  student_id,
  assessment_id,
  student_score,
  assessment_type,
  assessment_weight,
  sum_assessment_weight,
  non_zero_weighting_sum_scale_assessment_weightings_by_this_value,
  zero_weighting_sum_number_of_assessments_hundred_divide_by_this_value_for_each_assessment
FROM 
  mergingAndFixing"

checkingThisOut <- sqldf(expression)
# view(checkingThisOut)
# --

# -- Creation of a new column that determines the weighted score
hopingThisWorks <-
  checkingThisOut %>%
  mutate(new_assessment_weight = (
    sum_assessment_weight = case_when(
      assessment_type != "Exam" & sum_assessment_weight == 0 ~ 100 / zero_weighting_sum_number_of_assessments_hundred_divide_by_this_value_for_each_assessment,
      assessment_type != "Exam" & sum_assessment_weight != 0 ~ assessment_weight * non_zero_weighting_sum_scale_assessment_weightings_by_this_value,
      assessment_type == "Exam" ~ assessment_weight
      )
  ),
  .after = assessment_weight)
# --
hopingThisWorks <- arrange(hopingThisWorks, student_id)
# view(hopingThisWorks)


# -- Replacing the assessment_weight column with our new calculations for it....
# huh <- anti_join(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable, hopingThisWorks)
# view(huh)

# -- Removing junk columns
OULADDataCleaner$setDataset(hopingThisWorks)
OULADDataCleaner$removeJunkColumns(c(5,6,7,9,10,11))
hopingThisWorks <- OULADDataCleaner$returnDataset()
# view(hopingThisWorks)
# -- Merging, it's right now

mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable <- merge(
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable, 
hopingThisWorks, 
by = c("module_id","presentation_id", "student_id", "assessment_id"),all = T)
# view(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable)

# This was wrong or it at least put it in the wrong order!
#mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable <- arrange(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable, student_id)
#mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable$new_assessment_weight <- hopingThisWorks$new_assessment_weight
#view(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable)
# --


# ---
# Changed from here onwards
# assessment_weight -> new_assessment_weight
# ---

# -- Creation of a new column that determines the weighted score
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable <-
  mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable %>%
  mutate(weighted_score = ((student_score * new_assessment_weight) / 100),
         .after = new_assessment_weight)
view(mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable)
# --

# -- Creation of a new column that contains the difference between the due date and when the student handed in the assignment
mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable <-
  mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable %>%
  mutate(
    difference_between_due_date_and_hand_in_date = (
      assessment_days_since_the_module_began_due_date - student_days_it_took_to_submit_assessment
    ),
    .after = assessment_days_since_the_module_began_due_date
  )
# --

# -- Set how much the exam and other assessment items weigh so they add up to 100%
# For the case where the student does an exam as well as other assessments in a module
# This will make working out the cumulative GPA possible
newExamWeightValue = 0.4 # Exam weighed at 40% for example
newWeightingOfAllOtherAssessmentsValue = 1 - newExamWeightValue # Other assessments weighed at 60% for example

# -- Creation of a new column for the new weight of every assessment type
# For the case where the student does an exam as well as other assessments in a module
addColumnForNewWeightingOfAssessments <-
  mutate(
    mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable,
    assessment_weight_exam_and_other_assessments_done = ifelse(
      assessment_type == "Exam",
      newExamWeightValue * new_assessment_weight,
      newWeightingOfAllOtherAssessmentsValue * new_assessment_weight
    ),
    .after = weighted_score
  )
# view(addColumnForNewWeightingOfAssessments)
# --

# -- Creation of a new column for the new weighted score based on the new weight for every assessment type
# For the case where the student does an exam as well as other assessments in a module
addColumnForNewWeightedScoresOfAssessments <-
  addColumnForNewWeightingOfAssessments %>%
  mutate(
    weighted_score_exam_and_other_assessments_done = ((
      student_score * assessment_weight_exam_and_other_assessments_done
    ) / 100
    ),
    .after = assessment_weight_exam_and_other_assessments_done
  )
# view(addColumnForNewWeightedScoresOfAssessments)
# --

# -- Calculation and creation of a new column for
# - The sum of the weighted scores for each module
# - If student has finished the course
# - If student has taken an exam
expression <-
  'SELECT 
    student_id, 
    module_id, 
    presentation_id, 
    number_of_credits_the_module_is_worth, 
    SUM(weighted_score) 
      AS sum_weighted_score, 
    SUM(weighted_score_exam_and_other_assessments_done) 
      AS sum_weighted_score_exam_and_other_assessments_done, 
    SUM(CASE WHEN assessment_type LIKE \'%Exam%\' THEN 1 ELSE 0 END) 
      AS has_student_taken_an_exam, 
    case when student_final_result_for_the_module LIKE \'%Withdrawn%\' then \'No\' 
      else \'Yes\' end did_student_finish_the_course
  FROM 
      addColumnForNewWeightedScoresOfAssessments 
  GROUP BY student_id, module_id, presentation_id'

workOutTheSumOfTheWeightedScoresAndIfStudentHasTakenAnExamAndIfStudentHasFinishedTheCourse <-
  sqldf(expression)
view(workOutTheSumOfTheWeightedScoresAndIfStudentHasTakenAnExamAndIfStudentHasFinishedTheCourse)

# -- Creation of a new column for the grade a student gets
# - Considering if they withdrew from the course or not
# - Considering if they took an exam or not
addAGradeColumnBasedOnTheNewAssessmentWeighting <-
  workOutTheSumOfTheWeightedScoresAndIfStudentHasTakenAnExamAndIfStudentHasFinishedTheCourse %>%
  mutate(grade = (
    score = case_when(
      did_student_finish_the_course == "No" ~ "WNF",
      did_student_finish_the_course == "Yes" &
        has_student_taken_an_exam > 0 ~ case_when(
          sum_weighted_score_exam_and_other_assessments_done >= 85 ~ "HD",
          sum_weighted_score_exam_and_other_assessments_done < 85 &
            sum_weighted_score_exam_and_other_assessments_done > 74 ~ "D",
          sum_weighted_score_exam_and_other_assessments_done < 75 &
            sum_weighted_score_exam_and_other_assessments_done > 64 ~ "Cr",
          sum_weighted_score_exam_and_other_assessments_done < 65 &
            sum_weighted_score_exam_and_other_assessments_done > 49 ~ "P",
          sum_weighted_score_exam_and_other_assessments_done <= 49 ~ "F"
        ),
      did_student_finish_the_course == "Yes" &
        has_student_taken_an_exam <= 0 ~ case_when(
          sum_weighted_score >= 85 ~ "HD",
          sum_weighted_score < 85 & sum_weighted_score > 74 ~ "D",
          sum_weighted_score < 75 & sum_weighted_score > 64 ~ "Cr",
          sum_weighted_score < 65 & sum_weighted_score > 49 ~ "P",
          sum_weighted_score <= 49 ~ "F"
        )
      
    )
  ),
  .after = did_student_finish_the_course)
# --

view(addAGradeColumnBasedOnTheNewAssessmentWeighting)

# -- Creation of a new column that groups the module ID with the presentation ID
addAGradeColumnBasedOnTheNewAssessmentWeighting <- addAGradeColumnBasedOnTheNewAssessmentWeighting %>%
  mutate(group_ids_together = paste(module_id, presentation_id, sep = ", "), .after = presentation_id) 
# --

# -- Creation of a new column that converts the grade to it's numerical equivalent
addNumericalEquivalentToGradeColumn <-
  addAGradeColumnBasedOnTheNewAssessmentWeighting %>%
  mutate(numerical_grade_equivalent = (
    grade = case_when(
      grade == "HD" ~ 7,
      grade == "D" ~ 6,
      grade == "Cr" ~ 5,
      grade == "P" ~ 4,
      grade == "F" ~ 1.5,
      grade == "WF" ~ NA
    )
  ),
  .after = grade)
# --

# -- Creation of a new column that works out the grade points
expression <-
  'SELECT 
    student_id,
    group_ids_together,
    (numerical_grade_equivalent * number_of_credits_the_module_is_worth) 
      AS grade_points, 
    SUM(number_of_credits_the_module_is_worth) 
      AS course_credits
  FROM 
    addNumericalEquivalentToGradeColumn 
  GROUP BY student_id, group_ids_together'

workOutTheGP <- sqldf(expression)
# --

# -- Creation of the new column that works out the cumulative GPA
expression <-
  'SELECT 
    student_id, 
    ROUND(SUM(grade_points) / SUM(course_credits), 2) 
      AS cumulative_gpa
  FROM 
    workOutTheGP 
  GROUP BY student_id'

workOutTheCGPA <- sqldf(expression)
# --

# -- Merging of the OG table with the new grades that student got for the module 
subsetOfAddAGradeColumnBasedOnTheNewAssessmentWeighting <- addAGradeColumnBasedOnTheNewAssessmentWeighting

OULADDataCleaner$setDataset(subsetOfAddAGradeColumnBasedOnTheNewAssessmentWeighting)
OULADDataCleaner$removeJunkColumns(c(4,5,6,7))

subsetOfAddAGradeColumnBasedOnTheNewAssessmentWeighting <- OULADDataCleaner$returnDataset()

mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable <-
  left_join(
    mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable,
    subsetOfAddAGradeColumnBasedOnTheNewAssessmentWeighting,
    by = join_by(
      "student_id" == "student_id",
      "module_id" == "module_id",
      "presentation_id" == "presentation_id"
    )
  )
# --

# -- Prepare a mini-table for exporting
studentModulePresentationGradeTable <- addAGradeColumnBasedOnTheNewAssessmentWeighting
OULADDataCleaner$setDataset(studentModulePresentationGradeTable)
OULADDataCleaner$removeJunkColumns(c(2, 3, 5, 6, 7, 8, 9))
studentModulePresentationGradeTable <- OULADDataCleaner$returnDataset()

# -- Creation of a new column that converts the grade to it's numerical equivalent
studentModulePresentationGradeTable <-
  studentModulePresentationGradeTable %>%
  mutate(numerical_grade_equivalent = (
    grade = case_when(
      grade == "HD" ~ 7,
      grade == "D" ~ 6,
      grade == "Cr" ~ 5,
      grade == "P" ~ 4,
      grade == "F" ~ 1.5,
      grade == "WF" ~ NA
    )
  ),
  .after = grade)
# --
# --


# -- Add a new column to the table
studentVLETable$master_id <- seq.int(nrow(studentVLETable))

studentVLETable <- studentVLETable %>%
  select(master_id, everything())

# --

# -- Splitting this stupidly large table with 10655280 lines into eight parts
sprintf("Number of lines in full data set: %s", nrow(studentVLETable))

firstSplitExpression <- "
SELECT *
FROM studentVLETable
WHERE master_id BETWEEN 1 AND 1331910"

secondSplitExpression <- "
SELECT *
FROM studentVLETable
WHERE master_id BETWEEN 1331911 AND 2663821"

thirdSplitExpression <- "
SELECT *
FROM studentVLETable
WHERE master_id BETWEEN 2663822 AND 3995732"

fourthSplitExpression <- "
SELECT *
FROM studentVLETable
WHERE master_id BETWEEN 3995733 AND 5327643"


fifthSplitExpression <- "
SELECT *
FROM studentVLETable
WHERE master_id BETWEEN 5327644 AND 6659554"

sixthSplitExpression <- "
SELECT *
FROM studentVLETable
WHERE master_id BETWEEN 6659555 AND 7991465"

seventhSplitExpression <- "
SELECT *
FROM studentVLETable
WHERE master_id BETWEEN 7991466 AND 9323376"

eighthSplitExpression <- "
SELECT *
FROM studentVLETable
WHERE master_id BETWEEN 9323377 AND 10655280"

firstSubsetOfStudentVLETTable <- sqldf(firstSplitExpression)
secondSubsetOfStudentVLETTable <- sqldf(secondSplitExpression)
thirdSubsetOfStudentVLETTable <- sqldf(thirdSplitExpression)
fourthSubsetOfStudentVLETTable <- sqldf(fourthSplitExpression)
fifthSubsetOfStudentVLETTable <- sqldf(fifthSplitExpression)
sixthSubsetOfStudentVLETTable <- sqldf(sixthSplitExpression)
seventhSubsetOfStudentVLETTable <- sqldf(seventhSplitExpression)
eighthSubsetOfStudentVLETTable <- sqldf(eighthSplitExpression)
# --

# -- Write these new files to CSV files
OULADDataExporter$setDataset(studentModulePresentationGradeTable)
OULADDataExporter$writeToCsvFile("studentModulePresentationGradeTable.csv")

OULADDataExporter$setDataset(workOutTheCGPA)
OULADDataExporter$writeToCsvFile("studentCumulativeGPAsTable.csv")

OULADDataExporter$setDataset(
  mergedAssessmentTableAndStudentAssessmentTableAndStudentRegistrationTableAndStudentInfoAndCoursesTable
)
OULADDataExporter$writeToCsvFile("studentCourseAssessmentInfoTables.csv")


OULADDataExporter$setDataset(studentVLETable)
OULADDataExporter$writeToCsvFile("studentVLETable.csv")


OULADDataExporter$setDataset(firstSubsetOfStudentVLETTable)
OULADDataExporter$writeToCsvFile("studentVLETableSubset1.csv")

OULADDataExporter$setDataset(secondSubsetOfStudentVLETTable)
OULADDataExporter$writeToCsvFile("studentVLETableSubset2.csv")

OULADDataExporter$setDataset(thirdSubsetOfStudentVLETTable)
OULADDataExporter$writeToCsvFile("studentVLETableSubset3.csv")

OULADDataExporter$setDataset(fourthSubsetOfStudentVLETTable)
OULADDataExporter$writeToCsvFile("studentVLETableSubset4.csv")

OULADDataExporter$setDataset(fifthSubsetOfStudentVLETTable)
OULADDataExporter$writeToCsvFile("studentVLETableSubset5.csv")

OULADDataExporter$setDataset(sixthSubsetOfStudentVLETTable)
OULADDataExporter$writeToCsvFile("studentVLETableSubset6.csv")

OULADDataExporter$setDataset(seventhSubsetOfStudentVLETTable)
OULADDataExporter$writeToCsvFile("studentVLETableSubset7.csv")

OULADDataExporter$setDataset(eighthSubsetOfStudentVLETTable)
OULADDataExporter$writeToCsvFile("studentVLETableSubset8.csv")

OULADDataExporter$setDataset(VLETable)
OULADDataExporter$writeToCsvFile("VLETable.csv")
# --