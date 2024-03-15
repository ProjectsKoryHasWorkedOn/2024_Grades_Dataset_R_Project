#R code

#Load in libraries
library(mongolite)

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

# Getting data from DB
query<-list()
query[["student_id"]][["$gt"]] <- 1
query <- jsonlite::toJSON(query, auto_unbox = TRUE)
query
dbConnection$find(query)



