library(dplyr)

outputdir  <- "data"
orgdataset <- "dataset.zip"
temp       <- file.path(outputdir, "original")
testfiles  <- file.path(temp, 'UCI HAR Dataset', 'test')
trainfiles <- file.path(temp, 'UCI HAR Dataset', 'train')

# Download and extract the dataset
if (!dir.exists(outputdir)) {
  dir.create(outputdir)
}
if (!file.exists(file.path(outputdir, orgdataset))) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", file.path(outputdir, orgdataset))
}

unzip(file.path(outputdir, orgdataset), exdir = temp)


# Read in the train and test datasets

# Read the Subjects
subjectTest  <- read.table(file.path(testfiles, "subject_test.txt"), header = F)
subjectTrain <- read.table(file.path(trainfiles, "subject_train.txt"), header = F)

# Read the Activities
activityTest  <- read.table(file.path(testfiles , "y_test.txt" ), header = F)
activityTrain <- read.table(file.path(trainfiles, "y_train.txt"), header = F)

# Read the Features
featuresTest  <- read.table(file.path(testfiles, "X_test.txt" ), header = F)
featuresTrain <- read.table(file.path(trainfiles, "X_train.txt"), header = F)


#1. Merges the training and the test sets to create one data set.

subject  <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

# Appropriately name the columns
names(subject)  <- c("subject")
names(activity) <- c("activity")
featuresNames   <- read.table(file.path(file.path(temp, 'UCI HAR Dataset'), "features.txt"), header = F)
names(features) <- featuresNames$V2

combinedData <- cbind(features, cbind(subject, activity))


#2. Extracts only the measurements on the mean and standard deviation for each measurement.

# Take the features with mean() or std() in their name, as well as subject or activity
combinedData <- combinedData[,grep("((mean|std)\\(\\))|(^subject$)|(^activity$)", ignore.case = T, names(combinedData))]


#3. Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table(file.path(file.path(temp, 'UCI HAR Dataset'), "activity_labels.txt"), header = F)

# Give activities appropriate names and convert to a factor
combinedData[,"activity"] <- factor(combinedData[,"activity"], levels = activityLabels$V1, labels = activityLabels$V2)

#4. Appropriately labels the data set with descriptive variable names.

names(combinedData)<-gsub("^t",       "time",          names(combinedData))
names(combinedData)<-gsub("Acc",      "Accelerometer", names(combinedData))
names(combinedData)<-gsub("Gyro",     "Gyroscope",     names(combinedData))
names(combinedData)<-gsub("^f",       "frequency",     names(combinedData))
names(combinedData)<-gsub("Mag",      "Magnitude",     names(combinedData))
names(combinedData)<-gsub("BodyBody", "Body",          names(combinedData))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyData <- combinedData %>% group_by(activity, subject) %>% summarise_all(mean, na.rm = T)

# Write out the results into the data directory
write.table(tidyData, file = file.path(outputdir, "tidydata.txt"), row.name=FALSE)

# Tidy Up by deleting the extracted data
unlink(temp)