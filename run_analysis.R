# Course Project for Cleaning Data

# set working directory and check for data folder
setwd("~/Documents/Coursera/2015_Data.Science.Specialization/3_Getting.and.Cleaning.Data/Course_Project")
if(!file.exists("./data")){dir.create("./data")}
library(dplyr)

# download and unzip data
dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(dataurl, destfile="./data/Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip", exdir="./data")
path <- file.path("./data", "UCI HAR Dataset")

# read data
training <- read.csv(file.path(path, "train", "X_train.txt"), sep="", header=FALSE)
training[,562] <- read.csv(file.path(path, "train", "Y_train.txt"), sep="", header=FALSE)
training[,563] <- read.csv(file.path(path,"train", "subject_train.txt"), sep="", header=FALSE)
testing <- read.csv(file.path(path, "test", "X_test.txt"), sep="", header=FALSE) 
testing[,562] <- read.csv(file.path(path, "test", "Y_test.txt"), sep="", header=FALSE)
testing[,563] <- read.csv(file.path(path, "test","subject_test.txt"), sep="", header=FALSE)
features <- read.csv(file.path(path,"features.txt"), sep="", header=FALSE)
activities <- read.csv(file.path(path,"activity_labels.txt"), sep="", header=FALSE)

# Merge training and test sets together
allData <- rbind(training, testing)

# Reduce features to mean/std and appropriately label data set
SelectFeatures <- grep("mean\\(\\)|std\\(\\)", features[,2])
features <- features[SelectFeatures,]
features[,2] <- gsub("mean", "Mean", features[,2])
features[,2] <- gsub("std", "Std", features[,2])
features[,2] <- gsub("[-()]", "", features[,2])
features[,2] <- gsub("^t", "Time", features[,2])
features[,2] <- gsub("^f", "Freq", features[,2])
features[,2] <- gsub("Acc", "Accelerometer", features[,2])
features[,2] <- gsub("Gyro", "Gyroscope", features[,2])
features[,2] <- gsub("Mag", "Magnitude", features[,2])
features[,2] <- gsub("BodyBody", "Body", features[,2])

# Remove unwanted columns from allData, name colums
SelectFeatures <- c(SelectFeatures, 562, 563)
SelectData <- allData[,SelectFeatures]
colnames(SelectData) <- c(as.character(features$V2), "Activity", "Subject")

# descriptively name the activities in the data set
activityNo = 1
for(label in activities$V2) {
        SelectData$Activity <- gsub(activityNo, label, SelectData$Activity)
        activityNo <- activityNo +1
}

# Create tidy data set
TidyData <- aggregate(. ~Subject + Activity, SelectData, mean)
TidyData <- arrange(TidyData, Subject, Activity)
write.table(TidyData, file = "tidydata.txt")

