setwd("C:/FUCI HAR Dataset/UCI HAR Dataset")
#Loadthe data into csv
features_train = read.csv("train/X_train.txt", sep="", header=FALSE)
activity_train = read.csv("train/Y_train.txt", sep="", header=FALSE)
subject_train = read.csv("train/subject_train.txt", sep="", header=FALSE)

features_test = read.csv("test/X_test.txt", sep="", header=FALSE)
activity_test = read.csv("test/Y_test.txt", sep="", header=FALSE)
subject_test = read.csv("test/subject_test.txt", sep="", header=FALSE)

activity_labels = read.csv("activity_labels.txt", sep="", header=FALSE)

#bind all the data together
dataSubject <- rbind(subject_train, subject_test)
dataActivity<- rbind(activity_train, activity_test)
dataFeatures<- rbind(features_train, features_test)

#change the column names 
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
features = read.csv("features.txt", sep="", header=FALSE)
names(dataFeatures) <- features[,2]

#combine all to get full data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Step 1 complete to get combined data

#Extract only the measurements on the mean and standard deviation for each measurement
mean_std_name<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
selectedNames<-c(as.character(mean_std_name), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#Uses descriptive activity names to name the activities in the data set

Data$activity <- as.character(Data$activity)
for (i in 1:6){
  Data$activity[Data$activity == i] <- as.character(activity_labels[i,2])
}

#Appropriately labels the data set with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("tBody", "TimeBody", names(Data))
names(Data)<-gsub("-mean()", "Mean", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-std()", "STD", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-freq()", "Frequency", names(Data), ignore.case = TRUE)


#From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject.