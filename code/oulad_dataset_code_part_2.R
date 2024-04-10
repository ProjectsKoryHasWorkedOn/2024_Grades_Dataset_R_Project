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
source(file = paste(getwd(), "/import/r_scripts/r_oulad_part_2_setup.R", sep = ""))
# --

# Get number of enrolled students, modules, number of students that withdraw vs don't, ...



# Work out the difference between the due date and when the student handed in the assignment
studentCourseAssessmentInfoTables <- studentCourseAssessmentInfoTables %>%
  mutate(
    difference_between_due_date_and_hand_in_date = (assessment_days_since_the_module_began_due_date - student_days_it_took_to_submit_assessment),
    .after = assessment_days_since_the_module_began_due_date
  )
# view(studentCourseAssessmentInfoTables)

# --

genderColors <- c("pink", "royalblue")

# -- Hand in date visualizations 
ggplot(studentCourseAssessmentInfoTables,
       aes(x = difference_between_due_date_and_hand_in_date, fill = gender)) + scale_fill_manual(values=genderColors) + facet_wrap(~ gender) + geom_density() + labs(title = "Comparison between the sexes", subtitle = "Who hands in work faster", x = "Difference between the due date and hand in date")
# --

# -- Score visualizations

ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, fill = gender)) + scale_fill_manual(values=genderColors) + facet_wrap(~ gender) + geom_violin()

ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, fill = student_has_a_disability)) + facet_wrap(~ student_has_a_disability) + geom_violin()


ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, fill = student_age)) + facet_wrap(~ student_age) + geom_violin()



ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, fill = index_of_multiple_deprivation_for_a_uk_region)) + facet_grid(~ index_of_multiple_deprivation_for_a_uk_region) + geom_violin() +labs(fill="IMD band") +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
# --


newExamWeightValue = 0.4 # 40%
newWeightingOfAllOtherAssessmentsValue = 1 - newExamWeightValue

addColumnForNewWeightingOfAssessments <- mutate(studentCourseAssessmentInfoTables, assessment_weight_exam_and_other_assessments_done = ifelse(assessment_type == "Exam", newExamWeightValue * assessment_weight, newWeightingOfAllOtherAssessmentsValue * assessment_weight), .after = weighted_score)

addColumnForNewWeightedScoresOfAssessments <- addColumnForNewWeightingOfAssessments %>%
  mutate(
    weighted_score_exam_and_other_assessments_done = ((student_score * assessment_weight_exam_and_other_assessments_done)/100),
    .after = assessment_weight_exam_and_other_assessments_done
  )



expression <- 'SELECT student_id, module_id, presentation_id, number_of_credits_the_module_is_worth, SUM(weighted_score) AS sum_weighted_score, SUM(weighted_score_exam_and_other_assessments_done) AS sum_weighted_score_exam_and_other_assessments_done, SUM(CASE WHEN assessment_type LIKE \'%Exam%\' THEN 1 ELSE 0 END) AS has_student_taken_an_exam, case when student_final_result_for_the_module LIKE \'%Withdrawn%\' then \'No\' else \'Yes\' end did_student_finish_the_course 
FROM addColumnForNewWeightedScoresOfAssessments GROUP BY student_id, module_id, presentation_id'

workOutTheSumOfTheWeightedScoresAndIfStudentHasTakenAnExamAndIfStudentHasFinishedTheCourse <- sqldf(expression)
# view(workOutTheSumOfTheWeightedScoresAndIfStudentHasTakenAnExamAndIfStudentHasFinishedTheCourse)

addAGradeColumnBasedOnTheNewAssessmentWeighting <- workOutTheSumOfTheWeightedScoresAndIfStudentHasTakenAnExamAndIfStudentHasFinishedTheCourse %>%
  mutate(
    grade = (score = case_when(
      did_student_finish_the_course == "No" ~ "WNF",
      did_student_finish_the_course == "Yes" & has_student_taken_an_exam > 0 ~ case_when(
        sum_weighted_score_exam_and_other_assessments_done >= 85 ~ "HD",
        sum_weighted_score_exam_and_other_assessments_done < 85 & sum_weighted_score_exam_and_other_assessments_done > 74 ~ "D",
        sum_weighted_score_exam_and_other_assessments_done < 75 & sum_weighted_score_exam_and_other_assessments_done > 64 ~ "Cr",
        sum_weighted_score_exam_and_other_assessments_done < 65 & sum_weighted_score_exam_and_other_assessments_done > 49 ~ "P",
        sum_weighted_score_exam_and_other_assessments_done <= 49 ~ "F"
      ),
      did_student_finish_the_course == "Yes" & has_student_taken_an_exam <= 0 ~ case_when(
        sum_weighted_score >= 85 ~ "HD",
        sum_weighted_score < 85 & sum_weighted_score > 74 ~ "D",
        sum_weighted_score < 75 & sum_weighted_score > 64 ~ "Cr",
        sum_weighted_score < 65 & sum_weighted_score > 49 ~ "P",
        sum_weighted_score <= 49 ~ "F"
      )
      
      )),
    .after = did_student_finish_the_course
  )






# bar graph of scores


addAGradeColumnBasedOnTheNewAssessmentWeighting$grade = factor(addAGradeColumnBasedOnTheNewAssessmentWeighting$grade, levels = c("WNF", "F", "P", "Cr", "D", "HD"), ordered = TRUE)


colorsToUseForBars <- c("WNF" = "#231c35", "F" = "#ef476f", P = "#f78104", "Cr" = "#faab36", "D" = "#a8e8f9", "HD" = "#39b89a")
colorsUsedForBars <- c(colorsToUseForBars[[1]], colorsToUseForBars[[2]], colorsToUseForBars[[3]], colorsToUseForBars[[4]], colorsToUseForBars[[5]], colorsToUseForBars[[6]])


OULADDataVisualizer$calculateInvertedColors(6, colorsUsedForBars)
colorsToUseForLabels <- OULADDataVisualizer$returnColorsFound()


addAGradeColumnBasedOnTheNewAssessmentWeighting <- addAGradeColumnBasedOnTheNewAssessmentWeighting %>%
  mutate(group_ids_together = paste(module_id, presentation_id, sep = ", "), .after = presentation_id) 
view(addAGradeColumnBasedOnTheNewAssessmentWeighting)


# numberOfCombinations = n_distinct(addAGradeColumnBasedOnTheNewAssessmentWeighting$group_ids_together)
numberOfCombinations = 19

colorsToUseForLabels <- rep(colorsToUseForLabels, times = numberOfCombinations)
colorsToUseForLabels

colorsToUseForLabels <- c(colorsToUseForLabels, colorsToUseForLabels[1], colorsToUseForLabels[2], colorsToUseForLabels[1], colorsToUseForLabels[2], colorsToUseForLabels[1], colorsToUseForLabels[2])
colorsToUseForLabels

ggplot(addAGradeColumnBasedOnTheNewAssessmentWeighting, aes(x = grade, fill = grade)) + scale_fill_manual("grade", values = c(colorsToUseForBars)) + facet_wrap(~ group_ids_together) + geom_bar() + geom_text(stat='count', aes(label=..count..), color = colorsToUseForLabels, vjust = "inward")

# , color = colorsToUseForLabels

# Get percentage of students that had each result



addNumericalEquivalentToGradeColumn <- addAGradeColumnBasedOnTheNewAssessmentWeighting %>%
  mutate(
    numerical_grade_equivalent = (grade = case_when(
      grade == "HD" ~ 7,
      grade == "D" ~ 6,
      grade == "Cr" ~ 5,
      grade == "P" ~ 4,
      grade == "F" ~ 1.5,
      grade == "WF" ~ NA)),
    .after = grade
  )

view(addNumericalEquivalentToGradeColumn)

# Get the "cumulative GPA"


# Grade in course x Credits earned in course = Grade Points


# Total grade points / total credits = cumulative grade point average



expression <- 'SELECT student_id, group_ids_together, (numerical_grade_equivalent * number_of_credits_the_module_is_worth) AS grade_points, SUM(number_of_credits_the_module_is_worth) AS course_credits
FROM addNumericalEquivalentToGradeColumn GROUP BY student_id, group_ids_together'

workOutTheGP <- sqldf(expression)

expression <- 'SELECT student_id, ROUND(SUM(grade_points) / SUM(course_credits), 2) AS cumulative_gpa
FROM workOutTheGP GROUP BY student_id'

workOutTheCGPA <- sqldf(expression)

view(workOutTheCGPA)



# ------- Histogram with 7 bins for the CGPA

ggplot(workOutTheCGPA, aes(fill = factor(round(cumulative_gpa, 0)), 
x=round(cumulative_gpa, 0))) + 
  geom_bar(stat="count", position = "stack") + 
  labs(title = "Student cumulative GPAs", fill = "GPA range", x = "Student GPAs") + 
  scale_x_continuous(breaks=0:7) + geom_text(stat='count', aes(label=paste(..count.., "\n", "(", round(((..count..)/sum(..count..))*100, 2), "%", ")" , sep = ""), vjust = "inward"))


# ---------------



# ---------------

studentCourseAssessmentInfoTables <- left_join(studentCourseAssessmentInfoTables, addAGradeColumnBasedOnTheNewAssessmentWeighting, by = join_by("student_id" == "student_id", "module_id" == "module_id", "presentation_id" == "presentation_id")) 
# view(studentCourseAssessmentInfoTables)

# remove junk columns, add our new grade column
OULADDataCleaner$setDataset(studentCourseAssessmentInfoTables)
OULADDataCleaner$removeJunkColumns(c(11, 12, 14, 22, 23, 25, 26, 27))
studentCourseAssessmentInfoTables <- OULADDataCleaner$returnDataset()

# view(studentCourseAssessmentInfoTables)

