##You should create one R script called run_analysis.R that does the following.

##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement.
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names.
##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)
 filename <- "getdata_dataset.zip"
 
 ##Download and unzip the dataset
if(!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method = "curl")
                 }


 if(!file.exists("UCI HAR Dataset")){
                 unzip(filename)
         }
##read training data 
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "")
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train_activities <- read.table("./UCI HAR Dataset/train/y_train.txt")
##read text data
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_activities <- read.table("./UCI HAR Dataset/test/y_test.txt")
##read features
activityFeatures <- read.table("./UCI HAR Dataset/features.txt")
##Merges the training and the test sets to create one data set
         
###Concatenate the data by rows
dataset <- rbind(train_data, test_data)
datasubjects <- rbind(train_subjects, test_subjects)
dataactivities <- rbind(train_activities, test_activities)
 
###Merge features and data to get the dataframe
a <- cbind(datasubjects, dataactivities)
names(dataset) <- activityFeatures$V2
colnames(a) <- c("Subjects", "Activity")
dataAll <- cbind(a, dataset)
##Extracts only the measurements on the mean and standard deviation for each measurement
selectedcols <- grep("Subjects|Activity|mean|std", colnames(dataAll))
selecteddata <- dataAll[ , selectedcols]


##Uses descriptive activity names to name the activities in the data set

#read labels
datalabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
dataAll$Activity <- factor(dataAll$Activity, levels = datalabels$V1, labels = datalabels$V2)

##Appropriately labels the data set with descriptive variable names.
datacols <- colnames(dataAll)
datacols <- gsub("^f", "frequencyDomain", datacols)
datacols <- gsub("^t", "timeDomain", datacols)
datacols <- gsub("Acc", "Accelerometer", datacols)
datacols <- gsub("Gyro", "Gyroscope", datacols)
datacols <- gsub("Magn", "Magnititude", datacols)
datacols <- gsub("Freq", "Frequency", datacols)
datacols <- gsub("mean", "Mean", datacols)
datacols <- gsub("std", "StandardDeviation", datacols)
datacols <- gsub("BodyBody", "Body", datacols)
colnames(dataAll) <- datacols

##creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(plyr);
Data2<-aggregate(. ~Subjects + Activity, dataAll, mean)
Data2<-Data2[order(Data2$Subjects,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)




