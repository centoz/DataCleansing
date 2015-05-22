######################################################
## R file to merge the training and test datasets
## for UCI HAR / smartphone data for mean and standard
## deviation measurements only. Calculates a summary
## by activity and subject and exports results to 
## text file.
######################################################

# Check that required data files are located in
# the "Assignment" and related folders
requiredFiles <- c("Assignment/activity_labels.txt", 
                   "Assignment/features.txt",
                   "Assignment/test/subject_test.txt",
                   "Assignment/test/X_test.txt",
                   "Assignment/test/y_test.txt",
                   "Assignment/train/subject_train.txt",
                   "Assignment/train/X_train.txt",
                   "Assignment/train/y_train.txt")

for (filename in requiredFiles) {
    if(!file.exists(filename)) {
        stop(c("Data file missing: ", filename))
    }
}

# Load required packages
library(dplyr)

# Read activity labels and features
activityLabels <- read.table("Assignment/activity_labels.txt", 
                             col.names = c("ActivityId", "Activity"))
features <- read.table("Assignment/features.txt", 
                       col.names = c("FeatureId", "FeatureDesc"),
                       colClasses = "character")

# Read training dataset
subjectTrain <- read.table("Assignment/train/subject_train.txt")
xTrain <- read.table("Assignment/train/x_train.txt")
yTrain <- read.table("Assignment/train/y_train.txt")
trainData <- cbind(subjectTrain, yTrain, xTrain)

# Read test dataset
subjectTest <- read.table("Assignment/test/subject_test.txt")
xTest <- read.table("Assignment/test/x_test.txt")
yTest <- read.table("Assignment/test/y_test.txt")
testData <- cbind(subjectTest, yTest, xTest)

# Combine both datasets
data <- rbind(trainData, testData)
names(data) <- c("Subject", "ActivityId", features$FeatureDesc)


# Obtain only columns with "mean" and "std" by getting their
#  column number and then doing a sort to keep column order
meanCols <- grep("mean", names(data))
stdCols <- grep("std", names(data))
columns <- sort(as.numeric(c(meanCols, stdCols)))

# Match the activity Id numbers with descriptions
data2 <- data[, c(1, 2, columns)]
data3 <- inner_join(data2, activityLabels, by = c("ActivityId" = "ActivityId"))
#data3 <- data3[, c(1, 82, 3:81)]

# Clean variable names by removing dashes and
#   brackets and replacing them with _
names(data3) <- sub("-", "_", names(data3), fixed = TRUE)
names(data3) <- sub("()-", "_", names(data3), fixed = TRUE)
names(data3) <- sub("()", "", names(data3), fixed = TRUE)

# Define grouping and calculate mean for each variable
group <- group_by(data3, Subject, Activity)
dataTidy <- summarise_each(group, funs(mean))

# Write the dataset as text file
write.table(dataTidy, file = "results.txt", row.names = FALSE)