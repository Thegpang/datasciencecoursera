# run_analysis.R Script

# Load necessary libraries
library(data.table)

# Unzip the dataset
unzip("UCI HAR Dataset.zip", exdir = "UCI HAR Dataset")

# Load both training and test sets
train_set <- fread("./UCI HAR Dataset/train/X_train.txt")
test_set <- fread("./UCI HAR Dataset/test/X_test.txt")

# Load the features and activity labels
features <- fread("./UCI HAR Dataset/features.txt")
activities <- fread("./UCI HAR Dataset/activity_labels.txt")

# Merge the training and test sets
all_data <- rbind(train_set, test_set)

# Extract only the measurements on the mean and standard deviation
mean_std_features <- grep("-(mean|std)\\(\\)", features$V2)
tidy_data <- all_data[, ..mean_std_features]

# Appropriately labels the data set with descriptive variable names
setnames(tidy_data, names(tidy_data), features$V2[mean_std_features])

# Use descriptive activity names to name the activities in the data set
activity_data <- fread("./UCI HAR Dataset/train/y_train.txt")
activity_data <- rbind(activity_data, fread("./UCI HAR Dataset/test/y_test.txt"))
tidy_data$activity <- activities$V2[activity_data$V1]

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
subject_train <- fread("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- fread("./UCI HAR Dataset/test/subject_test.txt")
subjects <- rbind(subject_train, subject_test)
tidy_data$subject <- subjects$V1

tidy_data <- tidy_data[, lapply(.SD, mean), by = .(subject, activity)]

# Write the tidy data set to a file
fwrite(tidy_data, "tidy_data_set.txt")
