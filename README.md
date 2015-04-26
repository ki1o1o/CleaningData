#Getting and Cleaning Data | Course Project

This repository contains the work completed in partial fulfilment of the Johns Hopkins coursera course [Getting and Cleaning Data](https://www.coursera.org/course/getdata), completed in April 2015 as part of the [Data Science Specialisation](https://www.coursera.org/specialization/jhudatascience/1?utm_medium=courseDescripTop).


#The Project

Verbatim from the course website:

*The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.*

*One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:*

*http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones* 

*Here are the data for the project:* 

*https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip* 

*You should create one R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.*

*Good luck!*



#This Repository
In addition to the present readme.md file, which outlines the project and the work done to complete it, this repository contains the following:

- **run_analysis.R** (an R script that transforms the "raw" data set into a tidy one)
- **codebook.md** (documentation of the process of tidying the data set, including a description of the variables)    


#Description of run_analysis.R

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
