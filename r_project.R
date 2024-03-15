#R code

#Load in libraries
library(mongolite)
library(ggplot2)
library(cowplot)



#Connect to Mongo DB
connection_string = 'mongodb+srv://fran0618:WhwdV2u7cMmUJuDj@comp2031-8031.hfcmwd0.mongodb.net/?retryWrites=true&w=majority&appName=COMP2031-8031' # Kory's connection string
dbConnection = mongo(collection="grades", db="sample_training", url=connection_string) # Indicate that we want to access the grades collection in the sample training DB
dbConnection$count() # count number of elements
dbConnection$iterate()$one() # iterate through elements by increments of one

# What columns this table has:
# '_id'
# 'class_id'
# 'scores'
  # 'score'
  # 'type'
  # ...
# 'student_id'

# Getting specific data from DB. 
query<-list()
# query[["student_id"]][["$gt"]] <- 0 # {all student IDs}
query[["student_id"]] <- 0 # {student id of 0}
query[["class_id"]] <- 339 # {class id of 339}
query <- jsonlite::toJSON(query, auto_unbox = TRUE) # Convert this to JSON format
query

# Putting this data into a data frame
df <- as.data.frame(dbConnection$find(query))
head(df)


scatter1 <- ggplot(data = df, mapping = aes(x="homework", y="score")) + geom_point(color="lightblue") + 
  geom_point()  + theme(axis.title.x=element_text(), axis.text.x=element_text())
scatter2 <- ggplot(data = df, mapping = aes(x="exam", y="score")) + geom_point(color="lightblue") + 
  geom_point()
scatter3 <- ggplot(data = df, mapping = aes(x="quiz", y="score")) + geom_point(color="lightblue") + 
  geom_point()





