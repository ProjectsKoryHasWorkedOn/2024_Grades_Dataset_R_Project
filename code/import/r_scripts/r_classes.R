DataLoader <- R6Class(
  "DataLoader",
  public = list(
    initialize = function() {
      
    },
    
    
    setUserCredentials = function(usernameArg = NA,
                                  passwordArg = NA) {
      private$usernameArg = usernameArg
      private$passwordArg = passwordArg
    },
    
    setCluster = function (clusterArg = NA) {
      private$clusterArg = clusterArg
    },
    
    setMongoDBCollection = function(collectionArg = NA,
                                    dbArg = NA) {
      private$collectionArg = collectionArg
      private$dbArg = dbArg
    },
    
    retrieveDataFromMongoDBCollection = function () {
      #Connect to Mongo DB
      connection_string = paste(
        'mongodb+srv://',
        private$usernameArg,
        ':',
        private$passwordArg,
        '@',
        private$clusterArg,
        '.hfcmwd0.mongodb.net/?retryWrites=true&w=majority&appName=',
        toupper(private$clusterArg),
        sep = ""
      ) # Kory's connection string
      dbConnection = mongo(
        collection = private$collectionArg,
        db = private$dbArg,
        url = connection_string
      ) # Indicate that we want to access the grades collection in the sample training DB
      dbConnection$count() # count number of elements
      dbConnection$iterate()$one() # iterate through elements by increments of one
      
      # Putting this data into a table
      private$dataset <-
        as_tibble(dbConnection$find())
      
      return(private$dataset)
    },
    
    storeDataFromCSVFile = function(csvFilename = NA) {
      # Read the file in as a tibble since that's more efficient that reading it in as a dataframe then converting it to a tibble
      private$dataset <- read_csv(file = csvFilename, show_col_types = FALSE, trim_ws = TRUE)
    },
    
    
    returnDataset = function(){
      return(private$dataset)
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


DataCleaner <- R6Class(
  "DataCleaner",
  public = list(
    setDataset = function(ds) {
      private$dataset <- ds
    },
    
    unnestAColumn = function(column = NA) {
      private$dataset <-
        private$dataset %>% tidyr::unnest(column) # remove the nesting
    },
    
    
    setNamesOfColumns = function(colNamesArg = NA){
      colnames(private$dataset) <- c(colNamesArg)
    },
    
    
    setNamesOfRowsForNumberOfRowsVectors = function() {
      names(private$numberOfRowsWithUniqueValues) <- names(private$dataset)
      names(private$numberOfRowsWithUniqueValues) <- paste(names(private$numberOfRowsWithUniqueValues), "unique rows count", sep = " ")
      
      names(private$numberOfRowsWithNonUniqueValues) <- names(private$dataset)
      names(private$numberOfRowsWithNonUniqueValues) <- paste(names(private$numberOfRowsWithNonUniqueValues), "rows count", sep = " ")
    },
    
    replaceMissingValueWithAValue = function(columnArg, valueToReplaceMissingValueWithArg){
      private$dataset[columnArg] <- replace(private$dataset[columnArg], is.na(private$dataset[columnArg]), valueToReplaceMissingValueWithArg)
    },
    
    replaceValuesEqualToXWithAValue = function(columnArg, xArg, valueToReplaceXWithArg){
      private$dataset[columnArg] <- replace(private$dataset[columnArg], private$dataset[columnArg] == xArg, valueToReplaceXWithArg)
    },
    
    replaceValuesEqualToXWithAValueAndNotEqualToXWithAnotherValue = function(columnArg, xValueArg, trueReplacementValueArg, falseReplacementValueArg){
      private$dataset[columnArg] <- ifelse(private$dataset[columnArg] == xValueArg, trueReplacementValueArg, falseReplacementValueArg)
    },
    
    putVectorIntoASingleLineWithQuotationMarksBetweenEachTerm = function(vector = NA) {
      returnValue <- as.character(vector)
      returnValue <- paste('"', vector, '"', sep = "")
      returnValue <- paste(returnValue, collapse = ",")
      return(returnValue)
      
    },
    
    removeJunkColumns = function(colsToRemoveArg = NA){
      private$dataset = subset(private$dataset, select = -c(colsToRemoveArg))
    },
    
    returnDataset = function() {
      return(private$dataset)
    }
    
    
  ),
  
  private = list(
    dataset = NULL)
  
)


DataAnalyzer <- R6Class(
  "DataAnalyzer",
  public = list(
    initialize = function() {
      
    },
    
    setDataset = function(ds) {
      private$dataset <- ds
    },
    
    calculateNumberOfColumns = function() {
      private$numberOfColumns = ncol(private$dataset)
    },
    
    
    checkForDuplicateValues = function(colArg = NA){
      duplicates <- duplicated(private$dataset[colArg])
      
      if('TRUE' %in% duplicates){
        print(paste(sum(duplicated(private$dataset[colArg])), "duplicates found", sep=" "))
        print(!unique(private$dataset[colArg]))
        
        private$duplicatesFound = TRUE
      }
      else{
        private$duplicatesFound = FALSE
      }
      
      
    },
    
    
    returnIfDuplicateValuesWereFound = function(){
      return(private$duplicatesFound)
    },
    
    
    outputNumberOfColumns = function() {
      cat("There are",
          toString(private$numberOfColumns),
          "columns",
          sep = " ")
    },
    
    
    calculateWhatUniqueValuesWeHaveInAColumn = function(columnArg){
      private$whatUniqueValuesWeHaveInAColumn <- unique(private$dataset[columnArg])
    },
    
    returnWhatUniqueValuesWeHaveInAColumn = function(){
      return(private$whatUniqueValuesWeHaveInAColumn)
    },
    
    
    calculateNumberOfRowsWithUniqueValues = function() {
      for (iterator in seq(1, private$numberOfColumns)) {
        private$numberOfRowsWithUniqueValues[iterator] = length(unique(private$dataset[[iterator]]))
      }
    },
    
    calculateNumberOfRowsWithNonUniqueValues = function() {
      for (iterator in seq(1, private$numberOfColumns)) {
        private$numberOfRowsWithNonUniqueValues[iterator] = length(private$dataset[[iterator]])
      }
    },
    
    
    outputNumberOfRowsWithUniqueValues = function() {
      print(private$numberOfRowsWithUniqueValues)
    },
    
    returnNumberOfRowsWithUniqueValues = function() {
      return(private$numberOfRowsWithUniqueValues)
    },
    
    returnNumberOfRowsWithNonUniqueValues = function() {
      return(private$numberOfRowsWithNonUniqueValues)
    },
    
    
    calculateNumberOfMissingValues = function() {
      private$numberOfMissingValues = sum(is.na(private$dataset))
    },
    
    returnNumberOfMissingValues = function(){
      return(private$numberOfMissingValues)
    },
    
    outputNumberOfMissingValues = function() {
      if (private$numberOfMissingValues > 0) {
        cat("There are",
            private$numberOfMissingValues,
            "missing values\n",
            sep = " ")
      }
      else{
        print("There are no missing values")
      }
      
    },
    
    calculateMean = function(of = NA) {
      private$meanCalculation = mean(of)
    },
    
    calculateMedian = function(of = NA) {
      private$medianCalculation <- median(of)
    },
    
    calculateMaximum = function(of = NA) {
      private$maximumCalculation <- max(of)
    },
    
    calculateMinimum = function(of = NA) {
      private$minimumCalculation <- min(of)
    },
    
    
    calculate1stQuartile = function(of = NA) {
      private$FirstQuartileCalculation <- quantile(of, 0.25)
    },
    
    calculate3rdQuartile = function(of = NA) {
      private$ThirdQuartileCalculation <- quantile(of, 0.75)
    },
    
    
    
    calculateStandardDeviation = function(of = NA) {
      private$standardDeviationCalculation = sd(of)
    },
    
    calculateZScore = function(of = NA) {
      private$ZScoreCalculation = ((of - private$meanCalculation) / private$standardDeviationCalculation)
    },
    
    calculateRangeOfValues = function(of = NA){
      private$rangeOfValues <- diff(range(of))
    },
    
    returnRangeOfValues = function(){
      return(private$rangeOfValues)
    },
    
    outputMean = function() {
      cat("The mean is", private$meanCalculation, "\n", sep = " ")
    },
    
    outputMedian = function() {
      cat("The median is", private$medianCalculation, "\n", sep = " ")
    },
    
    outputMaximum = function() {
      cat("The maximum is", private$maximumCalculation, "\n", sep = " ")
    },
    
    outputMinimum = function() {
      cat("The minimum is", private$minimumCalculation, "\n", sep = " ")
    },
    
    output1stQuartile = function() {
      cat("The 1st quartile is",
          private$FirstQuartileCalculation,
          "\n",
          sep = " ")
    },
    
    output3rdQuartile = function() {
      cat("The 3rd quartile is",
          private$ThirdQuartileCalculation,
          "\n",
          sep = " ")
    },
    
    
    
    
    outputStandardDeviation = function() {
      cat("The standard deviation is",
          private$standardDeviationCalculation,
          "\n",
          sep = " ")
    },
    
    outputZScore = function() {
      cat("The z-score is", private$ZScoreCalculation, "\n", sep = " ")
      
      roundedZScore = round(private$ZScoreCalculation)
      
      if ((roundedZScore > 2) &&
          (roundedZScore < 3)) {
        print("it is significantly above the mean")
      }
      else if ((roundedZScore < -2) &&
               (roundedZScore > -3)) {
        print("it is significantly below the mean")
      }
      else if ((roundedZScore > 3) ||
               (roundedZScore < -3)) {
        print("it has an extremely rare value")
      }
      else{
        print("it has a close-ish to average value")
      }
      
      
      
    },
    
    returnMean = function() {
      return(private$meanCalculation)
    },
    
    returnMedian = function() {
      return(private$medianCalculation)
    },
    
    returnMaximum = function() {
      return(private$maximumCalculation)
    },
    
    returnMinimum = function() {
      return(private$minimumCalculation)
    },
    
    return1stQuartile = function() {
      return(private$FirstQuartileCalculation)
    },
    
    return3rdQuartile = function() {
      return(private$ThirdQuartileCalculation)
    },
    
    returnStandardDeviation = function() {
      return(private$standardDeviationCalculation)
    },
    
    
    returnZScore = function() {
      return(private$ZScoreCalculation)
    },
    
    calculateMeanOfGroup = function(byArg = NA){
      private$meanOfGroupCalculation = aggregate(private$dataset, by = list(private$dataset[[byArg]]), mean)
    },
    
    calculateQuartileValueOfGroup = function(byArg = NA, percentageArg = NA){
      private$quartileOfGroupCalculation = aggregate.data.frame(
        x = private$dataset, 
        by = list(private$dataset[[byArg]]), 
        FUN = quantile, probs = percentageArg, 
        na.rm=TRUE )
    },
    
    
    returnMeanOfGroup = function(){
      return(private$meanOfGroupCalculation)
    },
    
    returnQuartileValueOfGroup = function(){
      return(private$quartileOfGroupCalculation)
    }
    
    
  ),
  
  private = list(
    dataset = NULL,
    numberOfMissingValues = NULL,
    numberOfColumns = NULL,
    numberOfRowsWithUniqueValues = NULL,
    numberOfRowsWithNonUniqueValues = NULL,
    meanCalculation = NULL,
    medianCalculation = NULL,
    maximumCalculation = NULL,
    minimumCalculation = NULL,
    FirstQuartileCalculation = NULL,
    ThirdQuartileCalculation = NULL,
    standardDeviationCalculation = NULL,
    ZScoreCalculation = NULL,
    meanOfGroupCalculation = NULL,
    quartileOfGroupCalculation = NULL,
    rangeOfValues = NULL,
    duplicatesFound = NULL,
    whatUniqueValuesWeHaveInAColumn = NULL
  )
  
)




DataViewer <- R6Class(
  "DataViewer",
  
  public = list(
    setDatasetAndDatasetName = function(ds = NA, dsName = NA) {
      private$dataset <- ds
      private$datasetName <- dsName
    },
    
    viewDataset = function() {
      view(private$dataset, private$datasetName)
    }
    
  ),
  
  private = list(dataset = NULL,
                 datasetName = NULL)
  
)


DataSubsetter <- R6Class(
  "DataSubsetter",
  
  public = list(
    setDatasetAndDatasetName = function(ds = NA) {
      private$dataset <- ds
    },
    
    setQuery = function(query = NA) {
      private$query <- query
    },
    
    outputQuery = function() {
      sqldf(private$query)
    },
    
    returnQueryResult = function(colNamesArg) {
      returnValue <- sqldf(private$query)
      rownames(returnValue) <- NULL
      colnames(returnValue) <- colNamesArg
      return(returnValue)
    }
    
    
  ),
  
  private = list(dataset = NULL,
                 query = NULL)
  
)








DataSupersetter <- R6Class(
  "DataSupersetter",
  
  public = list(
    
    setDataset = function(ds) {
      private$dataset <- ds
    },
    
    setSecondDataset = function(ds) {
      private$secondDataset <- ds
    },
    
    
    mergeTwoTables = function(byArg = NA){
      mergedTwoTables <- merge(private$dataset, private$secondDataset, by = byArg, all.x = TRUE)
      return(mergedTwoTables)
    }
    
  ),
  
  private = list(
    dataset = NULL,
    secondDataset = NULL)
  
)



DataVisualizer <- R6Class(
  "DataVisualizer",
  
  public = list(
    setDataset = function(ds = NA) {
      private$dataset <- ds
    },
    
    setSecondDataset = function(ds = NA) {
      private$secondDataset = ds
    },
    
    
    setThirdDataset = function(ds = NA) {
      private$thirdDataset = ds
    }, 
    
    
    
    graphScatterPlot = function(xArg, yArg) {
      ggplot(data = private$dataset) +
        geom_point(mapping = aes(x = xArg, y = yArg))
    },
    
    
    graphScatterPlotThatMakesUseOfTwoDatasets = function(x1Arg = NULL,
                                                         y1Arg = NULL,
                                                         p1Color = NULL,
                                                         p1Size = NULL,
                                                         x2Arg = NULL,
                                                         y2Arg = NULL,
                                                         p2Color = NULL,
                                                         p2Size = NULL,
                                                         gXAxisLabel = NULL,
                                                         gYAxisLabel = NULL,
                                                         gTitle = NULL,
                                                         gSubtitle = NULL,
                                                         gMinYValue = NULL,
                                                         gMaxYValue = NULL,
                                                         classesArg = NULL,
                                                         classAverageArg = NULL,
                                                         classAverageColor = NULL,
                                                         classAverageSize = NULL,
                                                         q1Arg = NULL,
                                                         q3Arg = NULL,
                                                         quartileColorArg = NULL,
                                                         p2LabelColorBackground = NULL) {
      
      roundedy2 <- round(y2Arg, digits = 2)
      
      
      
      myPlot <- ggplot() + geom_crossbar(
        mapping = aes(x = classesArg, y = classAverageArg, ymin = q1Arg, ymax = q3Arg, color = "quartiles 1-3"),
        
        width = 6) +
        geom_point(
          data = private$dataset,
          mapping = aes(x = x1Arg, y = y1Arg, color = "average of other students"),
          
          size = p1Size
        ) + geom_point(
          data = private$thirdDataset,
          mapping = aes(x = classesArg, y = classAverageArg, color = "class average"),
          size = classAverageSize,
          shape = 21
        ) + geom_point(
          data = private$secondDataset,
          mapping = aes(x = x2Arg, y = y2Arg, color = "average of selected student"),
          size = p2Size,
        ) + theme_minimal() + xlab(gXAxisLabel) + ylab(gYAxisLabel) + ggtitle(gTitle, subtitle = gSubtitle) + scale_y_continuous(limits = c(gMinYValue, gMaxYValue))  + scale_color_manual(name = "Legend", values = c(p1Color, p2Color, classAverageColor, quartileColorArg)) +  annotate(geom = "label", x = c(x2Arg), y = c(y2Arg) - 2, label = c(roundedy2), size = 1.5, fontface = 'bold', color = p2Color, fill = p2LabelColorBackground)
    
      
      return(myPlot)
      },
    
    
    graphHistogram = function(xArg = NA,
                              binsArg = NA,
                              colorsArg = NA,
                              titleArg = NA,
                              xAxisLabelArg = NA,
                              yAxisLabelArg = NA,
                              alphaArg = NA) {
      
      numberOfColors <- length(colorsArg)
      determineNumberOfTimesToRepeatInnerColorsFor <- ceiling(binsArg / numberOfColors)
      determineNumberOfTimesToRepeatOuterColorsFor <- floor(binsArg / numberOfColors)
      
      colorSequence <- c(rep(colorsArg[1], determineNumberOfTimesToRepeatOuterColorsFor), rep(colorsArg[2], determineNumberOfTimesToRepeatInnerColorsFor), rep(colorsArg[3], determineNumberOfTimesToRepeatInnerColorsFor), rep(colorsArg[4], determineNumberOfTimesToRepeatOuterColorsFor))
  
      myPlot <- ggplot(data = private$dataset, aes(x = xArg)) + geom_histogram(aes(y = ..density..), bins = binsArg, fill = colorSequence, alpha = alphaArg) + xlab(xAxisLabelArg) + ylab(yAxisLabelArg) + ggtitle(titleArg) + geom_density()
      
      return(myPlot)
      
    },
    
    calculateInvertedColors = function(colorsCountArg = NA, colorsArg = NA) {
      for(i in 1:colorsCountArg){
        arrayOfRGBValues <- col2rgb(colorsArg[i])
        
        invertedRedValue <- arrayOfRGBValues[1] *-1 + 255
        invertedGreenValue <- arrayOfRGBValues[2] *-1 + 255
        invertedBlueValue <- arrayOfRGBValues[3] *-1 + 255
        
        oppositeRGBColor <- matrix(c(invertedRedValue, invertedGreenValue, invertedBlueValue), ncol = 3)   
        oppositeHexColor <- convert_colour(oppositeRGBColor)
        
        private$colorsFound[i] <- oppositeHexColor
      }
    },
    
    
    returnColorsFound = function() {
      return(private$colorsFound)
    }
    
  ),
  
  private = list(dataset = NULL,
                 secondDataset = NULL,
                 thirdDataset = NULL,
                 colorsFound = NULL)
  
)

DataModeler <- R6Class(
  "DataModeler",
  
  public = list(
    setDatasetName = function(ds = NA) {
      private$dataset <- ds
    }
    
  ),
  
  private = list(
    dataset = NULL)
)








