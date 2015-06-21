#You should create one R script called run_analysis.R that does the following. 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#1. Merges the training and the test sets to create one data set.
# read activities
Y_Activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt",header = FALSE)
Y_Activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt",header = FALSE)

#read subjects
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",header = FALSE)

#read features
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt",header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt",header = FALSE)

#combine data
data_subject <- rbind(subject_train, subject_test)
data_activity<- rbind(Y_Activity_train, Y_Activity_test)
data_features<- rbind(X_train, X_test)

#set headers
names(data_subject) <- c("Subject")
names(data_activity) <- c("Activity")
features <- read.table("./UCI HAR Dataset/features.txt",header = FALSE)
names(data_features) <- features$V2

full_data <-cbind(data_features,cbind(data_subject,data_activity))

#3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",header = FALSE)
full_data[, 563] = activity_labels[full_data[, 563], 2]

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
column_names_with_MEAN_STD <- grep(".*Mean.*|.*Std.*", names(full_data), ignore.case=TRUE)
dim(full_data)
selected_columns <- c(column_names_with_MEAN_STD,562,563)
selected_data <- full_data[,selected_columns]
dim(selected_data)

#4. Appropriately labels the data set with descriptive variable names. 
names(selected_data)
names(selected_data)<-gsub("^t", "time", names(selected_data))
names(selected_data)<-gsub("^f", "frequency", names(selected_data))
names(selected_data)<-gsub("Acc", "Accelerometer", names(selected_data))
names(selected_data)<-gsub("Gyro", "Gyroscope", names(selected_data))
names(selected_data)<-gsub("Mag", "Magnitude", names(selected_data))
names(selected_data)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr);
tidy_data<-aggregate(. ~Subject + Activity, selected_data, mean)
tidy_data<-tidy_data[order(selected_data$Subject,selected_data$Activity),]
write.table(tidy_data, file = "tidydata.txt",row.name=FALSE)
