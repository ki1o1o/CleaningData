#Codebook
##Getting and Cleaning Data, Course Project April 2015

##Configuration

The following analysis was undertaken on a MacBook Air running OSX 10.9.5 "Mavericks", R version 3.1.3 (2015-03-09, "Smooth Sidewalk"), using RStudio Version 0.98.1091. The dplyr package is required to run run_analysis.R.


##Description of Raw Data

The information in this section is largely reproduced from the readme.txt accompanying the original data set, credit goes to [Reyes-Ortiz, Anguita, Ghio and Oneto (2012)](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). 

####Human Activity Recognition Using Smartphones Dataset Version 1.0
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit‡ degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

####For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

####The dataset includes the following files:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

####Notes: 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

####License:
Use of this dataset in publications must be acknowledged by referencing the following publication: 

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.


##Description of run_analysis.R

run_analysis.R does the following in order:

- Set working directory
- If none exists, create data folder
- Download and unzip data
- Set file path
- Read data
	- Training data
		- File X-train.txt (measurements)
		- File Y_train.txt (activities
		- File subject_train.txt (subject IDs)
	- Test data
		- File X-test.txt (measurements)
		- File Y_test.txt (activities
		- File subject_test.txt (subject IDs)
	- File features.txt (feature labels)
	- File activity_labels.txt (activity labels)
- Merge training and test datasets into one dataset called allData
- Isolate variables concerned with mean or standard deviation in a vector containing only those feature numbers this project is interested in: The approach taken here considers only features that make explicit use of either mean() or std() in their label as relevant to this step.
- Use this vector to reduce the features dataset to the relevant features
- Appropriately re-name the features in that dataset for later use as column names to the dataset containing the test/training measurements. The following changes are made:
	- ( ) and - are removed
	- mean is replaced by Mean
	- std is replaced by Std
	- prefix t is replaced by time
	- Acc is replaced by Accelerometer
	- Gyro is replaced by Gyroscope
	- prefix f is replaced by frequency
	- Mag is replaced by Magnitude
	- BodyBody is replaced by Body
- Create a dataset called SelectData where irrelevant columns from allData are removed, and additional columns for activity and subject added.
- Add column names tp SelectData using the features dataset and create column names for activity and subject
- Descriptively name the activities in SelectData by the means of a loop that replaces the activity numbers with activity labels from the activity labels dataset.
- Create a tidy, ordered data set that contains the average measurement of each relevant feature for each subject and activity.
- Write the tidy dataset called TidyData in a file called tidydata.txt.

```
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
```

##Description of Tidy Data Variables
The tidy dataset is a dataframe containing 180 observations of 68 variables. 

```
> str(TidyData)
'data.frame':	180 obs. of  68 variables:
 $ Subject                               : int  1 1 1 1 1 1 2 2 2 2 ...
 $ Activity                              : chr  "LAYING" "SITTING" "STANDING" "WALKING" ...
 $ TimeBodyAccelerometerMeanX            : num  0.222 0.261 0.279 0.277 0.289 ...
 $ TimeBodyAccelerometerMeanY            : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
 $ TimeBodyAccelerometerMeanZ            : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
 $ TimeBodyAccelerometerStdX             : num  -0.928 -0.977 -0.996 -0.284 0.03 ...
 $ TimeBodyAccelerometerStdY             : num  -0.8368 -0.9226 -0.9732 0.1145 -0.0319 ...
 $ TimeBodyAccelerometerStdZ             : num  -0.826 -0.94 -0.98 -0.26 -0.23 ...
 $ TimeGravityAccelerometerMeanX         : num  -0.249 0.832 0.943 0.935 0.932 ...
 $ TimeGravityAccelerometerMeanY         : num  0.706 0.204 -0.273 -0.282 -0.267 ...
 $ TimeGravityAccelerometerMeanZ         : num  0.4458 0.332 0.0135 -0.0681 -0.0621 ...
 $ TimeGravityAccelerometerStdX          : num  -0.897 -0.968 -0.994 -0.977 -0.951 ...
 $ TimeGravityAccelerometerStdY          : num  -0.908 -0.936 -0.981 -0.971 -0.937 ...
 $ TimeGravityAccelerometerStdZ          : num  -0.852 -0.949 -0.976 -0.948 -0.896 ...
 $ TimeBodyAccelerometerJerkMeanX        : num  0.0811 0.0775 0.0754 0.074 0.0542 ...
 $ TimeBodyAccelerometerJerkMeanY        : num  0.003838 -0.000619 0.007976 0.028272 0.02965 ...
 $ TimeBodyAccelerometerJerkMeanZ        : num  0.01083 -0.00337 -0.00369 -0.00417 -0.01097 ...
 $ TimeBodyAccelerometerJerkStdX         : num  -0.9585 -0.9864 -0.9946 -0.1136 -0.0123 ...
 $ TimeBodyAccelerometerJerkStdY         : num  -0.924 -0.981 -0.986 0.067 -0.102 ...
 $ TimeBodyAccelerometerJerkStdZ         : num  -0.955 -0.988 -0.992 -0.503 -0.346 ...
 $ TimeBodyGyroscopeMeanX                : num  -0.0166 -0.0454 -0.024 -0.0418 -0.0351 ...
 $ TimeBodyGyroscopeMeanY                : num  -0.0645 -0.0919 -0.0594 -0.0695 -0.0909 ...
 $ TimeBodyGyroscopeMeanZ                : num  0.1487 0.0629 0.0748 0.0849 0.0901 ...
 $ TimeBodyGyroscopeStdX                 : num  -0.874 -0.977 -0.987 -0.474 -0.458 ...
 $ TimeBodyGyroscopeStdY                 : num  -0.9511 -0.9665 -0.9877 -0.0546 -0.1263 ...
 $ TimeBodyGyroscopeStdZ                 : num  -0.908 -0.941 -0.981 -0.344 -0.125 ...
 $ TimeBodyGyroscopeJerkMeanX            : num  -0.1073 -0.0937 -0.0996 -0.09 -0.074 ...
 $ TimeBodyGyroscopeJerkMeanY            : num  -0.0415 -0.0402 -0.0441 -0.0398 -0.044 ...
 $ TimeBodyGyroscopeJerkMeanZ            : num  -0.0741 -0.0467 -0.049 -0.0461 -0.027 ...
 $ TimeBodyGyroscopeJerkStdX             : num  -0.919 -0.992 -0.993 -0.207 -0.487 ...
 $ TimeBodyGyroscopeJerkStdY             : num  -0.968 -0.99 -0.995 -0.304 -0.239 ...
 $ TimeBodyGyroscopeJerkStdZ             : num  -0.958 -0.988 -0.992 -0.404 -0.269 ...
 $ TimeBodyAccelerometerMagnitudeMean    : num  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
 $ TimeBodyAccelerometerMagnitudeStd     : num  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
 $ TimeGravityAccelerometerMagnitudeMean : num  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
 $ TimeGravityAccelerometerMagnitudeStd  : num  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
 $ TimeBodyAccelerometerJerkMagnitudeMean: num  -0.9544 -0.9874 -0.9924 -0.1414 -0.0894 ...
 $ TimeBodyAccelerometerJerkMagnitudeStd : num  -0.9282 -0.9841 -0.9931 -0.0745 -0.0258 ...
 $ TimeBodyGyroscopeMagnitudeMean        : num  -0.8748 -0.9309 -0.9765 -0.161 -0.0757 ...
 $ TimeBodyGyroscopeMagnitudeStd         : num  -0.819 -0.935 -0.979 -0.187 -0.226 ...
 $ TimeBodyGyroscopeJerkMagnitudeMean    : num  -0.963 -0.992 -0.995 -0.299 -0.295 ...
 $ TimeBodyGyroscopeJerkMagnitudeStd     : num  -0.936 -0.988 -0.995 -0.325 -0.307 ...
 $ FreqBodyAccelerometerMeanX            : num  -0.9391 -0.9796 -0.9952 -0.2028 0.0382 ...
 $ FreqBodyAccelerometerMeanY            : num  -0.86707 -0.94408 -0.97707 0.08971 0.00155 ...
 $ FreqBodyAccelerometerMeanZ            : num  -0.883 -0.959 -0.985 -0.332 -0.226 ...
 $ FreqBodyAccelerometerStdX             : num  -0.9244 -0.9764 -0.996 -0.3191 0.0243 ...
 $ FreqBodyAccelerometerStdY             : num  -0.834 -0.917 -0.972 0.056 -0.113 ...
 $ FreqBodyAccelerometerStdZ             : num  -0.813 -0.934 -0.978 -0.28 -0.298 ...
 $ FreqBodyAccelerometerJerkMeanX        : num  -0.9571 -0.9866 -0.9946 -0.1705 -0.0277 ...
 $ FreqBodyAccelerometerJerkMeanY        : num  -0.9225 -0.9816 -0.9854 -0.0352 -0.1287 ...
 $ FreqBodyAccelerometerJerkMeanZ        : num  -0.948 -0.986 -0.991 -0.469 -0.288 ...
 $ FreqBodyAccelerometerJerkStdX         : num  -0.9642 -0.9875 -0.9951 -0.1336 -0.0863 ...
 $ FreqBodyAccelerometerJerkStdY         : num  -0.932 -0.983 -0.987 0.107 -0.135 ...
 $ FreqBodyAccelerometerJerkStdZ         : num  -0.961 -0.988 -0.992 -0.535 -0.402 ...
 $ FreqBodyGyroscopeMeanX                : num  -0.85 -0.976 -0.986 -0.339 -0.352 ...
 $ FreqBodyGyroscopeMeanY                : num  -0.9522 -0.9758 -0.989 -0.1031 -0.0557 ...
 $ FreqBodyGyroscopeMeanZ                : num  -0.9093 -0.9513 -0.9808 -0.2559 -0.0319 ...
 $ FreqBodyGyroscopeStdX                 : num  -0.882 -0.978 -0.987 -0.517 -0.495 ...
 $ FreqBodyGyroscopeStdY                 : num  -0.9512 -0.9623 -0.9871 -0.0335 -0.1814 ...
 $ FreqBodyGyroscopeStdZ                 : num  -0.917 -0.944 -0.982 -0.437 -0.238 ...
 $ FreqBodyAccelerometerMagnitudeMean    : num  -0.8618 -0.9478 -0.9854 -0.1286 0.0966 ...
 $ FreqBodyAccelerometerMagnitudeStd     : num  -0.798 -0.928 -0.982 -0.398 -0.187 ...
 $ FreqBodyAccelerometerJerkMagnitudeMean: num  -0.9333 -0.9853 -0.9925 -0.0571 0.0262 ...
 $ FreqBodyAccelerometerJerkMagnitudeStd : num  -0.922 -0.982 -0.993 -0.103 -0.104 ...
 $ FreqBodyGyroscopeMagnitudeMean        : num  -0.862 -0.958 -0.985 -0.199 -0.186 ...
 $ FreqBodyGyroscopeMagnitudeStd         : num  -0.824 -0.932 -0.978 -0.321 -0.398 ...
 $ FreqBodyGyroscopeJerkMagnitudeMean    : num  -0.942 -0.99 -0.995 -0.319 -0.282 ...
 $ FreqBodyGyroscopeJerkMagnitudeStd     : num  -0.933 -0.987 -0.995 -0.382 -0.392 ...
```

The required textfile is uploaded to the Coursera platform.

