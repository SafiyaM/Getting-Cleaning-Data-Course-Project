#Getting and Cleaning Data Coursera 
#Class Project

library(dplyr)
setwd("C://Users/Safiya/Desktop/Coursera Data Science/cleaningData/courseprojectdata")

#Import Test Data
test <- read.table("./UCI HAR Dataset/test/X_test.txt") #results, column names will be assigned later
test_act <- read.table("./UCI HAR Dataset/test/y_test.txt") #activities
colnames(test_act) <- c("activity")
test_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt") #subjects
colnames(test_sub) <- c("subject")


#Import Training Data
train <- read.table("./UCI HAR Dataset/train/X_train.txt") #results
train_act <- read.table("./UCI HAR Dataset/train/y_train.txt") #activities
colnames(train_act) <- c("activity")
train_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt") #subjects
colnames(train_sub) <- c("subject")

#Import Text file with Column Names
labels <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

#Create Vector of Column Names
label_names <- labels$V2

#Change column names to all lowercase
label_names <- tolower(label_names)


#remove special characters from column names
label_names <- gsub("-","",label_names)
label_names <- gsub("\\(","",label_names)
label_names <- gsub(")","",label_names)
label_names <- gsub(",","",label_names)

#assign column names to test and train data frame
names(test) <- label_names
names(train) <- label_names

#add activity column
test <- cbind(test_sub, test_act, test)
train <- cbind(train_sub, train_act, train)

#merge the test and training data
test_train <- rbind(test, train)

#extract only the columns for mean and stddev
test_train2 <- test_train[,grep("mean|std|activity|subject", label_names)]


#Import Text file with Activity Labels
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
colnames(act_labels) <- c("activity", "activitylabel")

#Merge Activity Labels with the Data Set
test_train3 <- merge(act_labels, test_train2, by="activity")
test_train4 <- select(test_train3, -activity)

#creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.
summary <- test_train4 %>% 
           group_by(activitylabel, subject) %>%
           summarise_each(funs(mean))

write.table(summary, row.names = FALSE, file="activitySub_Summary.txt")
