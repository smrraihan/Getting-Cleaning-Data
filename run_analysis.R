#setting library and working directory - [after you download and extract the zip file in your working directory]

library(dplyr)
old_directory <- getwd() #to save the current working directory for later change back to the directory

setwd("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset") #assuming you had unzipped the file on your working folder

#getting prepare: reading all data

features        <- read.table("./features.txt",  col.names = c("sl","functions")) 
activity_labels <- read.table("./activity_labels.txt", col.names = c("code", "activity")) 

x_train     <- read.table("./train/X_train.txt", col.names = features$functions)
y_train     <- read.table("./train/Y_train.txt", col.names = "code") 
sub_train   <- read.table("./train/subject_train.txt", col.names = "subject")

#test data reading

x_test     <- read.table("./test/X_test.txt", col.names = features$functions)
y_test     <- read.table("./test/Y_test.txt", col.names = "code") 
sub_test   <- read.table("./test/subject_test.txt", col.names = "subject")


### Q1. Merges the training and the test sets to create one data set.

#merge data sets

x_merge         <- rbind(x_train, x_test)
y_merge         <- rbind(y_train, y_test) 
sub_merge       <- rbind(sub_train, sub_test)
xysub_merge     <- cbind(sub_merge,y_merge,x_merge)
    
### Q2. Extracts only the measurements on the mean and standard deviation for each measurement. 

Final_data <- xysub_merge %>% select(subject, code, contains("mean"), contains("std"))

### Q3. Uses descriptive activity names to name the activities in the data set

Final_data$code <- activity_labels[Final_data$code, 2]

### Q4. Appropriately labels the data set with descriptive variable names. 
names(Final_data)<-gsub("Acc", "Accelerometer", names(Final_data))
names(Final_data)<-gsub("Gyro", "Gyroscope", names(Final_data))
names(Final_data)<-gsub("Mag", "Magnitude", names(Final_data))
names(Final_data)<-gsub("^t", "Time", names(Final_data))
names(Final_data)<-gsub("^f", "Frequency", names(Final_data))

###Q5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Final_Data2 <- Final_data %>% group_by(subject, code) %>% summarise_all(funs(mean))
write.table(Final_Data2, "Raihan_Final.txt", row.name=FALSE)

setwd(old_directory)