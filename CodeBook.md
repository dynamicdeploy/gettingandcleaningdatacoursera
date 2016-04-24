# Code Book

This document describes the code inside `run_analysis.R`.

##Package Dependencies
* httr
* plyr

`run_analysis.R` consists of the following sections:

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

#### Summary of tidyds
> summary(tidyds)
       id          activity   tBodyAcc.std...X_mean tBodyAcc.std...Y_mean
 Min.   : 1.0   Min.   :1.0   Min.   :-0.9961       Min.   :-0.99024     
 1st Qu.: 8.0   1st Qu.:2.0   1st Qu.:-0.9799       1st Qu.:-0.94205     
 Median :15.5   Median :3.5   Median :-0.7526       Median :-0.50897     
 Mean   :15.5   Mean   :3.5   Mean   :-0.5577       Mean   :-0.46046     
 3rd Qu.:23.0   3rd Qu.:5.0   3rd Qu.:-0.1984       3rd Qu.:-0.03077     
 Max.   :30.0   Max.   :6.0   Max.   : 0.6269       Max.   : 0.61694     
 tBodyAcc.std...Z_mean tGravityAcc.std...X_mean tGravityAcc.std...Y_mean
 Min.   :-0.9877       Min.   :-0.9968          Min.   :-0.9942         
 1st Qu.:-0.9498       1st Qu.:-0.9825          1st Qu.:-0.9711         
 Median :-0.6518       Median :-0.9695          Median :-0.9590         
 Mean   :-0.5756       Mean   :-0.9638          Mean   :-0.9524         
 3rd Qu.:-0.2306       3rd Qu.:-0.9509          3rd Qu.:-0.9370         
 Max.   : 0.6090       Max.   :-0.8296          Max.   :-0.6436         
 tGravityAcc.std...Z_mean tBodyAccJerk.std...X_mean
 Min.   :-0.9910          Min.   :-0.9946          
 1st Qu.:-0.9605          1st Qu.:-0.9832          
 Median :-0.9450          Median :-0.8104          
 Mean   :-0.9364          Mean   :-0.5949          
 3rd Qu.:-0.9180          3rd Qu.:-0.2233          
 Max.   :-0.6102          Max.   : 0.5443          
 tBodyAccJerk.std...Y_mean tBodyAccJerk.std...Z_mean
 Min.   :-0.9895           Min.   :-0.99329         
 1st Qu.:-0.9724           1st Qu.:-0.98266         
 Median :-0.7756           Median :-0.88366         
 Mean   :-0.5654           Mean   :-0.73596         
 3rd Qu.:-0.1483           3rd Qu.:-0.51212         
 Max.   : 0.3553           Max.   : 0.03102         
 tBodyGyro.std...X_mean tBodyGyro.std...Y_mean tBodyGyro.std...Z_mean
 Min.   :-0.9943        Min.   :-0.9942        Min.   :-0.9855       
 1st Qu.:-0.9735        1st Qu.:-0.9629        1st Qu.:-0.9609       
 Median :-0.7890        Median :-0.8017        Median :-0.8010       
 Mean   :-0.6916        Mean   :-0.6533        Mean   :-0.6164       
 3rd Qu.:-0.4414        3rd Qu.:-0.4196        3rd Qu.:-0.3106       
 Max.   : 0.2677        Max.   : 0.4765        Max.   : 0.5649       
 tBodyGyroJerk.std...X_mean tBodyGyroJerk.std...Y_mean
 Min.   :-0.9965            Min.   :-0.9971           
 1st Qu.:-0.9800            1st Qu.:-0.9832           
 Median :-0.8396            Median :-0.8942           
 Mean   :-0.7036            Mean   :-0.7636           
 3rd Qu.:-0.4629            3rd Qu.:-0.5861           
 Max.   : 0.1791            Max.   : 0.2959           
 tBodyGyroJerk.std...Z_mean tBodyAccMag.std.._mean
 Min.   :-0.9954            Min.   :-0.9865       
 1st Qu.:-0.9848            1st Qu.:-0.9430       
 Median :-0.8610            Median :-0.6074       
 Mean   :-0.7096            Mean   :-0.5439       
 3rd Qu.:-0.4741            3rd Qu.:-0.2090       
 Max.   : 0.1932            Max.   : 0.4284       
 tGravityAccMag.std.._mean tBodyAccJerkMag.std.._mean
 Min.   :-0.9865           Min.   :-0.9946           
 1st Qu.:-0.9430           1st Qu.:-0.9765           
 Median :-0.6074           Median :-0.8014           
 Mean   :-0.5439           Mean   :-0.5842           
 3rd Qu.:-0.2090           3rd Qu.:-0.2173           
 Max.   : 0.4284           Max.   : 0.4506           
 tBodyGyroMag.std.._mean tBodyGyroJerkMag.std.._mean fBodyAcc.std...X_mean
 Min.   :-0.9814         Min.   :-0.9977             Min.   :-0.9966      
 1st Qu.:-0.9476         1st Qu.:-0.9805             1st Qu.:-0.9820      
 Median :-0.7420         Median :-0.8809             Median :-0.7470      
 Mean   :-0.6304         Mean   :-0.7550             Mean   :-0.5522      
 3rd Qu.:-0.3602         3rd Qu.:-0.5767             3rd Qu.:-0.1966      
 Max.   : 0.3000         Max.   : 0.2502             Max.   : 0.6585      
 fBodyAcc.std...Y_mean fBodyAcc.std...Z_mean fBodyAccJerk.std...X_mean
 Min.   :-0.99068      Min.   :-0.9872       Min.   :-0.9951          
 1st Qu.:-0.94042      1st Qu.:-0.9459       1st Qu.:-0.9847          
 Median :-0.51338      Median :-0.6441       Median :-0.8254          
 Mean   :-0.48148      Mean   :-0.5824       Mean   :-0.6121          
 3rd Qu.:-0.07913      3rd Qu.:-0.2655       3rd Qu.:-0.2475          
 Max.   : 0.56019      Max.   : 0.6871       Max.   : 0.4768          
 fBodyAccJerk.std...Y_mean fBodyAccJerk.std...Z_mean
 Min.   :-0.9905           Min.   :-0.993108        
 1st Qu.:-0.9737           1st Qu.:-0.983747        
 Median :-0.7852           Median :-0.895121        
 Mean   :-0.5707           Mean   :-0.756489        
 3rd Qu.:-0.1685           3rd Qu.:-0.543787        
 Max.   : 0.3498           Max.   :-0.006236        
 fBodyGyro.std...X_mean fBodyGyro.std...Y_mean fBodyGyro.std...Z_mean
 Min.   :-0.9947        Min.   :-0.9944        Min.   :-0.9867       
 1st Qu.:-0.9750        1st Qu.:-0.9602        1st Qu.:-0.9643       
 Median :-0.8086        Median :-0.7964        Median :-0.8224       
 Mean   :-0.7110        Mean   :-0.6454        Mean   :-0.6577       
 3rd Qu.:-0.4813        3rd Qu.:-0.4154        3rd Qu.:-0.3916       
 Max.   : 0.1966        Max.   : 0.6462        Max.   : 0.5225       
 fBodyAccMag.std.._mean fBodyBodyAccJerkMag.std.._mean
 Min.   :-0.9876        Min.   :-0.9944               
 1st Qu.:-0.9452        1st Qu.:-0.9752               
 Median :-0.6513        Median :-0.8126               
 Mean   :-0.6210        Mean   :-0.5992               
 3rd Qu.:-0.3654        3rd Qu.:-0.2668               
 Max.   : 0.1787        Max.   : 0.3163               
 fBodyBodyGyroMag.std.._mean fBodyBodyGyroJerkMag.std.._mean
 Min.   :-0.9815             Min.   :-0.9976                
 1st Qu.:-0.9488             1st Qu.:-0.9802                
 Median :-0.7727             Median :-0.8941                
 Mean   :-0.6723             Mean   :-0.7715                
 3rd Qu.:-0.4277             3rd Qu.:-0.6081                
 Max.   : 0.2367             Max.   : 0.2878                
 tBodyAcc.mean...X_mean tBodyAcc.mean...Y_mean tBodyAcc.mean...Z_mean
 Min.   :0.2216         Min.   :-0.040514      Min.   :-0.15251      
 1st Qu.:0.2712         1st Qu.:-0.020022      1st Qu.:-0.11207      
 Median :0.2770         Median :-0.017262      Median :-0.10819      
 Mean   :0.2743         Mean   :-0.017876      Mean   :-0.10916      
 3rd Qu.:0.2800         3rd Qu.:-0.014936      3rd Qu.:-0.10443      
 Max.   :0.3015         Max.   :-0.001308      Max.   :-0.07538      
 tGravityAcc.mean...X_mean tGravityAcc.mean...Y_mean
 Min.   :-0.6800           Min.   :-0.47989         
 1st Qu.: 0.8376           1st Qu.:-0.23319         
 Median : 0.9208           Median :-0.12782         
 Mean   : 0.6975           Mean   :-0.01621         
 3rd Qu.: 0.9425           3rd Qu.: 0.08773         
 Max.   : 0.9745           Max.   : 0.95659         
 tGravityAcc.mean...Z_mean tBodyAccJerk.mean...X_mean
 Min.   :-0.49509          Min.   :0.04269           
 1st Qu.:-0.11726          1st Qu.:0.07396           
 Median : 0.02384          Median :0.07640           
 Mean   : 0.07413          Mean   :0.07947           
 3rd Qu.: 0.14946          3rd Qu.:0.08330           
 Max.   : 0.95787          Max.   :0.13019           
 tBodyAccJerk.mean...Y_mean tBodyAccJerk.mean...Z_mean
 Min.   :-0.0386872         Min.   :-0.067458         
 1st Qu.: 0.0004664         1st Qu.:-0.010601         
 Median : 0.0094698         Median :-0.003861         
 Mean   : 0.0075652         Mean   :-0.004953         
 3rd Qu.: 0.0134008         3rd Qu.: 0.001958         
 Max.   : 0.0568186         Max.   : 0.038053         
 tBodyGyro.mean...X_mean tBodyGyro.mean...Y_mean tBodyGyro.mean...Z_mean
 Min.   :-0.20578        Min.   :-0.20421        Min.   :-0.07245       
 1st Qu.:-0.04712        1st Qu.:-0.08955        1st Qu.: 0.07475       
 Median :-0.02871        Median :-0.07318        Median : 0.08512       
 Mean   :-0.03244        Mean   :-0.07426        Mean   : 0.08744       
 3rd Qu.:-0.01676        3rd Qu.:-0.06113        3rd Qu.: 0.10177       
 Max.   : 0.19270        Max.   : 0.02747        Max.   : 0.17910       
 tBodyGyroJerk.mean...X_mean tBodyGyroJerk.mean...Y_mean
 Min.   :-0.15721            Min.   :-0.07681           
 1st Qu.:-0.10322            1st Qu.:-0.04552           
 Median :-0.09868            Median :-0.04112           
 Mean   :-0.09606            Mean   :-0.04269           
 3rd Qu.:-0.09110            3rd Qu.:-0.03842           
 Max.   :-0.02209            Max.   :-0.01320           
 tBodyGyroJerk.mean...Z_mean tBodyAccMag.mean.._mean
 Min.   :-0.092500           Min.   :-0.9865        
 1st Qu.:-0.061725           1st Qu.:-0.9573        
 Median :-0.053430           Median :-0.4829        
 Mean   :-0.054802           Mean   :-0.4973        
 3rd Qu.:-0.048985           3rd Qu.:-0.0919        
 Max.   :-0.006941           Max.   : 0.6446        
 tGravityAccMag.mean.._mean tBodyAccJerkMag.mean.._mean
 Min.   :-0.9865            Min.   :-0.9928            
 1st Qu.:-0.9573            1st Qu.:-0.9807            
 Median :-0.4829            Median :-0.8168            
 Mean   :-0.4973            Mean   :-0.6079            
 3rd Qu.:-0.0919            3rd Qu.:-0.2456            
 Max.   : 0.6446            Max.   : 0.4345            
 tBodyGyroMag.mean.._mean tBodyGyroJerkMag.mean.._mean
 Min.   :-0.9807          Min.   :-0.99732            
 1st Qu.:-0.9461          1st Qu.:-0.98515            
 Median :-0.6551          Median :-0.86479            
 Mean   :-0.5652          Mean   :-0.73637            
 3rd Qu.:-0.2159          3rd Qu.:-0.51186            
 Max.   : 0.4180          Max.   : 0.08758            
 fBodyAcc.mean...X_mean fBodyAcc.mean...Y_mean fBodyAcc.mean...Z_mean
 Min.   :-0.9952        Min.   :-0.98903       Min.   :-0.9895       
 1st Qu.:-0.9787        1st Qu.:-0.95361       1st Qu.:-0.9619       
 Median :-0.7691        Median :-0.59498       Median :-0.7236       
 Mean   :-0.5758        Mean   :-0.48873       Mean   :-0.6297       
 3rd Qu.:-0.2174        3rd Qu.:-0.06341       3rd Qu.:-0.3183       
 Max.   : 0.5370        Max.   : 0.52419       Max.   : 0.2807       
 fBodyAcc.meanFreq...X_mean fBodyAcc.meanFreq...Y_mean
 Min.   :-0.63591           Min.   :-0.379518         
 1st Qu.:-0.39165           1st Qu.:-0.081314         
 Median :-0.25731           Median : 0.007855         
 Mean   :-0.23227           Mean   : 0.011529         
 3rd Qu.:-0.06105           3rd Qu.: 0.086281         
 Max.   : 0.15912           Max.   : 0.466528         
 fBodyAcc.meanFreq...Z_mean fBodyAccJerk.mean...X_mean
 Min.   :-0.52011           Min.   :-0.9946           
 1st Qu.:-0.03629           1st Qu.:-0.9828           
 Median : 0.06582           Median :-0.8126           
 Mean   : 0.04372           Mean   :-0.6139           
 3rd Qu.: 0.17542           3rd Qu.:-0.2820           
 Max.   : 0.40253           Max.   : 0.4743           
 fBodyAccJerk.mean...Y_mean fBodyAccJerk.mean...Z_mean
 Min.   :-0.9894            Min.   :-0.9920           
 1st Qu.:-0.9725            1st Qu.:-0.9796           
 Median :-0.7817            Median :-0.8707           
 Mean   :-0.5882            Mean   :-0.7144           
 3rd Qu.:-0.1963            3rd Qu.:-0.4697           
 Max.   : 0.2767            Max.   : 0.1578           
 fBodyAccJerk.meanFreq...X_mean fBodyAccJerk.meanFreq...Y_mean
 Min.   :-0.57604               Min.   :-0.60197              
 1st Qu.:-0.28966               1st Qu.:-0.39751              
 Median :-0.06091               Median :-0.23209              
 Mean   :-0.06910               Mean   :-0.22810              
 3rd Qu.: 0.17660               3rd Qu.:-0.04721              
 Max.   : 0.33145               Max.   : 0.19568              
 fBodyAccJerk.meanFreq...Z_mean fBodyGyro.mean...X_mean
 Min.   :-0.62756               Min.   :-0.9931        
 1st Qu.:-0.30867               1st Qu.:-0.9697        
 Median :-0.09187               Median :-0.7300        
 Mean   :-0.13760               Mean   :-0.6367        
 3rd Qu.: 0.03858               3rd Qu.:-0.3387        
 Max.   : 0.23011               Max.   : 0.4750        
 fBodyGyro.mean...Y_mean fBodyGyro.mean...Z_mean
 Min.   :-0.9940         Min.   :-0.9860        
 1st Qu.:-0.9700         1st Qu.:-0.9624        
 Median :-0.8141         Median :-0.7909        
 Mean   :-0.6767         Mean   :-0.6044        
 3rd Qu.:-0.4458         3rd Qu.:-0.2635        
 Max.   : 0.3288         Max.   : 0.4924        
 fBodyGyro.meanFreq...X_mean fBodyGyro.meanFreq...Y_mean
 Min.   :-0.395770           Min.   :-0.66681           
 1st Qu.:-0.213363           1st Qu.:-0.29433           
 Median :-0.115527           Median :-0.15794           
 Mean   :-0.104551           Mean   :-0.16741           
 3rd Qu.: 0.002655           3rd Qu.:-0.04269           
 Max.   : 0.249209           Max.   : 0.27314           
 fBodyGyro.meanFreq...Z_mean fBodyAccMag.mean.._mean
 Min.   :-0.50749            Min.   :-0.9868        
 1st Qu.:-0.15481            1st Qu.:-0.9560        
 Median :-0.05081            Median :-0.6703        
 Mean   :-0.05718            Mean   :-0.5365        
 3rd Qu.: 0.04152            3rd Qu.:-0.1622        
 Max.   : 0.37707            Max.   : 0.5866        
 fBodyAccMag.meanFreq.._mean fBodyBodyAccJerkMag.mean.._mean
 Min.   :-0.31234            Min.   :-0.9940                
 1st Qu.:-0.01475            1st Qu.:-0.9770                
 Median : 0.08132            Median :-0.7940                
 Mean   : 0.07613            Mean   :-0.5756                
 3rd Qu.: 0.17436            3rd Qu.:-0.1872                
 Max.   : 0.43585            Max.   : 0.5384                
 fBodyBodyAccJerkMag.meanFreq.._mean fBodyBodyGyroMag.mean.._mean
 Min.   :-0.12521                    Min.   :-0.9865             
 1st Qu.: 0.04527                    1st Qu.:-0.9616             
 Median : 0.17198                    Median :-0.7657             
 Mean   : 0.16255                    Mean   :-0.6671             
 3rd Qu.: 0.27593                    3rd Qu.:-0.4087             
 Max.   : 0.48809                    Max.   : 0.2040             
 fBodyBodyGyroMag.meanFreq.._mean fBodyBodyGyroJerkMag.mean.._mean
 Min.   :-0.45664                 Min.   :-0.9976                 
 1st Qu.:-0.16951                 1st Qu.:-0.9813                 
 Median :-0.05352                 Median :-0.8779                 
 Mean   :-0.03603                 Mean   :-0.7564                 
 3rd Qu.: 0.08228                 3rd Qu.:-0.5831                 
 Max.   : 0.40952                 Max.   : 0.1466                 
 fBodyBodyGyroJerkMag.meanFreq.._mean
 Min.   :-0.18292                    
 1st Qu.: 0.05423                    
 Median : 0.11156                    
 Mean   : 0.12592                    
 3rd Qu.: 0.20805                    
 Max.   : 0.42630 

##Function to save transformed data

### saveoutput(x,filename_to_save)
This is a common function to save any data frame as a CSV file. This function is used multiple times to save the dataframes to CSV.

