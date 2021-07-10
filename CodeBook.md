##This CodeBook describes the script run_analysis and the final tidy data sets produced by it.##
##################
####Input data####
##################

#1. Input data can be downloaded from the following link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#2. Once downloaded, extract the data in a folder "Data" in your working directory
#3. The dataset includes the following files:
#       - 'README.txt'
#       - 'features_info.txt': Shows information about the variables used on the feature vector.
#       - 'features.txt': List of all features.
#       - 'activity_labels.txt': Links the class labels with their activity name.
#       - 'train/X_train.txt': Training set.
#       - 'train/y_train.txt': Training labels.
#       - 'test/X_test.txt': Test set.
#       - 'test/y_test.txt': Test labels.

# NOTE: We will only refer to above files for the run_analysis.R script. Additional files in test/Inertial Signals and train/Inertial Signals have not been used.
 
###################
####Output Data####
###################

# The output data set is stored in final_tidy_data2.
# Columns:
#       -subject_id: unique identifier for the subject of the experiment
#       -datatype: name of set (training/testing) that the subject belongs too
#       -activity: type of activity being performed (refer to activity_labels.txt)
#       -signal: name of signal being used
#       -variable: function performed on signal (mean/std)
#       -direction: axial direction for which data is measured (x/y/z)
#       -mean: mean of values

########################################
####Steps to recreate tidy data sets####
########################################

# Step1   ->Read activity labels (activity_labels.txt) and features(features.txt) using read.table 
# Step2   -> Read carefully the README.txt provided with the data set
#         -> Read training and testing data from train and test folders respectively
#         -> For each dataset, there are 3 files:
#                 ->Activity for which data is collected in y_train.txt or y_test.txt
#                 ->Subject for which data is collected in subject_train.txt or subject_test.txt
#                 ->Experiment output data in X_train.txt or X_test.txt
# Step3   -> Combine the 3 files into one dataset and add column names to identify the subject, activity and features (data read from features.txt). At the end of this step you should have 1 dataset each for training and testing data.
# Step4   -> Merge the 2 data sets into one using rbind() function after adding a column to identify the type of data - training or testing. This is your final UNTIDY data
# Step5   -> To TIDY the data, extract only the data with the terms "mean(" "std(" and identifier columns (v_id,act_label,type)
# Step6   -> For consistency, remove "()" from column names and convert to lower
# Step7   -> Replace activity code by activity name (in lower), refer to activity.txt for the name and label mapping
# Step8   -> Gather the data (using gather function) on features (post converting them into factor)
# Step9   -> Separate the feature to 3 columns: feature_name, function_name (mean/std), axis (Axial vector for which information is provided). THIS GIVES YOU TIDY DATA SET (final_tidy_data1)
# Step10  -> Group the Tidy data by subject,activity,feature_name,function_name and axis
# Step11  -> Summarise the data to provide mean of values and provide proper column names. THIS GIVES YOU THE REQUIRED OUTPUT TIDY DATA SET (final_tidy_data2)
# Step12  -> Remove intermediate dataframe to save memory (optional)

