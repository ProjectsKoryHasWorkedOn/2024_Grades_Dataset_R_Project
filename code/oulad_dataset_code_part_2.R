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

# -- Student score distribution
OULADDataVisualizer$setDataset(studentCourseAssessmentInfoTables)
exportStudentScoresDistributionVisualization <- OULADDataVisualizer$graphHistogram(round(studentCourseAssessmentInfoTables$student_score), 200, c("firebrick", "red", "green", "forestgreen"), "Where students scores lie", "Student scores", "density", 0.15)
# --

# -- Density plot of assessment hand in times 
exportAssessmentHandInTimesGraph <- ggplot(studentCourseAssessmentInfoTables,
       aes(x = difference_between_due_date_and_hand_in_date)) + geom_density(alpha = 0.1, position = "identity") + labs(title = "Seeing when most students hand in their work", x = "Difference between the due date and hand in date")  + theme_classic()

# Found that what's depicted didn't change too much with age, disability, gender, or IMD band
# --


# -- Get some basic information about the number of enrolled students, VLE materials, and assessments

OULADDataChecker$setDataset(studentCourseAssessmentInfoTables)
OULADDataChecker$calculateWhatUniqueValuesWeHaveInAColumn(3)
whatUniqueStudentIDsWeHaveInThisTable <- OULADDataChecker$returnWhatUniqueValuesWeHaveInAColumn()
exportTotalUniqueStudentIDs <- count(whatUniqueStudentIDsWeHaveInThisTable)

OULADDataChecker$setDataset(studentCourseAssessmentInfoTables)
OULADDataChecker$calculateWhatUniqueValuesWeHaveInAColumn(4)
whatUniqueAssessmentIDsWeHaveInThisColumn <- OULADDataChecker$returnWhatUniqueValuesWeHaveInAColumn()

exportTotalUniqueAssessmentIDs <- count(whatUniqueAssessmentIDsWeHaveInThisColumn)

OULADDataChecker$setDataset(VLETable)
OULADDataChecker$calculateWhatUniqueValuesWeHaveInAColumn(1)
whatUniqueVLEMaterialIDsWeHaveInThisColumn <- OULADDataChecker$returnWhatUniqueValuesWeHaveInAColumn()
exportTotalUniqueVLEMaterialID <- count(whatUniqueVLEMaterialIDsWeHaveInThisColumn)
# --

# -- Perform some basic analysis on the scores column --
OULADDataAnalyzer$setDataset(studentCourseAssessmentInfoTables)
OULADDataAnalyzer$calculate1stQuartile(studentCourseAssessmentInfoTables$student_score)
OULADDataAnalyzer$calculate3rdQuartile(studentCourseAssessmentInfoTables$student_score)
OULADDataAnalyzer$calculateMean(studentCourseAssessmentInfoTables$student_score)
OULADDataAnalyzer$calculateMedian(studentCourseAssessmentInfoTables$student_score)
OULADDataAnalyzer$calculateInterquartileRange(studentCourseAssessmentInfoTables$student_score)
OULADDataAnalyzer$calculateMinimum(studentCourseAssessmentInfoTables$student_score)
OULADDataAnalyzer$calculateMaximum(studentCourseAssessmentInfoTables$student_score)


exportStudentScoresIQR <- OULADDataAnalyzer$returnInterquartileRange()
exportStudentScoresMean <- OULADDataAnalyzer$returnMean()
exportStudentScoresMedian <- OULADDataAnalyzer$returnMedian()
exportStudentScoresQ1 <- OULADDataAnalyzer$return1stQuartile()
exportStudentScoresQ3 <- OULADDataAnalyzer$return3rdQuartile()
exportStudentScoresMin <- OULADDataAnalyzer$returnMinimum()
exportStudentScoresMax <- OULADDataAnalyzer$returnMaximum()
# --

# -- See if I can visualize number of people from the different England regions

englandRegionBoundariesFilePath <- paste(getwd(), "/import/uk_regions_data/Regions_December_2015_FEB_in_England.shp", sep = "")

OULADDatasetQuerier$setQuery("select student_id, region_student_lived_in_while_taking_the_module FROM studentCourseAssessmentInfoTables GROUP BY student_id")

tableOfStudentIDToStudentRegion <- OULADDatasetQuerier$returnQueryResultKeepColNames()

OULADDatasetQuerier$setQuery("select DISTINCT(region_student_lived_in_while_taking_the_module) AS 'region', COUNT(region_student_lived_in_while_taking_the_module) AS 'number_of_students_living_in_the_region' FROM tableOfStudentIDToStudentRegion GROUP BY region_student_lived_in_while_taking_the_module")

countOfStudentsInARegion <- OULADDatasetQuerier$returnQueryResultKeepColNames()
view(countOfStudentsInARegion)

england_region_map <- st_read(englandRegionBoundariesFilePath) 

england_region_map_data <- data.frame(
  regionsList = c("North East",
                   "North West",
                   "Yorkshire and The Humber",
                   "East Midlands",
                   "West Midlands",
                   "East of England",
                   "London", 
                   "South East",
                   "South West"),
  regionsCount = c(NA, countOfStudentsInARegion[[2]][[6]], countOfStudentsInARegion[[2]][[13]], countOfStudentsInARegion[[2]][[2]], countOfStudentsInARegion[[2]][[5]], countOfStudentsInARegion[[2]][[1]], countOfStudentsInARegion[[2]][[4]],  countOfStudentsInARegion[[2]][[8]],  countOfStudentsInARegion[[2]][[10]]),
  totalCount = sum(countOfStudentsInARegion[[2]][[6]], countOfStudentsInARegion[[2]][[13]], countOfStudentsInARegion[[2]][[2]], countOfStudentsInARegion[[2]][[5]], countOfStudentsInARegion[[2]][[1]], countOfStudentsInARegion[[2]][[4]],  countOfStudentsInARegion[[2]][[8]],  countOfStudentsInARegion[[2]][[10]])
)

exportStudentsInTheRegionsOfEnglandVisualization <- england_region_map |> left_join(tibble(rgn15nm = england_region_map_data$regionsList)) |> ggplot(aes(fill = paste0(england_region_map_data$regionsList, " ",  ifelse(is.na(round((england_region_map_data$regionsCount/england_region_map_data$totalCount)*100, 2)) == TRUE, "{No data on this}", paste0(round((england_region_map_data$regionsCount/england_region_map_data$totalCount)*100, 2), "%")))))  +
  geom_sf(colour = "black") + geom_sf_text(aes(label = england_region_map_data$regionsCount), colour = "white")  + theme_void() + labs(fill = "England regions", title = "The number and proportion of students in each region in England") 
                                            
# --

# -- See if I can visualize the number of students from the different UK countries

# for manipulation of simple features objects


uk_countries <- ne_states(country = "united kingdom", returnclass = "sf")

england_count <- countOfStudentsInARegion %>% 
  filter(!(region %in% c("Ireland", "Scotland", "Wales")))  %>% summarize(sum(number_of_students_living_in_the_region))

uk_country_map_data <- data.frame(
  countriesList = c("England",
                  "Northern Ireland",
                  "Scotland",
                  "Wales"),
  countriesCount = c(england_count[[1]][[1]], countOfStudentsInARegion[[2]][[3]], countOfStudentsInARegion[[2]][[7]], countOfStudentsInARegion[[2]][[11]])
)


uk_countries_with_students_count_column <- uk_countries %>% mutate(students_in_country = case_when( 
      geonunit == uk_country_map_data[[1]][[1]] ~ uk_country_map_data[[2]][[1]],
      geonunit == uk_country_map_data[[1]][[2]] ~ uk_country_map_data[[2]][[2]],
      geonunit == uk_country_map_data[[1]][[3]] ~ uk_country_map_data[[2]][[3]],
      geonunit == uk_country_map_data[[1]][[4]] ~ uk_country_map_data[[2]][[4]],
    ),
    .after = geonunit
  )

uk_countries_with_students_count_column$countriesTotal <- sum(england_count[[1]][[1]], countOfStudentsInARegion[[2]][[3]], countOfStudentsInARegion[[2]][[7]], countOfStudentsInARegion[[2]][[11]])



# Set all duplicated values to NA in uk_countries_with_students_count_column
uk_countries_with_students_count_column$students_in_country[duplicated(uk_countries_with_students_count_column$students_in_country)] <- NA

exportStudentsInUKCountriesVisualization <- ggplot(data = uk_countries_with_students_count_column)  +
  geom_sf(aes(fill = factor(geonunit)), color = NA) + geom_label_repel(aes(x = longitude, y = latitude, label= str_c (students_in_country, "\n", round((uk_countries_with_students_count_column$students_in_country/uk_countries_with_students_count_column$countriesTotal)*100, 2), "%" , sep = ""), fill = factor(geonunit)), size = 3) +
  theme_minimal()  +
  scale_fill_brewer(type = "qual") + labs(fill = "Countries", title = "The number and proportion of students in the UK countries")
# --

# -- Get a box plot of student scores to assignment types
exportHowStudentsScoreForDifferentAssignmentTypes <- ggplot(data = studentCourseAssessmentInfoTables, mapping = aes(group = assessment_type, y = student_score, fill = assessment_type)) +
  geom_boxplot() + 
  ylab("Student scores") + ggtitle("How students perform for different assessment types") +labs(fill="Assessment types")
# --


# -- Get number of students that withdraw vs number of students that don't withdraw
OULADDatasetQuerier$setQuery("select student_id, did_student_finish_the_course FROM studentCourseAssessmentInfoTables GROUP BY student_id")

studentTableWithStudentIDAndIfStudentFinishedCourse <- OULADDatasetQuerier$returnQueryResultKeepColNames()

totalThatStayed <- studentTableWithStudentIDAndIfStudentFinishedCourse %>% filter(did_student_finish_the_course == "Yes") %>% summarise(n = n())

totalThatWithdrew <- studentTableWithStudentIDAndIfStudentFinishedCourse %>% filter(did_student_finish_the_course == "No") %>% summarise(n = n())

# Visualize this in a pie chart
pieChartData <- data.frame(
  categories=c("Total students that withdrew from it","Total students that completed it"),
  count=c(totalThatWithdrew[[1]],totalThatStayed[[1]]),
  totalcount = (totalThatWithdrew[[1]] + totalThatStayed[[1]])
)

exportVisualizationOfNumberOfStudentsThatWithdrewVsStayed <- ggplot(pieChartData, aes(x="", y=count, fill=categories)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  geom_label_repel(aes(y = count, label = paste(count, paste((round((count/totalcount)*100, 2)), "%", sep = ""),  sep = "\n")), size=3, nudge_x = 1)  + ggtitle("Students that withdrew from vs finished their course + module") + theme_void() 
# --

# -- Get number of men vs women that have enrolled
OULADDatasetQuerier$setQuery("select student_id, gender FROM studentCourseAssessmentInfoTables GROUP BY student_id")

studentTableWithStudentIDAndGender <- OULADDatasetQuerier$returnQueryResultKeepColNames()

totalMen <- studentTableWithStudentIDAndGender %>% filter(gender == "M") %>% summarise(n = n())

totalWomen <- studentTableWithStudentIDAndGender %>% filter(gender == "F") %>% summarise(n = n())

# Visualize this is in a square (pie) chart
squarePieData <- data.frame(
  categories=c("Total men","Total woman"),
  count=c(totalMen[[1]],totalWomen[[1]] )
)
  
squarePieDataValues <- c(`Total men`= totalMen[[1]] / 100, `Total women`= totalWomen[[1]] / 100)
names(squarePieDataValues) = paste0(names(squarePieDataValues), " ", "(", round((squarePieDataValues/sum(squarePieDataValues)), 2) * 100, "%" , ")")

exportVisualizationOfNumberOfMenToWomen <- waffle(squarePieDataValues, colors = c(RColorBrewer::brewer.pal(8, "Pastel1")[1:2])) + ggtitle("Number of male to female students")

# Pastel1 corresponds to pink and blue


# -- Set what color scheme to use for the different genders
genderColors <- c("pink", "royalblue")
# --

# -- Summary of averages for gender
exportDoWomenOrMenTendToPerformBetter <- studentCourseAssessmentInfoTables %>% 
  group_by(gender) %>% 
  summarize(median = median(student_score),
            mean = mean(student_score))
# --

# -- Violin plot of if gender affects student scores
exportGenderStudentScoresGraph <- ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, color = gender)) + scale_color_manual(values=genderColors) + geom_violin(alpha = 0.5, position = "identity") + theme_classic() + labs(title = "Comparison between the sexes", subtitle = "Who scores better", y = "Student scores", x = NULL, color = "Gender of student") + scale_x_discrete(labels = NULL, breaks = NULL) 
# --

# -- Summary of averages for disability
exportDoDisabledOrNonDisabledPeopleTendToPerformBetter <- studentCourseAssessmentInfoTables %>% 
  group_by(student_has_a_disability) %>% 
  summarize(median = median(student_score),
            mean = mean(student_score))
# --

# -- Violin plot of if disability affects student scores
exportDisabilityStudentScoresGraph <- ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, color = student_has_a_disability))  + geom_violin(alpha = 0.5, position = "identity") + theme_classic() + labs(title = "Comparison between the disabled and abled", subtitle = "Who scores better", y = "Student scores", x = NULL, color = "Student is disabled") + scale_x_discrete(labels = NULL, breaks = NULL)
# --


# -- Summary of averages for age
exportDoOlderOrYoungerPeoplePerformBetter <- studentCourseAssessmentInfoTables %>% 
  group_by(student_age) %>% 
  summarize(median = median(student_score),
            mean = mean(student_score))
# --


# -- Violin plot of if age affects student scores
exportAgeStudentScoresGraph <- ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, fill = student_age)) + facet_wrap(~ student_age) + geom_violin() + labs(title = "Comparison between the age groups", subtitle = "Who scores better", y = "Student scores", x = NULL) + scale_x_discrete(labels = NULL, breaks = NULL)
# --


# -- Summary of averages for IMD band
exportDoLessImpoverishedStudentsPerformBetterOrWorse <- studentCourseAssessmentInfoTables %>% 
  group_by(index_of_multiple_deprivation_for_a_uk_region) %>% 
  summarize(median = median(student_score),
            mean = mean(student_score))
# --


# -- Violin plot of if the IMD band affects student scores
exportImpoverishmentStudentScoresGraph <- ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, fill = index_of_multiple_deprivation_for_a_uk_region)) + facet_grid(~ index_of_multiple_deprivation_for_a_uk_region) + geom_violin() +labs(fill="IMD band") +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())  + labs(title = "Comparison between index of multiple deprivation bands", subtitle = "Does being disadvantaged affect student scores", y = "Student scores", x = NULL) 
# --



# -- Summary of averages for highest education achieved
exportDoMoreEducationStudentsPerformBetter <- studentCourseAssessmentInfoTables %>% 
  group_by(student_highest_education_level_on_entry_to_the_module) %>% 
  summarize(median = median(student_score),
            mean = mean(student_score))
# --



# -- Violin plot for if educational attainment affects student scores

exportHighestLevelOfQualificationStudentScoreGraph <- ggplot(studentCourseAssessmentInfoTables, aes(x = assessment_id, y = student_score, fill = student_highest_education_level_on_entry_to_the_module)) + facet_grid(~ student_highest_education_level_on_entry_to_the_module) + geom_violin() +labs(fill="Highest education level on entry to the module") +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())  + labs(title = "Comparison between education levels", subtitle = "Does being more educated on entry to the module affect student scores", y = "Student scores", x = NULL) 
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


exportStudentGradesForTheirModuleAndPresentationsGraph <- ggplot(studentModulePresentationGradeTable, aes(x = grade, fill = grade)) + scale_fill_manual("Grades", values = c(colorsToUseForBars)) + facet_wrap(~ group_ids_together) + geom_bar() + geom_text(stat='count', aes(label=..count..), color = colorsToUseForLabels, vjust = "inward") + labs(title = "Student results", subtitle = "For each module & presentation", y = "Count", x = "Student grades")
# --

# -- Finding which module and presentation combinations student perform the best and worst in

exportWhichModuleAndPresentationCombinationIsEasiestAndHardest <- studentModulePresentationGradeTable %>% 
  group_by(group_ids_together) %>% 
  summarize(median = median(numerical_grade_equivalent, na.rm = TRUE),
            mean = mean(numerical_grade_equivalent, na.rm = TRUE))

# --


# -- Student cumulative GPA bar chart
exportStudentCumulativeGPAGraph <- ggplot(studentCumulativeGPAsTable, aes(fill = factor(round(cumulative_gpa, 0)), 
x=round(cumulative_gpa, 0))) + 
  geom_bar(stat="count", position = "stack") + 
  labs(title = "Student cumulative GPAs", fill = "GPA range", x = "Student GPAs") + 
  scale_x_continuous(breaks=0:7) + geom_text(stat='count', aes(label=paste(..count.., "\n", "(", round(((..count..)/sum(..count..))*100, 2), "%", ")" , sep = ""), vjust = "inward"))
# --

# -- Count students with high enough GPA for postgraduate studies
filterForStudentsWithGPAHigherThan4.5 <- studentCumulativeGPAsTable %>% filter(cumulative_gpa >= 4.5)

exportCountNumberOfStudentsWithHighEnoughGPAForPostGradStudies <- filterForStudentsWithGPAHigherThan4.5 %>% count()

# Get the percentage that this is of the total
totalRows <- nrow(studentCumulativeGPAsTable)

exportWhatPercentageOfStudentsHaveAHighEnoughGPAForPostGradStudies <- (exportCountNumberOfStudentsWithHighEnoughGPAForPostGradStudies / totalRows) * 100
# --



# -- Count students that withdrew from the course by IMD band
# Need to remove duplicate student IDs
distinctStudentIDS <- studentCourseAssessmentInfoTables %>%  distinct(student_id, index_of_multiple_deprivation_for_a_uk_region, did_student_finish_the_course) 

exportNumberOfWithdrawalsByIMDBand <- distinctStudentIDS %>% 
  group_by(index_of_multiple_deprivation_for_a_uk_region) %>%
  summarise(
    total_students_that_withdrew = sum(did_student_finish_the_course == "No"),
    percentage_of_total = ((sum(did_student_finish_the_course == "No")) /  n()) * 100
  )
# --



# --
OULADDatasetQuerier$setQuery("
SELECT 
  student_id,
  AVG(student_score) AS 'avg_student_score',
  AVG(difference_between_due_date_and_hand_in_date) AS 'avg_student_quickness_at_handing_in_assignments',
  student_has_a_disability,
  index_of_multiple_deprivation_for_a_uk_region,
  student_highest_education_level_on_entry_to_the_module
FROM
  studentCourseAssessmentInfoTables
GROUP BY student_id")

getStudentInformationByItself <- OULADDatasetQuerier$returnQueryResultKeepColNames()

studentInfoTableForLinearModel <- merge(studentCumulativeGPAsTable, fixedUpMergedSubsetSums, by = "student_id")
studentInfoTableForLinearModel <- merge(studentInfoTableForLinearModel, getStudentInformationByItself, by = "student_id")
studentInfoTableForLinearModel <- na.omit(studentInfoTableForLinearModel)
# view(studentInfoTableForLinearModel)

# Linear models
# -- Linear model 01 - GPA (Y) to average student score (x)
# Continuous predictor
exportGPAToAverageStudentScoreLM <- ggplot(studentInfoTableForLinearModel, aes(x = cumulative_gpa, y = avg_student_score)) + geom_point() +  geom_smooth(color = "turquoise", method="lm") + labs(title = "GPA plotted against average score", x = "Cumulative GPA of students", y = "Average score of students") + theme_minimal()

linearModel01 <- lm(cumulative_gpa ~ avg_student_score, data = studentInfoTableForLinearModel)
summary(linearModel01)
# Adjusted R-squared:  0.6848 
# F-statistic: 4.328e+04 = 4.328 × 10^4 = 43,280
# p-value: < 2.2e-16 = 0.00000000000000022


outliersTestOutcome <- car::outlierTest(linearModel01)
exportNumberOfOutliersForLinearModel1 <- nrow(outliersTestOutcome)


# --

# -- Linear model 02 - GPA (Y) to total VLE interaction times (x)
# Continuous predictor
linearModel02 <- lm(cumulative_gpa ~ sum_vle_interaction_times, data = studentInfoTableForLinearModel)
summary(linearModel02)
# Adjusted R-squared: 0.0501
# F-statistic: 1051
# p-value: < 2.2e-16 = 0.00000000000000022


outliersTestOutcome <- car::outlierTest(linearModel02)
exportNumberOfOutliersForLinearModel2 <- nrow(outliersTestOutcome)



ggplot(studentInfoTableForLinearModel, aes(x = cumulative_gpa, y = sum_vle_interaction_times)) + geom_point() +  geom_smooth(color = "turquoise", method="lm") + labs(title = "GPA plotted against use of learning material", x = "Cumulative GPA of students", y = "Times clicked the learning material") + theme_minimal()

# predicted values
predicted_cgpa_values <- predict(linearModel02)
studentInfoTableForLinearModel["predicted_cgpa_from_learning_material_use"] <- predicted_cgpa_values
studentInfoTableForLinearModel <- studentInfoTableForLinearModel %>% relocate(predicted_cgpa_from_learning_material_use, .after = cumulative_gpa)
view(studentInfoTableForLinearModel)

# Residual values
residualsForLinearModel02 <- studentInfoTableForLinearModel$cumulative_gpa - predicted_cgpa_values
residualsForLinearModel02


# root mean squared error RMSE
sqrt(mean(residualsForLinearModel02^2))

# --

# -- Linear model 03  - Categorical predictors
linearModel03 <- lm(cumulative_gpa ~ student_highest_education_level_on_entry_to_the_module, data = studentInfoTableForLinearModel)
summary(linearModel03)
# Adjusted R-squared:  0.01262
# F-statistic: 64.64
# p-value < 2.2e-16: < 0.00000000000000022

# predicted values
predicted_cgpa_values <- predict(linearModel03)

# residual values
residualsForLinearModel03 <- resid(linearModel03)

# root mean squared error RMSE
sqrt(mean(residualsForLinearModel03^2))

# --

# -- Linear model 02  - Categorical and continuous predictors
fit3 <- lm(cumulative_gpa ~ 
             sum_vle_interaction_times +
           avg_student_quickness_at_handing_in_assignments +
           student_has_a_disability +
           index_of_multiple_deprivation_for_a_uk_region +
             student_highest_education_level_on_entry_to_the_module, data = studentInfoTableForLinearModel)
summary(fit3)

# predicted values
predicted_cpa_values <- predict(fit3)

# residual values
residualsForFit3 <- resid(fit3)

# root mean squared error RMSE
sqrt(mean(residualsForFit3^2))


# --



# can do a facet wrap for model with + and model with * between the terms to see the difference in plot
# https://modelr.tidyverse.org/reference/data_grid.html