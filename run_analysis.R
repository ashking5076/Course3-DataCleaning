#####Load Library######
library(dplyr)
library(stringr)
library(tidyr)
#####READING DATA######
##Read Activity Labels and Features##
activity_label<-read.table("./Data/activity_labels.txt",col.names = c("act_id","act_name"))
features<-read.table("./Data/features.txt",col.names = c("feature_id","feature_name"))

##Read Training Data##
y_train<-read.table("./Data/train/y_train.txt",col.names = "train_labels")
x_train<-read.table("./Data/train/x_train.txt")
sub_train<-read.table("./Data/train/subject_train.txt")


##Read Testing Data##
y_test<-read.table("./Data/test/y_test.txt",col.names = "test_labels")
x_test<-read.table("./Data/test/x_test.txt")
sub_test<-read.table("./Data/test/subject_test.txt")


##Create Training and Testing Data##
##Add volunteer id as primary key##
untidy_train<-cbind(sub_train,y_train,x_train)
untidy_test<-cbind(sub_test,y_test,x_test)
colnames(untidy_test)<-c("v_id","act_label",unlist(features$feature_name))
colnames(untidy_train)<-c("v_id","act_label",unlist(features$feature_name))
#Add dataset identifier - Testing or training Data#
untidy_test$type="test"
untidy_train$type="train"

#Merge training and testing data set
if(all(colnames(untidy_test)==colnames(untidy_train))) untidy_merged<-rbind(untidy_test,untidy_train) else stop("Column names do not match")

#extract only mean and std data
prefinal_untidy<-untidy_merged[,str_detect(colnames(untidy_merged), "mean\\(|std\\(|v_id|act_label|type")]

#change column names to lower and remove "()" from function name
merged_col<-colnames(prefinal_untidy)
merged_col<-tolower(sub("\\(\\)","",merged_col))
colnames(prefinal_untidy)<-merged_col

##gather data in one column##
f_col<-merged_col[3:(length(merged_col)-1)]                          
f_col<-as.factor(f_col) 
activity<-as.list(activity_label$act_name)
#adding activity name in data set#
prefinal_untidy$activity<-activity[prefinal_untidy$act_label]
prefinal_untidy<-subset(prefinal_untidy,select=-act_label)
prefinal_untidy<-mutate(prefinal_untidy,activity=tolower(activity))
prefinal_untidy<-gather(prefinal_untidy,feature,value,f_col)

#split feature into feature name, function(mean/std) and axial vector
final_tidy_data1<-separate(prefinal_untidy,feature,c("feature_name","function_name","axis"))

#create tidy data set 2 with average of each variable for each activite and subject

final_tidy_data2<-final_tidy_data1%>%
        group_by(v_id,type,activity,feature_name,function_name,axis)%>%
        summarise(mean(value))
colnames(final_tidy_data2)<-c("subject_id","datatype","activity","signal","variable", "direction", "mean")

##remove intermediary datasets##
remove(prefinal_untidy)
remove(untidy_train)
remove(untidy_test)
remove(untidy_merged)