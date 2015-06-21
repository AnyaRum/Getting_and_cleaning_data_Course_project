##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## by Anna Rumyantseva June 2015
##########################################################################################################


# Clean workspace
rm(list=ls())

# Download data and unzipping data

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists('dataUPC.zip')){
  
  download.file(url, destfile = './dataUPC.zip')
  unzip("dataUPC.zip", files = NULL, list = FALSE, overwrite = TRUE,
        junkpaths = FALSE, exdir = ".", unzip = "internal",
        setTimes = FALSE)
  
}

setwd("./UCI HAR Dataset")

##########################################################################################################
# Step 1. Merges the training and the test sets to create one data set.

## Loading data

# Names of measured features
features_names = read.table("./features.txt")
colnames(features_names) = c('n','feature')

# Activity labels and names
activity_names = read.table("./activity_labels.txt")
colnames(activity_names) = c('activity_id','activity_name')

# Training dataset

subject_train = read.table('./train/subject_train.txt')
colnames(subject_train) = 'subject_id'

activity_train = read.table('./train/y_train.txt')
colnames(activity_train) = 'activity_id'

data_train = read.table('./train/X_train.txt')
colnames(data_train) = features_names$feature

df_train = cbind(subject_train, activity_train, data_train)

# Test dataset

subject_test = read.table('./test/subject_test.txt')
colnames(subject_test) = 'subject_id'

activity_test = read.table('./test/y_test.txt')
colnames(activity_test) = 'activity_id'

data_test = read.table('./test/X_test.txt')
colnames(data_test) = features_names$feature

df_test = cbind(subject_test, activity_test, data_test)

# Merging two frames together

df = rbind(df_train, df_test)

##########################################################################################################
# Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.

feature_subset_id = grepl("std()", features_names$feature, fixed = TRUE) | grepl("mean()", features_names$feature, fixed = TRUE)

df_mean_std = df[, c(TRUE, TRUE, feature_subset_id)]

##########################################################################################################
# Step 3. Uses descriptive activity names to name the activities in the data set

df_mean_std$activity_id = factor(df_mean_std$activity_id)

levels(df_mean_std$activity_id) <- activity_names$activity_name

##########################################################################################################
# Step 4. Appropriately labels the data set with descriptive variable names. 

colNames = colnames(df_mean_std)

for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std","STD",colNames[i])
  colNames[i] = gsub("-mean","MEAN",colNames[i])
  colNames[i] = gsub("^(t)","time ",colNames[i])
  colNames[i] = gsub("^(f)","freq ",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity_",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body_",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro_",colNames[i])
  colNames[i] = gsub("Mag","Magnitude_",colNames[i])
  colNames[i] = gsub("Acc","Acceleration_",colNames[i])
  colNames[i] = gsub("Jerk","Jerk_",colNames[i])
  colNames[i] = gsub("_STD"," STD",colNames[i])
  colNames[i] = gsub("_MEAN"," MEAN",colNames[i])
  colNames[i] = gsub("-X"," (X)",colNames[i])
  colNames[i] = gsub("-Y"," (Y)",colNames[i])
  colNames[i] = gsub("-Z"," (Z)",colNames[i])
}

##########################################################################################################
# Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_table = aggregate(.~ subject_id + activity_id, data = df_mean_std, FUN= "mean" )
colnames(tidy_table) = colNames


## Saving the tidy dataset

write.table(tidy_table, file = "tidy.txt")
