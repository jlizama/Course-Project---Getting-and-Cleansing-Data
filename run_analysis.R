#0.1 load libraries
library(dplyr)
library(plyr)
library(reshape2)

#0.2 load files
act_labels = read.table("~/R/data/UCI_Dataset/activity_labels.txt")
features = read.table("~/R/data/UCI_Dataset/features.txt")
subject_test<-read.table("~/R/data/UCI_Dataset/test/subject_test.txt")
subject_train<-read.table("~/R/data/UCI_Dataset/train/subject_train.txt")
x_test<-read.table("~/R/data/UCI_Dataset/test/X_test.txt")
y_test<-read.table("~/R/data/UCI_Dataset/test/Y_test.txt")
x_train<-read.table("~/R/data/UCI_Dataset/train/X_train.txt")
y_train<-read.table("~/R/data/UCI_Dataset/train/Y_train.txt")

##make the data more easy to read (this accomplish steps 3 and 4 from excercise)
#1 label activities
names(act_labels)[2]<-"Activities"

#2-3 label subjects
names(subject_test)[1]<-"Subject"
names(subject_train)[1]<-"Subject"

#4-5 add activity names to activity set
act_test<-join(y_test,act_labels)
act_train<-join(y_train,act_labels)

#6 Clear labels and y data sets, not needed anymore
rm(act_labels,y_test,y_train)

#7-8 add variable names for "X" data sets
names(x_test)<-features$V2
names(x_train)<-features$V2


#9-10 add descriptive variable to training and test data set
x_test<-mutate(x_test,Set_Type="Test")
x_train<-mutate(x_train,Set_Type="Training")

#9 remove features, not needed anymore
rm(features)

##merge data sets (this accompleish step 1 from excersice)
#10-11 bind measurements with their respective activities and subject
ds_test<-cbind(act_test$Activities,subject_test$Subject,x_test)
ds_train<-cbind(act_train$Activities,subject_train$Subject,x_train)

#12 make up for rbinf to work
names(ds_test)[1:2]<-c("Activities","Subject")
names(ds_train)[1:2]<-c("Activities","Subject")

#12 bind test and training data
ds_complete<-rbind(ds_test,ds_train)

#13 cleans ds not used anymore
rm(act_test,act_train,subject_test,subject_train,x_test,x_train,ds_test,ds_train)

## refine data set to accomplish step 2 of the excercise
#14 select only std() and mean() variables from ds
ds_filtered<-select(ds_complete,Subject,Activities,contains("std()"),contains("mean()"))

#15 clean ds not used
rm(ds_complete)

##melt, group by and summarize to obtain tidy table as required in step 5 of excercise
#16 reshape to move the variables to rows(a further split could have been done by std or mean)
#transpose a variable/column into row
ds_reshape <- melt(ds_filtered,id=1:2,measure.vars=3:68)

#17 bit of housekeeping
names(ds_reshape)[3]<-"Feature"

#18 there is a conflict between dplyr and plyr, can make a big man cry
detach("package:plyr", unload=TRUE)
detach("package:dplyr", unload=TRUE)
library(dplyr)

#19 group by subject, activity and feature
ds_grouped<-group_by(ds_reshape,Subject,Activities,Feature)

#20 final summarization on table
ds_summarized<-summarize(ds_grouped,Value=mean(value))

#21 Write to file
write.table(ds_summarized, "data.txt", row.names=FALSE)