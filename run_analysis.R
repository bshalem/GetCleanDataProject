run_analysis <- function(rootdir) {
    # concatenate train data
    train <- read.table(paste(rootdir, "\\train\\subject_train.txt", sep=""))
    train <- cbind(train, read.table(paste(rootdir, "\\train\\X_train.txt", sep="")))
    train <- cbind(train, read.table(paste(rootdir, "\\train\\y_train.txt", sep="")))
    # concatenate test data
    test <- read.table(paste(rootdir, "\\test\\subject_test.txt", sep=""))
    test <- cbind(test, read.table(paste(rootdir, "\\test\\X_test.txt", sep="")))
    test <- cbind(test, read.table(paste(rootdir, "\\test\\y_test.txt", sep="")))
    # extract mean/dev measurementts
    features <- read.table(paste(rootdir, "\\features.txt", sep=""))
    meanstd <- grepl('mean|std', as.character(features$V2))
    # subset train/test
    train <- train[, c(TRUE, meanstd, TRUE)]
    test <- test[, c(TRUE, meanstd, TRUE)]
    # combine train and test
    alldata <- rbind(train, test)
    # rename columns
    colnames(alldata) <- c("ObjectId", as.character(features$V2[meanstd]), "Activity")
    colnames(alldata) <- gsub("[()]", "", names(alldata))
    # activity column descriptive names
    activity <- read.table(paste(rootdir, "\\activity_labels.txt", sep=""))
    alldata$Activity <- unlist(sapply(alldata$Activity, function(x) activity$V2[x]))
    # write tidy data
    write.table(alldata, paste(rootdir, "\\UCI HDR Tidy Dataset.txt", sep=""))
}