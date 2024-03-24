DataLoader <- R6Class("DataLoader",
                       public = list(
                         initialize = function() {},
                         
                         
                         setUserCredentials = function(
    
                           usernameArg = NA,
                           passwordArg = NA
                        ){
                           
                           private$usernameArg = usernameArg
                           private$passwordArg = passwordArg
                         },
                        
                        setCluster = function (
                          clusterArg = NA
                        ){
                          
                          private$clusterArg = clusterArg
                        },
                         
                         setMongoDBCollection = function(
                          collectionArg = NA,
                          dbArg = NA
                          ){
                           private$collectionArg = collectionArg
                           private$dbArg = dbArg
                         },
                         
                         retrieveDataFromMongoDBCollection = function (){
                           #Connect to Mongo DB
                           connection_string = paste('mongodb+srv://', private$usernameArg, ':', private$passwordArg, '@', private$clusterArg, '.hfcmwd0.mongodb.net/?retryWrites=true&w=majority&appName=', toupper(private$clusterArg), sep="") # Kory's connection string
                           dbConnection = mongo(collection=private$collectionArg, db=private$dbArg, url=connection_string) # Indicate that we want to access the grades collection in the sample training DB
                           dbConnection$count() # count number of elements
                           dbConnection$iterate()$one() # iterate through elements by increments of one
                           
                           # Putting this data into a table
                           private$dataset <- as_tibble(dbConnection$find())
                           
                           return(private$dataset)
                         },
                         
                         retrieveDataFromCSVFile = function(){
                           
                         }
                         
                         
                       ),
                       
                       private = list(
                         dataset = NULL,
                         collectionArg = NULL,
                         dbArg = NULL,
                         usernameArg = NULL,
                         passwordArg = NULL,
                         clusterArg = NULL
                       )
)


DataTransformer <- R6Class("DataTransformer",
  public = list(
    setDataset = function(ds) {
      private$dataset <- ds
    },
    
    unnestAColumn = function(
      column = NA
      ){
      private$dataset <- private$dataset %>% tidyr::unnest(column) # remove the nesting
    },
    
    returnDataset = function(){
      return(private$dataset)
    }
    
    
  ),

  private = list(
    dataset = NULL
    
  )

)


DataAnalyzer <- R6Class("DataAnalyzer",
                  public = list(
                    initialize = function() {},
                    
                    setDataset = function(ds) {
                      private$dataset <- ds
                    },
                    
                    calculateNumberOfColumns = function(){
                      private$numberOfColumns = ncol(private$dataset)
                    },
                    
                    
                    
                    outputNumberOfColumns = function(){
                      cat("There are", toString(private$numberOfColumns), "columns", sep = " ")
                    },
                    
                    
                    calculateNumberOfRows = function(){
                      for(iterator in seq(1, private$numberOfColumns)){
                        private$numberOfRows[iterator] = length(unique(private$dataset[[iterator]]))
                      }
                    },
                    
                    setNamesOfRows = function(){
                      names(private$numberOfRows) <- names(private$dataset)
                      names(private$numberOfRows) <- paste(names(private$numberOfRows), "rows", sep = " ")
                    },
                    
                    outputNumberOfRows = function(){
                     print(private$numberOfRows)
                    },
                    
                    returnNumberOfRows = function(){
                      return(private$numberOfRows)
                    },
                    
                    calculateNumberOfMissingValues = function(){
                      private$numberOfMissingValues = sum(is.na(private$dataset))
                    },
                    
                    outputNumberOfMissingValues = function() {
                      if(private$numberOfMissingValues > 0){
                        cat("There are", private$numberOfMissingValues, "missing values\n", sep = " ")
                      }
                      else{
                        print("There are no missing values")
                      }
                      
                    },
                    
                    returnNumberOfMissingValues = function(){
                      return(private$numberOfMissingValues)
                    },
                    
                    
                    
                    
                    
                    
                    calculateMean = function(of = NA){
                      private$meanCalculation = mean(of)
                    },
                    
                    calculateMedian = function(of = NA){
                      private$medianCalculation = median(of)
                    },
                    
                    calculateMaximum = function(of = NA){
                      private$maximumCalculation = max(of)
                    },
                    
                    calculateMinimum = function(of = NA){
                      private$minimumCalculation = min(of)
                    },
                    
                    
                    calculate1stQuartile = function(of = NA){
                      private$FirstQuartileCalculation = quantile(of, 0.25)
                    },
                    
                    calculate3rdQuartile = function(of = NA){
                      private$ThirdQuartileCalculation = quantile(of, 0.75)
                    },
                    
                    
                    
                    calculateStandardDeviation = function(of = NA){
                      private$standardDeviationCalculation = sd(of)
                    },
                    
                    calculateZScore = function(of = NA){
                      private$ZScoreCalculation = ((of - private$meanCalculation) / private$standardDeviationCalculation)
                    },
                    
                    outputMean = function(){
                      cat("The mean is", private$meanCalculation, "\n", sep = " ")
                    },
                    
                    outputMedian = function(){
                      cat("The median is", private$medianCalculation, "\n", sep = " ")
                    },
                    
                    outputMaximum = function(){
                      cat("The maximum is", private$maximumCalculation, "\n", sep = " ")
                    },
                    
                    outputMinimum = function(){
                      cat("The minimum is", private$minimumCalculation, "\n", sep = " ")
                    },
                    
                    output1stQuartile = function(){
                      cat("The 1st quartile is", private$FirstQuartileCalculation, "\n", sep = " ")
                    },
                    
                    output3rdQuartile = function(){
                      cat("The 3rd quartile is", private$ThirdQuartileCalculation, "\n", sep = " ")
                    },
                    
                    
                    
                    
                    outputStandardDeviation = function(){
                      cat("The standard deviation is", private$standardDeviationCalculation, "\n", sep = " ")
                    },
                    
                    outputZScore = function(){
                      cat("The z-score is", private$ZScoreCalculation, "\n", sep = " ")
                      
                      roundedZScore = round(private$ZScoreCalculation)
                      
                      if( (roundedZScore > 2) && (roundedZScore < 3) ){
                        print("it is significantly above the mean")
                      }
                      else if( (roundedZScore < - 2) && (roundedZScore > -3)){
                        print("it is significantly below the mean")
                      }
                      else if( (roundedZScore > 3) || (roundedZScore < - 3) ){
                        print("it has an extremely rare value")
                      }
                      else{
                        print("it has a close-ish to average value")
                      }
                      
                        
                      
                    },
                    
                    returnMean = function(){
                      return(private$meanCalculation)
                    },
                    
                    returnMedian = function(){
                      return(private$medianCalculation)
                    },
                    
                    returnMaximum = function(){
                      return(private$maximumCalculation)
                    },
                    
                    returnMinimum = function(){
                      return(private$minimumCalculation)
                    },
                    
                    return1stQuartile = function(){
                      return(private$FirstQuartileCalculation)
                    },
                    
                    return3rdQuartile = function(){
                      return(private$ThirdQuartileCalculation)
                    },
                    
                    returnStandardDeviation = function(){
                      return(private$standardDeviationCalculation)
                    },
                    
                    
                    returnZScore = function(){
                      return(private$ZScoreCalculation)
                    }
                    
                    
                  ),
                  
                  private = list(
                    dataset = NULL,
                    numberOfMissingValues = NULL,
                    numberOfColumns = NULL,
                    numberOfRows = NULL,
                    meanCalculation = NULL,
                    medianCalculation = NULL,
                    maximumCalculation = NULL,
                    minimumCalculation = NULL,
                    FirstQuartileCalculation = NULL,
                    ThirdQuartileCalculation = NULL,
                    standardDeviationCalculation = NULL,
                    ZScoreCalculation = NULL
                  )
                  
    )




DataViewer <- R6Class("DataViewer",
                      
                      public = list(
                        setDatasetAndDatasetName = function(ds = NA, dsName = NA) {
                          private$dataset <- ds
                          private$datasetName <- dsName
                        },
                        
                        viewDataset = function(){
                          view(private$dataset, private$datasetName)
                        }
                        
                      ),
                      
                      private = list(
                        dataset = NULL,
                        datasetName = NULL
                      )
                      
)




DataVisualizer <- R6Class("DataVisualizer",
                      
                      public = list(
                        setDataset = function(ds = NA) {
                          private$dataset <- ds
                        },
                        
                        graphScatterPlot = function(xArg, yArg){
                          ggplot(data = private$dataset) + 
                          geom_point(mapping = aes(x = xArg, y = yArg))
                        },
                        
                        
                        graphHistogram = function(xArg, binsArg, colorsArg, titleArg, xAxisLabelArg, yAxisLabelArg){

                          ggplot(data = private$dataset, aes(x=xArg)) + geom_histogram(bins=binsArg, fill=colorsArg) + xlab(xAxisLabelArg) + ylab(yAxisLabelArg) + ggtitle(titleArg)
                       
                          
                          
                           }
                        
                      ),
                      
                      private = list(
                        dataset = NULL
                      )
                      
)