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
# view(countOfStudentsInARegion)

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



# -- Linear modelling dataset
OULADDatasetQuerier$setQuery("
SELECT 
  student_id,
  AVG(student_score) AS 'avg_student_score',
  AVG(difference_between_due_date_and_hand_in_date) AS 'avg_student_quickness_at_handing_in_assignments',
  student_has_a_disability,
  index_of_multiple_deprivation_for_a_uk_region,
  student_highest_education_level_on_entry_to_the_module,
  did_student_finish_the_course,
  gender
FROM
  studentCourseAssessmentInfoTables
GROUP BY student_id")

getStudentInformationByItself <- OULADDatasetQuerier$returnQueryResultKeepColNames()

studentInfoTableForLinearModel <- merge(studentCumulativeGPAsTable, fixedUpMergedSubsetSums, by = "student_id")
studentInfoTableForLinearModel <- merge(studentInfoTableForLinearModel, getStudentInformationByItself, by = "student_id")
studentInfoTableForLinearModel <- na.omit(studentInfoTableForLinearModel)
# view(studentInfoTableForLinearModel)
# --


# -- Visualizing the correlation between the variables of the linear modelling dataset
studentInfoTableForLinearModel$gender <- factor(studentInfoTableForLinearModel$gender)
studentInfoTableForLinearModel$gender <- as.numeric(studentInfoTableForLinearModel$gender)

studentInfoTableForLinearModel$student_highest_education_level_on_entry_to_the_module <- factor(
  studentInfoTableForLinearModel$student_highest_education_level_on_entry_to_the_module,
  levels = c("No recognized qualifications", "Lower Than A Level", "A Level or Equivalent", "HE Qualification", "Post Graduate Qualification"),
  ordered = TRUE
)
studentInfoTableForLinearModel$student_highest_education_level_on_entry_to_the_module <- as.numeric(studentInfoTableForLinearModel$student_highest_education_level_on_entry_to_the_module)

studentInfoTableForLinearModel$student_has_a_disability <- factor(studentInfoTableForLinearModel$student_has_a_disability)
studentInfoTableForLinearModel$student_has_a_disability <- as.numeric(studentInfoTableForLinearModel$student_has_a_disability)

studentInfoTableForLinearModel$did_student_finish_the_course <- factor(studentInfoTableForLinearModel$did_student_finish_the_course)
studentInfoTableForLinearModel$did_student_finish_the_course <- as.numeric(studentInfoTableForLinearModel$did_student_finish_the_course)

unique(studentInfoTableForLinearModel$index_of_multiple_deprivation_for_a_uk_region)

studentInfoTableForLinearModel$index_of_multiple_deprivation_for_a_uk_region <- factor(
  studentInfoTableForLinearModel$index_of_multiple_deprivation_for_a_uk_region,
  levels = c("0-10%", "10-20%", "20-30%", "30-40%", "40-50%", "50-60%", "60-70%", "70-80%", "80-90%", "90-100%"),
  ordered = TRUE
)
studentInfoTableForLinearModel$index_of_multiple_deprivation_for_a_uk_region <- as.numeric(studentInfoTableForLinearModel$index_of_multiple_deprivation_for_a_uk_region)

correlationVariablesHaveWithGrades <- as.data.frame(round(cor(studentInfoTableForLinearModel)[,2], 1)) 
colnames(correlationVariablesHaveWithGrades) <- "Correlation to cumulative GPA"
# view(correlationVariablesHaveWithGrades)

exportVisualizeCorrelationBetweenCGPAAndOtherVariables <- ggcorrplot(correlationVariablesHaveWithGrades)

# -- Linear models

# -- Linear model 01 - GPA (Y) to average student score (x)
# Continuous predictor
linearModel01 <- lm(cumulative_gpa ~ avg_student_score, data = studentInfoTableForLinearModel)
summary(linearModel01)


# Create a dataframe that I'll use to make a prediction line
linearModel01PredictionsAndResiduals <- studentInfoTableForLinearModel %>% 
  data_grid(avg_student_score, cumulative_gpa)  %>% 
  add_predictions(linearModel01) %>% 
  add_residuals(linearModel01)
 # view(linearModel01PredictionsAndResiduals)

# Plot the data, linear regression line, prediction line
exportGPAToAverageStudentScoreLM <- ggplot(studentInfoTableForLinearModel, aes(x = cumulative_gpa, y = avg_student_score)) + geom_point() +  geom_smooth(color = "turquoise", method="lm") + labs(title = "GPA plotted against average score", x = "Cumulative GPA of students", y = "Average score of students") + geom_line(data = linearModel01PredictionsAndResiduals, mapping = aes(x = pred, y = avg_student_score), color = "red", alpha = 0.8)  + theme_minimal() 
# --



# -- Linear model 02  - GPA (Y) to student_highest_education_level_on_entry_to_the_module (x)
linearModel02 <- lm(cumulative_gpa ~  student_highest_education_level_on_entry_to_the_module, data = studentInfoTableForLinearModel)
summary(linearModel02)

predicted_cgpa_values_for_linear_model_02 <- predict(linearModel02)
studentInfoTableForLinearModel["predicted_cgpa_from_highest_education_level_on_entry_to_the_module"] <- predicted_cgpa_values_for_linear_model_02
studentInfoTableForLinearModel <- studentInfoTableForLinearModel %>% relocate(predicted_cgpa_from_highest_education_level_on_entry_to_the_module, .after = cumulative_gpa)

# Plot the data, linear regression line, prediction line
# plotted this prediction line without using a data grid
exportGPAToHighestEducationLevelOnEntryToTheModuleLM <- ggplot(studentInfoTableForLinearModel, aes(x = cumulative_gpa, y = student_highest_education_level_on_entry_to_the_module)) + geom_point() +  geom_smooth(color = "turquoise", method="lm") + labs(title = "GPA plotted against student education level on entry to the module", x = "Cumulative GPA of students", y = "Student highest education level") + theme_minimal() + geom_line(mapping = aes(x = predicted_cgpa_from_highest_education_level_on_entry_to_the_module), color = "red", alpha = 0.8)
# --


# -- Linear model 03 - GPA (Y) to total VLE interaction times (x)
# Continuous predictor
linearModel03 <- lm(cumulative_gpa ~ sum_vle_interaction_times, data = studentInfoTableForLinearModel)
summary(linearModel03)

predicted_cgpa_values_for_linear_model_03 <- predict(linearModel03)
studentInfoTableForLinearModel["predicted_cgpa_from_sum_vle_interaction_times"] <- predicted_cgpa_values_for_linear_model_03
studentInfoTableForLinearModel <- studentInfoTableForLinearModel %>% relocate(predicted_cgpa_from_sum_vle_interaction_times, .after = cumulative_gpa)

# Plot the data, linear regression line, prediction line
# plotted this prediction line without using a data grid
exportGPAToVLEInteractionTimesLM <- ggplot(studentInfoTableForLinearModel, aes(x = cumulative_gpa, y = sum_vle_interaction_times)) + geom_point() +  geom_smooth(color = "turquoise", method="lm") + labs(title = "GPA plotted against use of learning material", x = "Cumulative GPA of students", y = "Times clicked the learning material") + theme_minimal() + geom_line(mapping = aes(x = predicted_cgpa_from_sum_vle_interaction_times), color = "red", alpha = 0.8)

# --




# -- Linear model 04 & 05 - GPA (Y) to total VLE interaction times (x1) as well as IMD band (x2)
# Continuous predictor
linearModel04 <- lm(cumulative_gpa ~ sum_vle_interaction_times + index_of_multiple_deprivation_for_a_uk_region, data = studentInfoTableForLinearModel)
summary(linearModel04)

linearModel05 <- lm(cumulative_gpa ~ sum_vle_interaction_times * index_of_multiple_deprivation_for_a_uk_region, data = studentInfoTableForLinearModel)
summary(linearModel05)

# Visualizing these linear models
exportGPAToVLEInteractionTimesAndIMDBandLMWithPlusOperator <- ggPredict(linearModel04,se=TRUE,interactive=TRUE)
exportGPAToVLEInteractionTimesAndIMDBandLMWithTimesOperator <- ggPredict(linearModel05,se=TRUE,interactive=TRUE)


# --







# -- Linear model 06 & 07  - Continuous predictors
linearModel06 <- lm(cumulative_gpa ~ 
                      sum_vle_interaction_times +
                      avg_student_quickness_at_handing_in_assignments, data = studentInfoTableForLinearModel)
summary(linearModel06)

linearModel07 <- lm(cumulative_gpa ~ 
                      sum_vle_interaction_times *
                      avg_student_quickness_at_handing_in_assignments, data = studentInfoTableForLinearModel)
summary(linearModel07)

# Visualizing these linear models
exportGPAToVLEInteractionTimesAndStudentQuicknessInHandingInAssignmentsWithPlusOperator <- ggPredict(linearModel06,se=TRUE,interactive=TRUE)
exportGPAToVLEInteractionTimesAndStudentQuicknessInHandingInAssignmentsWithTimesOperator <- ggPredict(linearModel07,se=TRUE,interactive=TRUE)


# --


# -- Linear model 08 & 09  - Categorical predictors
linearModel08 <- lm(cumulative_gpa ~ 
                      index_of_multiple_deprivation_for_a_uk_region +
                      student_highest_education_level_on_entry_to_the_module, data = studentInfoTableForLinearModel)
summary(linearModel08)

linearModel09 <- lm(cumulative_gpa ~ 
           index_of_multiple_deprivation_for_a_uk_region *
             student_highest_education_level_on_entry_to_the_module, data = studentInfoTableForLinearModel)
summary(linearModel09)
# Do both models + and *

# Visualizing these linear models
exportGPAToIMDBandAndHighestEducationLevelWithPlusOperator <- ggPredict(linearModel08,se=TRUE,interactive=TRUE)
exportGPAToIMDBandAndHighestEducationLevelWithTimesOperator <- ggPredict(linearModel09,se=TRUE,interactive=TRUE)




# --

# -- Storing information about our linear models
linearModelPerformance <- tibble(
  linearModel = c(NA),
  linearModelData = data.frame(
    column = c("rmse", "adjusted r^2 value", "p value", "num. of outliers"),
    columnValue = c(NA,NA,NA,NA)
  )
)
# view(linearModelPerformance)

# Setting the dataset all linear models work off of
OULADDataModeler$setDataset(studentInfoTableForLinearModel)

# Storing information about our first linear model
OULADDataModeler$setLinearModel(linearModel01)
linearModelPerformance[1] <- c(1)

linearModelPerformance$linearModelData$columnValue = c(OULADDataModeler$extractRootMeanSquareValue(), OULADDataModeler$extractAdjustedRSquaredValue(), OULADDataModeler$extractPValue(), OULADDataModeler$extractNumberOfOutliers())
# view(linearModelPerformance)

# Minimize code duplication with this function
addInformationFromAnotherLinearModel <- function (allLinearModelsData, theLinearModel, theLinearModelNumber){
  OULADDataModeler$setLinearModel(theLinearModel)
  
  linearModelData <- tibble(
    linearModel = c(theLinearModelNumber),
    linearModelData = data.frame(
      column = c("rmse", "adjusted r^2 value", "p value", "num. of outliers"),
      columnValue = c(OULADDataModeler$extractRootMeanSquareValue(), OULADDataModeler$extractAdjustedRSquaredValue(), OULADDataModeler$extractPValue(), OULADDataModeler$extractNumberOfOutliers())
    )
  )
  
  allLinearModelsWithDataFromCurrentLinearModelAddedOn <- rbind(allLinearModelsData, linearModelData)
  
  return(allLinearModelsWithDataFromCurrentLinearModelAddedOn)
}



# Storing information about our second to ninth linear models
linearModelPerformance <- addInformationFromAnotherLinearModel(linearModelPerformance, linearModel02, 2)
linearModelPerformance <- addInformationFromAnotherLinearModel(linearModelPerformance, linearModel03, 3)
linearModelPerformance <- addInformationFromAnotherLinearModel(linearModelPerformance, linearModel04, 4)
linearModelPerformance <- addInformationFromAnotherLinearModel(linearModelPerformance, linearModel05, 5)
linearModelPerformance <- addInformationFromAnotherLinearModel(linearModelPerformance, linearModel06, 6)
linearModelPerformance <- addInformationFromAnotherLinearModel(linearModelPerformance, linearModel07, 7)
linearModelPerformance <- addInformationFromAnotherLinearModel(linearModelPerformance, linearModel08, 8)
linearModelPerformance <- addInformationFromAnotherLinearModel(linearModelPerformance, linearModel09, 9)
# view(linearModelPerformance)


# -- Comparing our linear models
comparingLinearModelPerformanceBarplot <- ggplot(data = linearModelPerformance) + 
  geom_bar(aes(x = linearModelPerformance$linearModelData$column, y = linearModelPerformance$linearModelData$columnValue, fill = linearModelPerformance$linearModelData$column), color = "black", stat="identity") + facet_wrap(linearModelPerformance$linearModel) + labs(fill = "Measures of goodness of fit", title = "Comparing linear models", x = "Measure of goodness of fit", y = "Value")
# --