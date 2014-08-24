## This R script creates a merged data set from raw data found here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## This script 
## 1. merges the data appropriately a
## 2. extracts variables with "mean" and "std" in the title
## 3. calculates the average (mean) of all readings per subject per activity

## set working directory
## TODO: setwd("")

## read in x_train.txt. Check dimensions to verify size
train<-read.table("train/X_train.txt", header = FALSE, sep="", stringsAsFactors=FALSE);
dim(train)
#[1] 7352  561

## read in y_train.txt. Check dimensions to verify size
ytrain<-read.table("train/y_train.txt", header = FALSE, sep="", stringsAsFactors=FALSE);
dim(ytrain)
#[1] 7352    1

## read in subject_train.txt. Check dimensions to verify size
subtrain<-read.table("train/subject_train.txt", header = FALSE, sep="");
dim(subtrain)
#[1] 7352    1

## read in x_test.txt. Check dimensions to verify size
test<-read.table("test/X_test.txt", header = FALSE, sep="", stringsAsFactors=FALSE);
dim(test)
#[1] 2947  561

## read in y_test.txt. Check dimensions to verify size
ytest<-read.table("test/y_test.txt", header = FALSE, sep="", stringsAsFactors=FALSE);
dim(ytest)
#[1] 2947    1

## read in subject_test.txt. Check dimensions to verify size
subtest<-read.table("test/subject_test.txt", header = FALSE, sep="");
dim(subtest)
#[1] 2947    1

## merge x_train, y_train, subject_train. Operation adds two columns to train
trainmerged<-cbind(train, ytrain, subtrain);
dim(trainmerged)
#[1] 7352  563

## merge x_test, y_test, subject_test. Operation adds two columns to test
testmerged<-cbind(test, ytest, subtest);
dim(testmerged)
#[1] 2947  563

## merge training and test data. 10299 (7352 + 2947) rows show that frames are added properly.
merged<-rbind(trainmerged, testmerged); 
dim(merged)
#[1] 10299   563

## read in column headers for x_train and x_test data sets from features.txt. Run str on result to review contents
features<-read.table("features.txt", header = FALSE, sep="", stringsAsFactors=FALSE);
str(features)
#'data.frame':        561 obs. of  2 variables:
#$ V1: int  1 2 3 4 5 6 7 8 9 10 ...
#$ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...

## append "Activities" and "Subjects" to the features vector to create a 563 element vector of column headers for table "merged"
titles<-c(features$V2, "Activities", "Subjects");
str(titles)
#chr [1:563] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" "tBodyAcc-std()-Y" "tBodyAcc-std()-Z" "tBodyAcc-mad()-X" "tBodyAcc-mad()-Y" ...

## create column headers for table "merged"
names(merged) <- titles

## order the table first by "Subjects" and then by "Activities"
merged<-merged[order(merged$Subjects, merged$Activities),]

## replace numeric values of "Activities" with corresponding strings from activity_labels.txt
merged$Activities<-factor(merged$Activities, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

## find column indices for columns where column names contain the term "std"
std<-grep("std", names(merged), value=FALSE);
str(std)
#int [1:33] 4 5 6 44 45 46 84 85 86 124 ...

## find column indices for columns where column names contain the term "mean"
mean<-grep("mean", names(merged), value=FALSE);
str(mean)
#int [1:46] 1 2 3 41 42 43 81 82 83 121 ...

## check intersection of mean and std vectors to ensure no overlap
intersect(mean, std)

## create new vector containing column indices where column names contain "mean" and "std"
selected<-c(mean,std)
str(selected)
#int [1:79] 1 2 3 41 42 43 81 82 83 121 ...

## create new table with only selected columns
merged2<-merged[,c(selected,562, 563)]
dim(merged2)
#[1] 10299    81


## melt the table to create ids and variables. Subjects and Activities are ids. Everything else is variables
library("reshape2")
merge2melt<-melt(merged2,id=c("Subjects","Activities"),measure.vars=names(merged2[,1:79]));

# test dimensions and contents of the new table
dim(merge2melt)
#[1] 813621      4
names(merge2melt)
#[1] "Subjects"   "Activities" "variable"   "value" 

## create table showing average of values by Subjects and Activities
ResultData <- dcast(merge2melt, Subjects + Activities ~ variable,mean);
dim(ResultData)
#[1] 180  81

## write table to file
write.table(ResultData, "TidyData.txt", sep="\t", row.names=FALSE)
                          
                       