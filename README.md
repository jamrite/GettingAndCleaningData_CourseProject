This Repo contains the solution files for the Course Project associated with the Getting and Cleaning Data online class on www.coursera.org (https://class.coursera.org/getdata-006). This project was completed for the Aug 4th 2014 - Sep 5th 2014 session of the class.

This repo contains:

  	
        1. run_analysis.R
        This R script creates a merged data set from raw data found here:
        https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
 	
                This script 
  	
                1. merges the data appropriately a
	
                2. extracts variables with "mean" and "std" in the title
  	
                3. calculates the average (mean) of all readings per subject per activity
  
                **NOTE: for proper operation,
	
                1. Download and Unzip raw data from link above
	
                2. Set Working Directory to the top level directory of the unzipped raw data. HINT: Use setwd()
	
        2. CodeBook.md
        This CodeBook describes the contents of TidyData.txt - the tidy data set created by the run_analysis.R
