
# unzip file
unzip("getdata-projectfiles-UCI HAR Dataset.zip")



# 1. Merges the training and the test sets to create one data set.

# read in data
traindata <- read.csv(file="UCI HAR Dataset/train/X_train.txt",sep="",header=FALSE)
testdata <- read.csv(file="UCI HAR Dataset/test/X_test.txt",sep="",header=FALSE)

# combine the Datasets
combined <- rbind(traindata,testdata)

# clear unused data
rm(traindata,testdata)


# the Column Names
colnames <- read.csv(file="UCI HAR Dataset/features.txt",sep="",header=FALSE)

# sanitizy column names, remove "(" ")",   replace "-" with "."
colnames[,2] <- sapply(colnames[,2], function(x) {gsub("-",".",x) }  )
colnames[,2] <- sapply(colnames[,2], function(x) {gsub("[()]","",x) }  )
# set Column names
names(combined) <- colnames[,2]


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#
# extract only columns for mean and standard deviation for each measurement
columns <- c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,
             161,162,163,164,165,166, 201,202, 214,215, 227,228, 240,241, 253,254,
             266,267,268,269,270,271, 345,346,347,348,349,350, 424,425,426,427,428,429,
             503,504, 516,517,529,530, 542,543)

extracted <- combined[,columns]
rm(combined)



# 3. Uses descriptive activity names to name the activities in the data set

# read in activity labels
activitylabels <- read.csv("UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)

# read in activities
trainactivity <- read.csv("UCI HAR Dataset/train/y_train.txt",header=FALSE,sep="")
testactivity <- read.csv("UCI HAR Dataset/test/y_test.txt",header=FALSE,sep="")

activity <- rbind(trainactivity,testactivity)
rm(trainactivity,testactivity)

# convert activity Numbers into Factor using the dscriptive activity names
activity <- factor(activity[,1],levels=activitylabels[,1], labels=activitylabels[,2] )

# add  activity Column
extracted <- cbind(extracted,activity)


# read in the subjects ids
subjecttrain <- read.csv("UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep="")
subjecttest <- read.csv("UCI HAR Dataset/test/subject_test.txt",header=FALSE,sep="")
subject <- rbind(subjecttrain,subjecttest)
rm(subjecttrain,subjecttest)
names(subject) <- "subject"
# add subject column to extracted result
extracted <- cbind(extracted,subject=subject)




#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# aggregate data for subject + activity
tidy <- aggregate( . ~ subject + activity, data=extracted, FUN=mean)

#write data
write.table(tidy,"tidydata.csv", col.names=TRUE,row.names=FALSE, sep=";")

