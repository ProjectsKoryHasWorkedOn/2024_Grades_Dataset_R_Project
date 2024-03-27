# What files I share between both R project files
# -- Make sure it searches from directory of "mongodb_dataset_main.R"
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# --

# -- Import a file that installs and loads the needed libraries
source(file = paste(getwd(), "/import/r_scripts/r_libraries.R", sep = ""))
# --

# -- Import a file that incorporates the needed classes
source(file = paste(getwd(), "/import/r_scripts/r_classes.R", sep = ""))
# --


# What I've done to the Mongo DB dataset
# -- Data wrangling and transformation
source(file = paste(getwd(), "/import/r_scripts/r_mongo_db_setup.R", sep = ""))
# --

# -- Data analysis
MGDBDataAnalyzer$setDataset(mongoDBDataset)

MGDBDataAnalyzer$calculateNumberOfColumns()

MGDBDataAnalyzer$calculateNumberOfRowsWithUniqueValues()
MGDBDataAnalyzer$calculateNumberOfRowsWithNonUniqueValues()
MGDBDataAnalyzer$setNamesOfRowsForNumberOfRowsVectors()

MGDBDataAnalyzer$calculateNumberOfMissingValues()

MGDBDataAnalyzer$calculateRangeOfValues(mongoDBDataset$score)

MGDBDataAnalyzer$calculateMean(mongoDBDataset$score)
MGDBDataAnalyzer$calculateMedian(mongoDBDataset$score)
MGDBDataAnalyzer$calculateMaximum(mongoDBDataset$score)
MGDBDataAnalyzer$calculateMinimum(mongoDBDataset$score)
MGDBDataAnalyzer$calculateMedian(mongoDBDataset$score)
MGDBDataAnalyzer$calculate1stQuartile(mongoDBDataset$score)
MGDBDataAnalyzer$calculate3rdQuartile(mongoDBDataset$score)
MGDBDataAnalyzer$calculateStandardDeviation(mongoDBDataset$score)
# --

# -- Data analysis exports
export_01_0001 <- MGDBDataAnalyzer$returnNumberOfMissingValues()

export_02_0001 <- MGDBDataAnalyzer$returnNumberOfRowsWithNonUniqueValues()
export_02_0002 <- MGDBDataAnalyzer$returnNumberOfRowsWithUniqueValues()
export_02_0003 <- MGDBDataAnalyzer$returnRangeOfValues()

export_03_0001 <- MGDBDataAnalyzer$returnMean()
export_03_0002 <- MGDBDataAnalyzer$returnMedian()
export_03_0003 <- MGDBDataAnalyzer$returnMaximum()
export_03_0004 <- MGDBDataAnalyzer$returnMinimum()
export_03_0005 <- MGDBDataAnalyzer$return1stQuartile()
export_03_0006 <- MGDBDataAnalyzer$return3rdQuartile()
export_03_0007 <- MGDBDataAnalyzer$returnStandardDeviation()
# --

# -- Data visualization exports
MGDBDataVisualizer$setDataset(mongoDBDataset)
export_04_0001 <- MGDBDataVisualizer$graphHistogram(round(mongoDBDataset$score), 200, c("firebrick", "red", "green", "forestgreen"), "Where students grades lie", "grade", "density", 0.15)
# --







studentIDToLookFor <- 1

MGDBDataSubsetter$setQuery(paste(
  "select DISTINCT(student_id), AVG(score), class_id
from mongoDBDataset
where student_id =",studentIDToLookFor, "
group by class_id;", sep =""))

averageGradesForAStudentAcrossAllOfTheirClasses <- MGDBDataSubsetter$returnQueryResult(c("student_id", "average_score", "class_id"))
# view(averageGradesForAStudentAcrossAllOfTheirClasses)

classesStudentWasIn <- MGDBDataTransformer$putVectorIntoASingleLineWithQuotationMarksBetweenEachTerm(averageGradesForAStudentAcrossAllOfTheirClasses$class_id)

MGDBDataSubsetter$setQuery(
  paste(
    "select DISTINCT(student_id), AVG(score), class_id
from mongoDBDataset
where student_id !=", studentIDToLookFor, " ", "AND class_id IN (",
    classesStudentWasIn,
    ")
GROUP BY student_id;",
    sep = ""
  )
)

averageGradesForStudentsInSameClassesAsExceptionExceptException <- MGDBDataSubsetter$returnQueryResult(c("student_id", "average_score", "class_id"))
#view(averageGradesForStudentsInSameClassesAsExceptionExceptException)
averageGradesForStudentsInSameClassesAsExceptionIncludingException <- merge(x = averageGradesForAStudentAcrossAllOfTheirClasses, y = averageGradesForStudentsInSameClassesAsExceptionExceptException, all = TRUE)
# view(averageGradesForStudentsInSameClassesAsExceptionIncludingException)

MGDBDataAnalyzer$setDataset(averageGradesForStudentsInSameClassesAsExceptionIncludingException)
MGDBDataAnalyzer$calculateMeanOfGroup(3)
class_averages <- MGDBDataAnalyzer$returnMeanOfGroup()
#view(class_averages)
MGDBDataTransformer$setDataset(class_averages)
MGDBDataTransformer$removeJunkColumns(c(1, 2)) # remove cols 1, 2
class_averages <- MGDBDataTransformer$returnDataset()
#view(class_averages)



MGDBDataAnalyzer$setDataset(averageGradesForStudentsInSameClassesAsExceptionIncludingException)
MGDBDataAnalyzer$calculateQuartileValueOfGroup(3, 0.25)
class_q1 <- MGDBDataAnalyzer$returnQuartileValueOfGroup()
MGDBDataTransformer$setDataset(class_q1)
MGDBDataTransformer$removeJunkColumns(c(1, 2)) # remove cols 1, 2
class_q1 <- MGDBDataTransformer$returnDataset()
#view(class_q1)


MGDBDataAnalyzer$setDataset(averageGradesForStudentsInSameClassesAsExceptionIncludingException)
MGDBDataAnalyzer$calculateQuartileValueOfGroup(3, 0.75)
class_q3 <- MGDBDataAnalyzer$returnQuartileValueOfGroup()
MGDBDataTransformer$setDataset(class_q3)
MGDBDataTransformer$removeJunkColumns(c(1, 2)) # remove cols 1, 2
class_q3 <- MGDBDataTransformer$returnDataset()
#view(class_q3)




# -- Data visualization exports
MGDBDataVisualizer$setDataset(averageGradesForStudentsInSameClassesAsExceptionExceptException)
MGDBDataVisualizer$setSecondDataset(averageGradesForAStudentAcrossAllOfTheirClasses)
MGDBDataVisualizer$setThirdDataset(class_averages)

export_05_0001 <- MGDBDataVisualizer$graphScatterPlotThatMakesUseOfTwoDatasets(
  averageGradesForStudentsInSameClassesAsExceptionExceptException$class_id,
  averageGradesForStudentsInSameClassesAsExceptionExceptException$average_score,
  "darkgrey",
  1,
  averageGradesForAStudentAcrossAllOfTheirClasses$class_id,
  averageGradesForAStudentAcrossAllOfTheirClasses$average_score,
  "red",
  1,
  "class number",
  "average scores of students",
  "How well a student did",
  "(Relative to others for all of their classes that have ever been done)",
  0,
  100,
  class_averages$class_id,
  class_averages$average_score,
  "blue",
  1,
  class_q1$average_score,
  class_q3$average_score,
  "darkturquoise",
  "green"
)



