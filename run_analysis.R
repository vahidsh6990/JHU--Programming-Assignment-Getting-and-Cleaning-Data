if(!file.exists("./data")){dir.create("./data")}
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = "./data/Dataset.zip", method = "curl")
if(!file.exists("UCI HAR Dataset")) {unzip(zipfile="./data/Dataset.zip", exdir ="./data")}
library(dplyr)

features <- read.table("./Data/UCI HAR Dataset/features.txt", col.names = c("n","functions"))

activities <- read.table("./Data/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

subject_test <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

x_test <- read.table("./Data/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)

y_test <- read.table("./Data/UCI HAR Dataset/test/y_test.txt", col.names = "code")

subject_train <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

x_train <- read.table("./Data/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)

y_train <- read.table("./Data/UCI HAR Dataset/train/y_train.txt", col.names = "code")


#This is the first step of the project. Here I merge the training and test sets to create only one dataset.
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
FinalData <- cbind(subject, y, x)


#In the second step, I extract the measurements on the mean and SD for each measurement.
Madetidy <- FinalData %>% select(subject, code, contains("mean"), contains("std"))


#Now I label teh data set with descriptive variable names:
names(Madetidy)<-gsub("gravity", "Gravity", names(Madetidy))
names(Madetidy)<-gsub("BodyBody", "Body", names(Madetidy))
names(Madetidy)<-gsub("^f", "Frequency", names(Madetidy))
names(Madetidy)<-gsub("-mean()", "Mean", names(Madetidy))
names(Madetidy)<-gsub("-std()", "Standard Deviation", names(Madetidy))
names(Madetidy)<-gsub("Gyro", "Gyroscope", names(Madetidy))
names(Madetidy)<-gsub("^t", "Time", names(Madetidy))
names(Madetidy)<-gsub("Mag", "Magnitude", names(Madetidy))
names(Madetidy)<-gsub("Acc", "Accelerometer", names(Madetidy))


#New data from the previous step:
Newdata <- Madetidy %>% 
    group_by(subject, Madetidy$code) %>% 
    summarize_all(funs(mean))
write.table(Newdata, "Newdata.txt", row.name=FALSE)