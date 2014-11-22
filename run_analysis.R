setwd("c:/R") ## Set working directory

## Copy the link 

url<- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip7"


download.file(url, destfile="c:/R/smart.zip")  ## save zip file in the current working directory

unzip("c:/R/smart.zip") ## Unzip the file in the cuurent working directory

setwd("c:/R/UCI HAR Dataset") ## change working directory to new directory

feature<-read.table("features.txt") ## Read feature file which contains the column names of the observation

setwd("c:/R/UCI HAR Dataset/train") ## set wd to Train folder in order to fetch files

x_train<-read.table("X_train.txt") ## Train observation data

y_train<-read.table("y_train.txt") ## Train Activity data performed by subject

subject_train<-read.table("subject_train.txt") ## fetch subject train data

setwd("c:/R/UCI HAR Dataset/test") ## Similary for Test data 

x_test<-read.table("X_test.txt")

y_test<-read.table("y_test.txt")

subject_test<-read.table("subject_test.txt")

## combining Test & Train data

observation1<-rbind(x_train, x_test) 
observation2<-rbind(y_train, y_test)
observation3<-rbind(subject_train, subject_test)

## column name of observation from feature file
colnames(observation1)<- feature$V2

## converting to data frame with "Subject" "Activity" & "Measurement"
smartphones<-cbind(observation3, observation2, observation1)


colnames(smartphones)[1:2]<- c("Subject", "Activity")

## Converting to factors both Activity & Subject

smartphones$Activity<- as.factor(smartphones$Activity)
smartphones$Subject<- as.factor(smartphones$Subject)

## Selecting columns which has mean() and std() & making new data frame with it

column<-which(grepl("mean()", colnames(smartphones)) | grepl("std()", colnames(smartphones)))
smartphones_new<- subset(smartphones, select=c(Subject, Activity, column))

setwd("c:/R/UCI HAR Dataset")

## Converting Activity numbers with Activity labels

activity_lable<-read.table("activity_labels.txt")
smartphones_new$Activity<- factor(smartphones_new$Activity, levels=activity_lable$V1, labels=activity_lable$V2)

## Making meaninglful column names which is easy to read

header<- names(smartphones_new)
replace<-data.frame(name=c("Acc","Body","Gravity","Jerk","Gyro","Mag","t ","f ","  "), Replace=c(" acceleration "," body "," gravity "," jerk ", " gyro ", " magnitude ","time ","fourier "," "))

i<-length(header)
j<-nrow(replace)

for(num in 1:i) {
for(rum in 1:j) {
header[num]<-gsub(replace$name[rum], replace$Replace[rum], header[num])
}
}

colnames(smartphones_new)<-header

## aggregating the data frame with Activity & Subject to get average value 
## median is taken instead of mean so that to take care of skewed values

smartphone_research<-aggregate(x=smartphones_new[3:81], by=list(smartphones_new$Activity, smartphones_new$Subject), FUN="median")
colnames(smartphone_research)[1:2]<-c("Activity", "Subject")

## Creating file for smarphone research

setwd("c:/R")
write.table(smartphone_research, "smartphone.txt", row.names=FALSE)

## Thank you very much 
