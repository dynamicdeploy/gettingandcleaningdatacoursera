# Code Book

This document describes the code inside `run_analysis.R`.

##Package Dependencies
### httpr
### plyr

run_analysis.R consists of the following sections:

* Global Variables
* Helper Functions
* Transformation Actions
* Function to save transformed data

## Global Variables
Global constants are accessible anywhere within the script. Since the name of the extracted folder and the output folders are constants, they are defined as global variables defaultfolder and outputfolder respectively.

## Helper Functions

### download_datasets()
This function downloads and extracts the dataset and also creates the output folder for saving final results. If the folder already contains zip and output files, the function does not take any action. You will have to delete those files and folders because the function expects a clean environment.

### getdataframe(inputfilepath,cols = NULL)
This function reads a file from the specific inputfilepath and converts it to a dataframe. The dataframe is returned back to the caller. The input filepath needs to be a full path to the file (e.g. ~/Documents/dscoursera/file.csv) or the file needs to be present in the current working directory.

Calling example:
(Reads the features from the features.txt file and returns a dataframe)
features_from_file <- getdataframe(paste(defaultfolder,"features.txt",sep="/"))

### buildsampledataframes(sampletype, features_from_file)
This function builds dataframes from test and train samples and binds them into a single data frame.
The test and train datasets in the extracted folder are in the format
'/[test or train]/subject_[test or train].txt'
'/[test or train]/X_[test or train].txt'
'/[test or train]/y_[test or train].txt'
Examples:

* 'UCI HAR Dataset/train/X_train.txt'
* 'UCI HAR Dataset/train/y_train.txt'
* 'UCI HAR Dataset/train/subject_train.txt'

* 'UCI HAR Dataset/test/X_test.txt'
* 'UCI HAR Dataset/test/y_test.txt'
* 'UCI HAR Dataset/test/subject_test.txt'

Calling example:
test_data <- buildsampledataframes("test", features_from_file)
train_data <- buildsampledataframes("train", features_from_file)

## Transformation Actions

### mergetrainandtest(trainds, testds)
Merges the train and test datasets to create one data set. The function utilizes the arrange() function from the plyr package.

Calling example:
datam<-mergetrainandtest(train_data, test_data)

datam is the merged dataframe.

### extractmeanstdevandsave(x)
This function extracts only the measurements on the mean and standard deviation for each measurement and saves the output to the avgstdev.csv file and returns the extracted dataframe. The function utilizes dataframe subsetting and grep() function on the column names.

Calling example:
avgstdev<-extractmeanstdevandsave(datam)

### Using Descriptive Activity Names
In this transformation, the program reads the "activity_labels.txt" file into a dataframe, creates a new activity column on the merged dataframe (datam), and then uses the factor() function to create descriptive names in the activity column. 

### createtidydsandsave(dx)
This function creates a tidy data set with the average of each variable for each activity and each subject. It utilizes the ddply() function to split the dataframe, apply the colMeans() function. The function saves the tidy dataset as tidyds.csv in the finaloutput directory. The function also returns the tidyds to the caller.

Calling Example:
tidyds<-createtidydsandsave(avgstdev)
If you run names() on tidayds, you should see all the column names.
> names(tidyds)
 [1] "id"                                  
 [2] "activity"                            
 [3] "tBodyAcc.std...X_mean"               
 [4] "tBodyAcc.std...Y_mean"               
 [5] "tBodyAcc.std...Z_mean"               
 [6] "tGravityAcc.std...X_mean"            
 [7] "tGravityAcc.std...Y_mean"            
 [8] "tGravityAcc.std...Z_mean"            
 [9] "tBodyAccJerk.std...X_mean"           
[10] "tBodyAccJerk.std...Y_mean"           
[11] "tBodyAccJerk.std...Z_mean"           
[12] "tBodyGyro.std...X_mean"              
[13] "tBodyGyro.std...Y_mean"              
[14] "tBodyGyro.std...Z_mean"              
[15] "tBodyGyroJerk.std...X_mean"          
[16] "tBodyGyroJerk.std...Y_mean"          
[17] "tBodyGyroJerk.std...Z_mean"          
[18] "tBodyAccMag.std.._mean"              
[19] "tGravityAccMag.std.._mean"           
[20] "tBodyAccJerkMag.std.._mean"          
[21] "tBodyGyroMag.std.._mean"             
[22] "tBodyGyroJerkMag.std.._mean"         
[23] "fBodyAcc.std...X_mean"               
[24] "fBodyAcc.std...Y_mean"               
[25] "fBodyAcc.std...Z_mean"               
[26] "fBodyAccJerk.std...X_mean"           
[27] "fBodyAccJerk.std...Y_mean"           
[28] "fBodyAccJerk.std...Z_mean"           
[29] "fBodyGyro.std...X_mean"              
[30] "fBodyGyro.std...Y_mean"              
[31] "fBodyGyro.std...Z_mean"              
[32] "fBodyAccMag.std.._mean"              
[33] "fBodyBodyAccJerkMag.std.._mean"      
[34] "fBodyBodyGyroMag.std.._mean"         
[35] "fBodyBodyGyroJerkMag.std.._mean"     
[36] "tBodyAcc.mean...X_mean"              
[37] "tBodyAcc.mean...Y_mean"              
[38] "tBodyAcc.mean...Z_mean"              
[39] "tGravityAcc.mean...X_mean"           
[40] "tGravityAcc.mean...Y_mean"           
[41] "tGravityAcc.mean...Z_mean"           
[42] "tBodyAccJerk.mean...X_mean"          
[43] "tBodyAccJerk.mean...Y_mean"          
[44] "tBodyAccJerk.mean...Z_mean"          
[45] "tBodyGyro.mean...X_mean"             
[46] "tBodyGyro.mean...Y_mean"             
[47] "tBodyGyro.mean...Z_mean"             
[48] "tBodyGyroJerk.mean...X_mean"         
[49] "tBodyGyroJerk.mean...Y_mean"         
[50] "tBodyGyroJerk.mean...Z_mean"         
[51] "tBodyAccMag.mean.._mean"             
[52] "tGravityAccMag.mean.._mean"          
[53] "tBodyAccJerkMag.mean.._mean"         
[54] "tBodyGyroMag.mean.._mean"            
[55] "tBodyGyroJerkMag.mean.._mean"        
[56] "fBodyAcc.mean...X_mean"              
[57] "fBodyAcc.mean...Y_mean"              
[58] "fBodyAcc.mean...Z_mean"              
[59] "fBodyAcc.meanFreq...X_mean"          
[60] "fBodyAcc.meanFreq...Y_mean"          
[61] "fBodyAcc.meanFreq...Z_mean"          
[62] "fBodyAccJerk.mean...X_mean"          
[63] "fBodyAccJerk.mean...Y_mean"          
[64] "fBodyAccJerk.mean...Z_mean"          
[65] "fBodyAccJerk.meanFreq...X_mean"      
[66] "fBodyAccJerk.meanFreq...Y_mean"      
[67] "fBodyAccJerk.meanFreq...Z_mean"      
[68] "fBodyGyro.mean...X_mean"             
[69] "fBodyGyro.mean...Y_mean"             
[70] "fBodyGyro.mean...Z_mean"             
[71] "fBodyGyro.meanFreq...X_mean"         
[72] "fBodyGyro.meanFreq...Y_mean"         
[73] "fBodyGyro.meanFreq...Z_mean"         
[74] "fBodyAccMag.mean.._mean"             
[75] "fBodyAccMag.meanFreq.._mean"         
[76] "fBodyBodyAccJerkMag.mean.._mean"     
[77] "fBodyBodyAccJerkMag.meanFreq.._mean" 
[78] "fBodyBodyGyroMag.mean.._mean"        
[79] "fBodyBodyGyroMag.meanFreq.._mean"    
[80] "fBodyBodyGyroJerkMag.mean.._mean"    
[81] "fBodyBodyGyroJerkMag.meanFreq.._mean"

##Function to save transformed data

### saveoutput(x,filename_to_save)
This is a common function to save any data frame as a CSV file. This function is used multiple times to save the dataframes to CSV.

