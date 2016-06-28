## You should create one R script called run_analysis.R that does the following.

##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement.
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names.
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


##load required packages

packages <- c("data.table", "dplyr", "reshape2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)
# data.table      dplyr   reshape2 
#       TRUE       TRUE       TRUE

##set path
path <- getwd()
path

##[1] /Users/AngeloCondulle/Desktop/Coursera files"

##download file from URL
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./Dataset.zip" , method = "curl")

##unzip dataset.zip file
unzip("./Dataset.zip", exdir = ".", unzip = "internal")

##List files
path_list <- file.path(".", "UCI HAR Dataset")
files <- list.files(path_list, recursive=TRUE)

##print 
files

## Read the files into R
##train data:

subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")

##test data:
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")

##features and activity
features <- read.table("./UCI HAR Dataset/features.txt")
activies <- read.table("./UCI HAR Dataset/activity_labels.txt")

##Question 1: Merges the training and the test sets to create one data set.
subdata <- rbind(subtrain, subtest)
Y <- rbind(ytrain, ytest)
X <- rbind(xtrain, xtest)

## Set names to variables

names(subdata) <- c("subject")
names(Y) <- c("activity")
Xnames <- read.table(file.path(path_list, "features.txt"),head=FALSE)
names(X) <- Xnames$V2

##Merge columns
datacombine <-cbind(subdata,Y)
Data <- cbind(X, datacombine)

##2. Extracts only the measurements on the mean and standard deviation for each measurement.

subXnames <- Xnames$V2[grep("mean\\(\\)|std\\(\\)", Xnames$V2)]

selectedNames<-c(as.character(subXnames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

##check structures
str(Data)

##3.Uses descriptive activity names to name the activities in the data set

activitiesFile <- read.table(file.path(path_list, "activity_labels.txt"),header = FALSE)
activitiesFile

##add activity column

activityfactor <- factor(Data$activity, levels=activitiesFile$V1, labels=activitiesFile$V2)
#add column to data set
str(activityfactor)
summary(activityfactor)


#add activity column to data
Data2 <- mutate(Data, activity = activityfactor)
summary(Data2)



##4. Appropriately labels the data set with descriptive variable names.

names(Data)<-gsub("t", "Time", names(Data))
names(Data)<-gsub("Body", "Botton", names(Data))
names(Data)<-gsub("f", "Frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerate", names(Data))
names(Data)<-gsub("Mag", "Magazine", names(Data))
names(Data)<-gsub("Gyro", "Gyrospbere", names(Data))

##check to see if name change

names(Data)


##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Data.tidy <- Data %>% group_by(subjecTime, acTimeiviTimey) %>% summarise_each(funs(mean))
write.table(Data.tidy, file = "./data.tidy.txt", row.names = FALSE)


