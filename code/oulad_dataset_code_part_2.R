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

# -- Error in .Call.graphics(C_palette2, .Call(C_palette2, NULL)) : 
# invalid graphics state
# reload R

# -- Density plot of assessment hand in times 
ggplot(studentCourseAssessmentInfoTables,
       aes(x = difference_between_due_date_and_hand_in_date)) + geom_density(alpha = 0.1, position = "identity") + labs(title = "Seeing when most students hand in their work", x = "Difference between the due date and hand in date")  + theme_classic()

# Found that what's depicted didn't change too much with age, disability, gender, or IMD band
# --


# Get number of enrolled students, modules, number of students that withdraw vs don't, ...
genderColors <- c("pink", "royalblue")



# -- Violin plot of if gender affects student scores
ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, color = gender)) + scale_color_manual(values=genderColors) + geom_violin(alpha = 0.5, position = "identity") + theme_classic() + labs(title = "Comparison between the sexes", subtitle = "Who scores better", y = "Student scores", x = NULL, color = "Gender of student") + scale_x_discrete(labels = NULL, breaks = NULL) 
# --

# -- Violin plot of if disability affects student scores
ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, color = student_has_a_disability))  + geom_violin(alpha = 0.5, position = "identity") + theme_classic() + labs(title = "Comparison between the disabled and abled", subtitle = "Who scores better", y = "Student scores", x = NULL, color = "Student is disabled") + scale_x_discrete(labels = NULL, breaks = NULL)
# --

# -- Violin plot of if age affects student scores
ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, fill = student_age)) + facet_wrap(~ student_age) + geom_violin() + labs(title = "Comparison between the age groups", subtitle = "Who scores better", y = "Student scores", x = NULL) + scale_x_discrete(labels = NULL, breaks = NULL)
# --

# -- Violin plot of if the IMD band affects student scores
ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, fill = index_of_multiple_deprivation_for_a_uk_region)) + facet_grid(~ index_of_multiple_deprivation_for_a_uk_region) + geom_violin() +labs(fill="IMD band") +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())  + labs(title = "Comparison between index of multiple deprivation bands", subtitle = "Does being disadvantaged affect student scores", y = "Student scores", x = NULL) 
# --

# -- Bar plot of scores students received for each of the module + presentation combinations
colorsToUseForBars <- c("WNF" = "#7d6b6b", "F" = "#ef476f", P = "#f78104", "Cr" = "#faab36", "D" = "#a8e8f9", "HD" = "#39b89a")
colorsUsedForBars <- c(colorsToUseForBars[[1]], colorsToUseForBars[[2]], colorsToUseForBars[[3]], colorsToUseForBars[[4]], colorsToUseForBars[[5]], colorsToUseForBars[[6]])

OULADDataVisualizer$calculateInvertedColors(6, colorsUsedForBars)
colorsToUseForLabels <- OULADDataVisualizer$returnColorsFound()

numberOfCombinations = n_distinct(studentModulePresentationGradeTable$group_ids_together)
numberOfCombinations

colorsToUseForLabels <- rep(colorsToUseForLabels, times = numberOfCombinations)
colorsToUseForLabels
# Can also append manually if there aren't 4 bars with labels in each combination
# colorsToUseForLabels <- c(colorsToUseForLabels, colorsToUseForLabels[1], colorsToUseForLabels[2], colorsToUseForLabels[1], colorsToUseForLabels[2], colorsToUseForLabels[1], colorsToUseForLabels[2])


ggplot(studentModulePresentationGradeTable, aes(x = grade, fill = grade)) + scale_fill_manual("Grades", values = c(colorsToUseForBars)) + facet_wrap(~ group_ids_together) + geom_bar() + geom_text(stat='count', aes(label=..count..), color = colorsToUseForLabels, vjust = "inward") + labs(title = "Student results", subtitle = "For each module & presentation", y = "Count", x = "Student grades")



# --

# -- Student cumulative GPA bar chart
ggplot(studentCumulativeGPAsTable, aes(fill = factor(round(cumulative_gpa, 0)), 
x=round(cumulative_gpa, 0))) + 
  geom_bar(stat="count", position = "stack") + 
  labs(title = "Student cumulative GPAs", fill = "GPA range", x = "Student GPAs") + 
  scale_x_continuous(breaks=0:7) + geom_text(stat='count', aes(label=paste(..count.., "\n", "(", round(((..count..)/sum(..count..))*100, 2), "%", ")" , sep = ""), vjust = "inward"))
# --



# --
getStudentInformationByItselfExpression <- "
SELECT 
  student_id,
  AVG(student_score) AS 'avg_student_score',
  AVG(difference_between_due_date_and_hand_in_date) AS 'avg_student_quickness_at_handing_in_assignments',
  student_has_a_disability,
  index_of_multiple_deprivation_for_a_uk_region,
  student_highest_education_level_on_entry_to_the_module
FROM
  studentCourseAssessmentInfoTables
GROUP BY student_id"

getStudentInformationByItself <- sqldf(getStudentInformationByItselfExpression)

studentInfoTableForLinearModel <- merge(studentCumulativeGPAsTable, fixedUpMergedSubsetSums, by = "student_id")
studentInfoTableForLinearModel <- merge(studentInfoTableForLinearModel, getStudentInformationByItself, by = "student_id")
studentInfoTableForLinearModel <- na.omit(studentInfoTableForLinearModel)
view(studentInfoTableForLinearModel)

# Linear models

plot(x = studentInfoTableForLinearModel$cumulative_gpa, y = studentInfoTableForLinearModel$avg_student_score, main = "GPA plotted against average score", xlab = "Cumulative GPA of students", ylab = "Average score of students")



# -- Linear model 01 - Continuous predictor
fit1 <- lm(cumulative_gpa ~ sum_vle_interaction_times, data = studentInfoTableForLinearModel)
summary(fit1)


plot(fit1, ask = FALSE)

plot(x = studentInfoTableForLinearModel$cumulative_gpa, y = studentInfoTableForLinearModel$sum_vle_interaction_times, main = "GPA plotted against use of learning material", xlab = "Cumulative GPA of students", ylab = "Times clicked the learning material")
abline(3.2827189, 0.0004165, col = "red")

# predicted values
predicted_cpa_values <- predict(fit1)
view(predicted_cpa_values)

residualsForFit1Showing <- studentInfoTableForLinearModel$cumulative_gpa - predicted_cpa_values

# residual values
residualsForFit1 <- resid(fit1)

# root mean squared error RMSE: the closer to 0 the better
sqrt(mean(residualsForFit1^2))


# A model fits the data better
# If it is more close to 0 than another one
# --

# -- Linear model 02  - Categorical predictors

fit2 <- lm(cumulative_gpa ~ student_highest_education_level_on_entry_to_the_module, data = studentInfoTableForLinearModel)
summary(fit2)

# predicted values
predicted_cpa_values <- predict(fit2)

# residual values
residualsForFit2 <- resid(fit2)

# root mean squared error RMSE: the closer to 0 the better
sqrt(mean(residualsForFit2^2))

# --

# -- Linear model 02  - Categorical and continuous predictors
fit3 <- lm(cumulative_gpa ~ 
             sum_vle_interaction_times +
           student_quickness_at_handing_in_assignments +
           student_has_a_disability +
           index_of_multiple_deprivation_for_a_uk_region +
             student_highest_education_level_on_entry_to_the_module, data = studentInfoTableForLinearModel)
summary(fit3)

# predicted values
predicted_cpa_values <- predict(fit3)

# residual values
residualsForFit3 <- resid(fit3)

# root mean squared error RMSE: the closer to 0 the better
sqrt(mean(residualsForFit3^2))


# https://web.maths.unsw.edu.au/~adelle/Garvan/Assays/GoodnessOfFit.html
# --