#R code

#Get current WD
current_wd = getwd()

#Import R script files
source(file=paste(current_wd,"/import/r_scripts/r_libraries.R", sep="")) #Libraries installer/loader R script

#Connect to Mongo DB
connection_string = 'mongodb+srv://fran0618:WhwdV2u7cMmUJuDj@comp2031-8031.hfcmwd0.mongodb.net/?retryWrites=true&w=majority&appName=COMP2031-8031' # Kory's connection string
dbConnection = mongo(collection="grades", db="sample_training", url=connection_string) # Indicate that we want to access the grades collection in the sample training DB
# the grades collection contains these columns: '_id', 'student_id', 'scores' {'type', 'score'}, and 'class_id'
dbConnection$count() # count number of elements
dbConnection$iterate()$one() # iterate through elements by increments of one

# Putting this data into a table
df <- as.data.frame(dbConnection$find())
df <- df %>% tidyr::unnest(scores) # remove the nesting
tibble <- as_tibble(df)
view(tibble)

# Checking for missing values. There happen to be none
if(sum(is.na(df)) > 0){
  print("There are missing values")
}

# Extracting out the columns of this table into a vector
student_id_vector <- as.integer(tibble$student_id)
assignment_types_vector <- as.character(tibble$type)
scores_vector <- as.integer(tibble$score)
classes_vector <- as.integer(tibble$class_id)

number_of_students <- length(unique(student_id_vector))
number_of_students
number_of_classes <- length(unique(classes_vector))
number_of_classes
number_of_assignment_types <- length(unique(assignment_types_vector))
number_of_assignment_types
number_of_assignments_taken <- length(tibble$score)
number_of_assignments_taken

# Performing some basic calculations
summary(scores_vector)

# Visualizing the data
ggplot(data = tibble) + 
  geom_point(mapping = aes(x = classes_vector, y = scores_vector))