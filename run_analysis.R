# 
# Author: Tejaswi Redkar
###############################################################################

#One of the most exciting areas in all of data science right now is wearable computing - see for example this article . 
#Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#Here are the data for the project:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#This program creates one R script called run_analysis.R that does the following. 
#1) Merges the training and the test sets to create one data set.
#2) Extracts only the measurements on the mean and standard deviation for each measurement. 
#3) Uses descriptive activity names to name the activities in the data set
#4) Appropriately labels the data set with descriptive variable names. 
#5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##############################

#Start clean by deleting all the environment variables
rm(list=ls(all=TRUE)) 
# Set the working directory to where the R file is and where the download and output files will be located.
#setwd("/Users/Tej/Documents/gettingandcleaningdatacoursera")

# Import necessary packages
library(httr) 
library(plyr)

#Global variables

#The default folder created after unzipping is UCI HAR Dataset
defaultfolder <- "UCI HAR Dataset"
#The final output will be stored in the finaloutput folder
outputfolder <- "finaloutput"

#This function downloads and unzips the dataset and also creates and output folder for saving final results.
download_datasets<-function(){
  #download the file locally
  fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  filename <- "ucihardataset.zip"
  #Check if the file exists and then download the file locally
  if(!file.exists(filename)){
    print(paste("Downloading file ", " from ", fileurl, " to ", filename))
  	download.file(fileurl, filename, method="curl")
  	print("Download complete.")
  }else
  {
    print(paste(filename, " already exists. Please delete before downloading."))
  }
  
  #If the folder exists that means that the file was already extracted.
  if(!file.exists(defaultfolder)){
  	print("Extracting file...")
    #Extract the file
  	unzip(filename, list = FALSE, overwrite = TRUE)
  	print("Extracted file")
  }else
  {
    print(paste(defaultfolder, " already exists. Please delete before extracting."))
  } 
  
  #Create the final output folder only if it doesn't exist
  if(!file.exists(outputfolder)){
  	print("Creating output folder...")
  	dir.create(outputfolder)
  	print(paste("Created output folder ", outputfolder))
  }else
  {
    print(paste(outputfolder, " already exists. Please delete before extracting."))
  }  
}

#Read a file from the specific inputfilepath and return a dataframe
#The input filepath needs to be a full path to the file (e.g. ~/Documents/dscoursera/file.csv)
getdataframe <- function (inputfilepath,cols = NULL){
	df <- data.frame()
	if(is.null(cols)){
		df <- read.table(inputfilepath,sep="",stringsAsFactors=F)
	} else {
		df <- read.table(inputfilepath,sep="",stringsAsFactors=F, col.names= cols)
	}
	return(df)
}
#Common function to save any data frame as a CSV file
saveoutput <- function (x,filename_to_save){
  filename_to_save <- paste(outputfolder, "/", filename_to_save,".csv" ,sep="")
  print(paste("Saving file ", filename_to_save))
  write.csv(x,filename_to_save)
  print(paste("Saved file ", filename_to_save))
}

#Build data frames from test and train samples and binds them into 
#a single data frame.
#The test and train datasets are in the format
#/[test or train]/subject_[test or train].txt
#/[test or train]/X_[test or train].txt
#/[test or train]/y_[test or train].txt
buildsampledataframes <- function(sampletype, features_from_file){
  x <- getdataframe(paste(defaultfolder,"/",sampletype,"/","X_",sampletype,".txt",sep=""),features_from_file$V2)
  y <- getdataframe(paste(defaultfolder,"/",sampletype,"/","y_",sampletype,".txt",sep=""),"activity")
  subject <- getdataframe(paste(defaultfolder,"/",sampletype,"/","subject_",sampletype,".txt",sep=""),"id")
  return (cbind(subject,y,x))
}

#Call the download_datasets function
download_datasets()

#Read the features from the features.txt file
features_from_file <- getdataframe(paste(defaultfolder,"features.txt",sep="/"))

#Get Test and Train data
test_data <- buildsampledataframes("test", features_from_file)
train_data <- buildsampledataframes("train", features_from_file)

#Now operate on the data frame to produce the desired output

#1. Merge train and test datasets to create one data set.
mergetrainandtest<-function(trainds, testds){
  x <- rbind(train_data, test_data)
  x <- arrange(x, id)
  return(x)
}
#Call the merge function to merge the train and test datasets
datam<-mergetrainandtest(train_data, test_data)

#2. Extract only the measurements on the mean/avg and standard deviation for each measurement. 
extractmeanstdevandsave<-function(x){
  avgstdev <- x[,c(1,2,grep("std", colnames(x)), grep("mean", colnames(x)))]
  saveoutput(avgstdev,"avgstdev")
  return(avgstdev)
}

avgstdev<-extractmeanstdevandsave(datam)

#3 and 4 Use descriptive activity names to name the activities in the dataset
# and Appropriately labels the data set with descriptive variable names.
activity_labels <- getdataframe(paste(defaultfolder,"activity_labels.txt",sep="/"))
datam$activity <- factor(datam$activity, levels=activity_labels$V1, labels=activity_labels$V2)

#5. Create a tidy data set with the average of each variable for each activity and each subject. 
createtidydsandsave<-function(dx){
  tidyds <- ddply(dx, .(id, activity), .fun=function(x){ colMeans(x[,-c(1:2)]) })
  colnames(tidyds)[-c(1:2)] <- paste(colnames(tidyds)[-c(1:2)], "_mean", sep="")
  print("Saving tidy dataset")
  saveoutput(tidyds,"tidyds")
  print("Saved tidy dataset")
  return(tidyds)
}
#Finally, create a tidy dataset
tidyds<-createtidydsandsave(avgstdev)
write.table(tidyds, file=paste(outputfolder, "tidyds.txt", sep = "/"), row.names = FALSE)