# %>% comes from magrittr 

# Importing the file

#importing the files for labels if needed

features <- read.table('features.txt',col.names = c("n","function"))
activity_labels <- read.table('activity_labels.txt',col.names = c("n","activity"))


# importing the test files 

x_test <- read.table('test/x_test.txt',col.names = features$function.)
y_test <- read.table('test/y_test.txt',col.names = "n")
subject_test <- read.table('test/subject_test.txt',col.names = "subject")



# importing the train files
x_train <- read.table('train/x_train.txt',col.names = features$function.)
y_train <- read.table('train/y_train.txt',col.names = "n")
subject_train <- read.table('train/subject_train.txt',col.names = "subject")


# Merging the training and testing dataset

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)


# get measurements on the mean and standard deviation for each measurement.

Data <- Merged_Data %>% select(subject, n, contains("mean"), contains("std"))

# Uses descriptive activity names to name the activities in the data set

Data$n <- activity_labels[Data$n, 2]

# Appropriately labels the data set with descriptive variable names.

# WILL GET the names of the columns in an array
name.new <- names(Data)
# replace the foolowing symbol with ""
name.new <- gsub("[(][)]", "", name.new)
# replace start with t with TimeDomain
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(Data) <- name.new



#getting the data 

FinalData <- Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Data, "FinalData.txt", row.name=FALSE)
