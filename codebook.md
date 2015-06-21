# Codebook for the Course project assignment

The course project is based on the following dataset http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

## Data processing script overview

The script **run_analysis.R** processes training and test dataset and creates a tidy data file for further analysis.

The script performs the 5 steps described in the course project's definition:

1.  Downloads and unzips datafiles. Loads data to the RStudio workspace and merges the training and the test sets to create one data frame.

    The following variables are created during this step:
    
    - *features_names* - names of all features measured during the study (created from features.txt file)
    - *activity_names* - names of all activities performed by subjects of the study (created from activity_labels.txt file)
    - *df_test* - data frame containing measurements of features for each activity and each subject (test dataset)
    - *df_train* - data frame containing measurements of features for each activity and each subject (training dataset)
    - *df* - merged dataframe containing *df_test* and *df_train*

2.  Extracts only the measurements on the mean and standard deviation for each measurement using grepl function

    The following variables are created during this step:

    - *df_mean_std* - data frame that containg only columns for mean and std measurements of features

3. Uses descriptive activity names to name the activities in the data set. 

    activity_id column in *df_mean_std* is replaced with corresponding decriptive names using *activity_names* variable


4. Appropriately labels the data set with descriptive variable names using gsub function

    feature columns in *df_mean_std* are modified to be more descriptive

5. Produces a final tidy dataframe with mean values of every feature for each activity and subject.

    The output file is called **tidy.txt**.


