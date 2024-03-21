#R code

#Load in libraries
library(mongolite)
library(tidyverse) # contains ggplot, etc.
library(cowplot)
library(jsonlite)

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
# query<-list()
# query[["student_id"]][["$gt"]] <- 0 # {all student IDs}
# query[["student_id"]] <- 0 # {student id of 0}
# query[["class_id"]] <- 339 # {class id of 339}
# query <- jsonlite::toJSON(query, auto_unbox = TRUE) # Convert this to JSON format
# query

# Putting this data into a data frame
# df <- as.data.frame(dbConnection$find(query))
df <- as.data.frame(dbConnection$find())
# removenesting <- df %>% select(scores) %>% tidyr::unnest(scores)
# head(removenesting, 20)

df <- df %>% tidyr::unnest(scores)
# df <- df %>% select(scores) %>% tidyr::unnest(scores)

view(df)

sumIsNa = sum(is.na(df))
sumIsNa

# tibble <- as_tibble(df)
#view(df)



# head(df)
# use view to see it all, cause it doesn't show in output
# too big

# student_id_vector <- as.integer(unlist(df$student_id))


#scores_vector <- as.integer(unlist(df$scores))

# MISSING <- is.na(scores_vector)
# scores_vector_no_na <- subset(scores_vector, 
  #                            subset = !MISSING)

# scores_vector_no_na

# ggplot(mapping = aes(x = student_id_vector, y = scores_vector))  + 
  # geom_point()



# Performing some basic calculations
# mean(scores_vector_no_na)
# median(scores_vector_no_na)

