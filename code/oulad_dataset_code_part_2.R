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
genderColors <- c("pink", "royalblue")

# -- Density plot of if gender affects assessment hand in times 
ggplot(studentCourseAssessmentInfoTables,
       aes(x = difference_between_due_date_and_hand_in_date, color = gender)) + scale_color_manual(values=genderColors)  + geom_density(alpha = 0.1, position = "identity") + labs(title = "Comparison between the sexes", subtitle = "Who hands in work faster", x = "Difference between the due date and hand in date")  + theme_classic()
# Found that what's depicted didn't change too much with age, disability, or IMD band
# --

# -- Violin plot of if gender affects student scores
ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, color = gender)) + scale_color_manual(values=genderColors) + geom_violin(alpha = 0.5, position = "identity") + theme_classic() + labs(title = "Comparison between the sexes", subtitle = "Who scores better", y = "Student scores", x = NULL) + scale_x_discrete(labels = NULL, breaks = NULL) 
# --

# -- Violin plot of if disability affects student scores
ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, color = student_has_a_disability))  + geom_violin(alpha = 0.5, position = "identity") + theme_classic() + labs(title = "Comparison between the disabled and abled", subtitle = "Who scores better", y = "Student scores", x = NULL) + scale_x_discrete(labels = NULL, breaks = NULL)
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

# numberOfCombinations = n_distinct(studentModulePresentationGradeTable$group_ids_together)
numberOfCombinations = 19

colorsToUseForLabels <- rep(colorsToUseForLabels, times = numberOfCombinations)
colorsToUseForLabels

colorsToUseForLabels <- c(colorsToUseForLabels, colorsToUseForLabels[1], colorsToUseForLabels[2], colorsToUseForLabels[1], colorsToUseForLabels[2], colorsToUseForLabels[1], colorsToUseForLabels[2])
colorsToUseForLabels

ggplot(studentModulePresentationGradeTable, aes(x = grade, fill = grade)) + scale_fill_manual("Grades", values = c(colorsToUseForBars)) + facet_wrap(~ group_ids_together) + geom_bar() + geom_text(stat='count', aes(label=..count..), color = colorsToUseForLabels, vjust = "inward") + labs(title = "Student results", subtitle = "For each module & presentation", y = "Count", x = "Student grades")
# --

# -- Student cumulative GPA bar chart
ggplot(studentCumulativeGPAsTable, aes(fill = factor(round(cumulative_gpa, 0)), 
x=round(cumulative_gpa, 0))) + 
  geom_bar(stat="count", position = "stack") + 
  labs(title = "Student cumulative GPAs", fill = "GPA range", x = "Student GPAs") + 
  scale_x_continuous(breaks=0:7) + geom_text(stat='count', aes(label=paste(..count.., "\n", "(", round(((..count..)/sum(..count..))*100, 2), "%", ")" , sep = ""), vjust = "inward"))
# --

