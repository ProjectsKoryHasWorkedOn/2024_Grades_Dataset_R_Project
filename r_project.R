# Import a file that installs and loads the needed libraries
source(file=paste(getwd(),"/import/r_scripts/r_libraries.R", sep="")) 

# Import a file that incorporates the needed classes
source(file=paste(getwd(),"/import/r_scripts/r_classes.R", sep=""))

# What I've done to the Mongo DB dataset
# -- Declaration of classes that I'll be using to work with the data
MGDBDataLoader <- DataLoader$new()
MGDBDataTransformer <- DataTransformer$new()
MGDBDataSubsetter <- DataSubsetter$new()
MGDBDataAnalyzer <- DataAnalyzer$new()
MGDBDataViewer <- DataViewer$new()
MGDBDataVisualizer <- DataVisualizer$new()
# MGDBDataModeler <- DataModeler$new()
# --

# -- Data loading
MGDBDataLoader$setUserCredentials("fran0618", "WhwdV2u7cMmUJuDj")
MGDBDataLoader$setCluster("comp2031-8031")
MGDBDataLoader$setMongoDBCollection("grades", "sample_training")
mongoDBDataset <- MGDBDataLoader$retrieveDataFromMongoDBCollection()
# --

# -- Data transforming
MGDBDataTransformer$setDataset(mongoDBDataset)
MGDBDataTransformer$unnestAColumn("scores")
mongoDBDataset <- MGDBDataTransformer$returnDataset()
# --

# -- Data analysis
MGDBDataAnalyzer$setDataset(mongoDBDataset)

MGDBDataAnalyzer$calculateNumberOfColumns()

MGDBDataAnalyzer$calculateNumberOfRows()
MGDBDataAnalyzer$setNamesOfRows()

MGDBDataAnalyzer$calculateNumberOfMissingValues()

MGDBDataAnalyzer$calculateMean(mongoDBDataset$score)
MGDBDataAnalyzer$calculateMedian(mongoDBDataset$score)
MGDBDataAnalyzer$calculateMaximum(mongoDBDataset$score)
MGDBDataAnalyzer$calculateMinimum(mongoDBDataset$score)
MGDBDataAnalyzer$calculateMedian(mongoDBDataset$score)
MGDBDataAnalyzer$calculate1stQuartile(mongoDBDataset$score)
MGDBDataAnalyzer$calculate3rdQuartile(mongoDBDataset$score)
MGDBDataAnalyzer$calculateStandardDeviation(mongoDBDataset$score)
MGDBDataAnalyzer$calculateZScore(mongoDBDataset$score[8]) # keep after mean and standard deviation calculation
# --

# -- Data visualization
MGDBDataVisualizer$setDataset(mongoDBDataset)
# --

# -- Data viewing
MGDBDataViewer$setDatasetAndDatasetName(mongoDBDataset, "MongoDB dataset")
MGDBDataViewer$viewDataset()
# --


# What functions can be called for testing purposes


# -- Data analysis
# MGDBDataAnalyzer$outputNumberOfRows()
# MGDBDataAnalyzer$outputNumberOfMissingValues()
# MGDBDataAnalyzer$outputNumberOfColumns()
# MGDBDataAnalyzer$outputMean()
# MGDBDataAnalyzer$outputMedian()
# MGDBDataAnalyzer$outputMaximum()
# MGDBDataAnalyzer$outputMinimum()
# MGDBDataAnalyzer$outputMedian()
# MGDBDataAnalyzer$output1stQuartile()
# MGDBDataAnalyzer$output3rdQuartile()
# MGDBDataAnalyzer$outputStandardDeviation()
# MGDBDataAnalyzer$outputZScore()
# --

# Write function to return 
# AVERAGE(Scores) for a student for a specific class
# AVERAGE(Scores) for all student in a specific class
# Put this information in the data visualizer to see 
# How well the student performed relative to those in the same class,

# Write function to return
# AVERAGE(Scores) for a student for all of their classes
# AVERAGE(Scores) for students for all of their classes
# Put this information in the data visualizer to see 
# How well the student performed relative to all students

# Perhaps should use the z-score to help with drawing a line on the ggplot


  query <- "select DISTINCT(student_id), AVG(score), class_id
from mongoDBDataset
where student_id = 0
group by class_id;"
  
  
sqldf(query)


MGDBDataSubsetter$setQuery("select DISTINCT(student_id), AVG(score), class_id
from mongoDBDataset
where student_id = 0 AND class_id = 339;")

averageGradesForAStudentInAClass <- MGDBDataSubsetter$returnQueryResult(c("student_id", "average_score", "class_id"))

view(averageGradesForAStudentInAClass)


MGDBDataSubsetter$setQuery("select DISTINCT(student_id), AVG(score), class_id
from mongoDBDataset
where student_id != 0 AND class_id = 339
GROUP BY student_id;")

averageGradesForStudentsExceptOneInAClass <- MGDBDataSubsetter$returnQueryResult(c("student_id", "average_score", "class_id"))
class(averageGradesForStudentsExceptOneInAClass)
view(averageGradesForStudentsExceptOneInAClass)




ggplot() + 
  geom_point(data = averageGradesForStudentsExceptOneInAClass, mapping = aes(x = class_id, y = average_score), color="darkgrey", size=1) + 
  geom_point(data = averageGradesForAStudentInAClass, mapping = aes(x=class_id,y=average_score),colour="red") + theme_minimal() + xlab("class number") + ylab("average scores of students") + ggtitle("How well a student performs relative to others in a class") +  scale_y_continuous(limits = c(0, 100))  + scale_x_continuous(limits = c(339, 339))
#+  geom_point(data = averageGradesForAStudentInAClass, mapping = aes(x=averageGradesForAStudentInAClass$class_id,y=averageGradesForAStudentInAClass$average_score),colour="red")

# What I've done to the OULAD dataset
# -- Declaration of classes that I'll be using to work with the data
OULADDataLoader <- DataLoader$new()
OULADDataTransformer <- DataTransformer$new()
OULADDataAnalyzer <- DataAnalyzer$new()
OULADDataViewer <- DataViewer$new()
OULADDataVisualizer <- DataVisualizer$new()
# OULADDataModeler <- DataModeler$new()










# --