# Getting and Cleaning Data - Coursera Course Project
## What is in here?

This repo contains solution to the [Coursera](https://www.coursera.org) course ["Getting And Cleaning Data"](https://class.coursera.org/getdata-002) project.

## What should I look for?
run_analysis.R is the R script that runs an analysis on the Samsung Galaxy S smartphone [UCI HAR dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## What does the script do?
The script

1. Downloads and extracts the UCI HAR zip file to into the working directory
2. Reads the data into data frames
3. Merges training and test datasets
4. Created a dataset that includes only the measurements on the mean and standard deviation for each measurement
5. Writes that dataset to the finaloutput folder in the working directory
6. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
7. Writes that dataset to the finaloutput folder in the working directory

The `CodeBook.md` includes more details about the variables.


## How should I run it?

1. Clone this repo
2. Run the script:

       $ Rscript run_analysis.R
       

3. Look for the final dataset at 'finaloutput/tidyds.csv'

## Any Caveats?
1. In the script, watchout for the setwd() command as it sets the working directory that is specific to my environment. I suggest you comment that.
2. The script also cleans up all the previously created environment variables. If you don't want it, comment the rm(list=ls(all=TRUE)) line
3. The script uses httpr and plyr packages. You may have to install them before running the script
