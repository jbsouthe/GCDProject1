#Analysis script to perform the following tasks:
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#test for working data directory:
if( ! file.exists("UCI HAR Dataset") ) {
  if( ! file.exists("UCI HAR Dataset.zip") ) { #if the file isn't there, download it
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI HAR Dataset.zip", method = "curl")
  }
  unzip("UCI HAR Dataset.zip") #unzip the archive
}

#load activity labels for mapping


#load test and train y data
y <- list()
y$Test <- scan("UCI HAR Dataset/test/y_test.txt", what=integer(0))
y$Train <- scan("UCI HAR Dataset/train/y_train.txt", what=integer(0))


#load test and train x measurements
xraw <- list() #init a temp list
x <- list() #init the list to hold all x variables
f <- file("UCI HAR Dataset/test/X_test.txt", "r") #open the X test file
for( i in y$Test ) { #for each y measure...
  xraw <- scan(f, what=complex(0), nlines=1) #read one line of x data
  x$TestMean <- c(x$TestMean,mean(xraw)) #calculate mean
  x$TestStdDev <- c(x$TestStdDev,sd(xraw)) #calculate standard deviation
}
close(f) #close the x file

f <- file("UCI HAR Dataset/train/X_train.txt", "r") #open the X train file
for( i in y$Train ) { #for each y measure...
  xraw <- scan(f, what=complex(0), nlines=1) #read one line of x data
  x$TrainMean <- c(x$TrainMean,mean(xraw)) #calculate mean
  x$TrainStdDev <- c(x$TrainStdDev,sd(xraw)) #calculate standard deviation
}
close(f) #close the x file

#combine data into final list
xyData <- list()
xyData$XMean <- c(x$TestMean,x$TrainMean)
xyData$XStdDev <- c(x$TestStdDev,x$TrainStdDev)
xyData$YActivity <- c(y$Test,y$Train)

#swap numeric with label for activity:
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
xyData$YActivity <- factor(xyData$YActivity, actLabels$V1, labels = actLabels$V2)

str(xyData) #this is the first data set

subjectData <- xyData #copy dataset for second dataset
subjectData$XStdDev <- NULL #remove unneeded stddev column

#read and add subject data to set:
s <- list()
s$Test <- scan("UCI HAR Dataset/test/subject_test.txt", what=integer(0))
s$Train <- scan("UCI HAR Dataset/train/subject_train.txt", what=integer(0))
subjectData$Subject <- c(s$Test, s$Train)

str(subjectData) # this is the second dataset

#clean up some memory
x <- NULL
y <- NULL
s <- NULL

#write data out to file:
write.table(xyData, "firstDataSet.txt")
write.table(subjectData, "secondDataSet.txt")