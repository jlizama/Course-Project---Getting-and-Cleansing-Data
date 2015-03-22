Overall approach was simple and easy to read coding


#0.1 load libraries

#0.2 load files

##make the data more easy to read (this accomplish steps 3 and 4 from excercise)
#1 label activities

#2-3 label subjects

#4-5 add activity names to activity set

#6 Clear labels and y data sets, not needed anymore
rm(act_labels,y_test,y_train)

#7-8 add variable names for "X" data sets

#9 add descriptive variable to training and test data set

##merge data sets (this accomplish step 1 from excersice)
#10-11 bind measurements with their respective activities and subject

#12 make up for rbind to work

#13 bind test and training data

#14 cleans ds not used anymore

## refine data set to accomplish step 2 of the excercise
#15 select only std() and mean() variables from ds
ds_filtered<-select(ds_complete,Subject,Activities,contains("std()"),contains("mean()"))

#16 clean ds not used

##melt, group by and summarize to obtain tidy table as required in step 5 of excercise
#17 reshape to move the variables to rows(a further split could have been done by std or mean)
#transpose a variable/column into row

#18 bit of housekeeping

#19 there is a conflict between dplyr and plyr, can make a big man cry

#20 group by subject, activity and feature

#21 final summarization on table

#22 Write to file