# This script...
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each
#    measurement.
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.

# Load packages and import data
library(data.table)
library(reshape2)
path <- getwd()
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

# Load activity labels and features; subset desired features (mean/std)
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("classLabels", "activityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureNames"))
featuresGood <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresGood, featureNames]
measurements <- gsub('[()]', '', measurements)

# Load training datasets
training <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresGood, with = FALSE]
data.table::setnames(training, colnames(training), measurements)
trainingActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
                            , col.names = c("Activity"))
trainingSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                          , col.names = c("SubjectNum"))
training <- cbind(trainingSubjects, trainingActivities, training)

# Load test datasets
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresGood, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
testActivities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
                        , col.names = c("Activity"))
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("SubjectNum"))
test <- cbind(testSubjects, testActivities, test)

# Merge training and test datasets (with labels)
merged <- rbind(training, test)

#Reorder in ascending order (according to subjectNum)
merged <- merged[order(merged$SubjectNum),]

# Convert classLabels to activityName
merged[["Activity"]] <- factor(merged[, Activity]
                                 , levels = activityLabels[["classLabels"]]
                                 , labels = activityLabels[["activityName"]])

# Melt and recast data
merged[["SubjectNum"]] <- as.factor(merged[, SubjectNum])
merged <- reshape2::melt(data = merged, id = c("SubjectNum", "Activity"))
merged <- reshape2::dcast(data = merged, SubjectNum + Activity ~variable, fun.aggregate = mean)

# Export tidy data
data.table::fwrite(x = merged, file = "tidyData.csv", quote = FALSE)