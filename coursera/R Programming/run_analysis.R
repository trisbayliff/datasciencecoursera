# R program to fulfill Getting and Cleaning Data course project

#####################################################################
# load files
#####################################################################
# load the features file
features.load <- read.table("UCI HAR Dataset/features.txt")

# load the training data set
traindata.load <- read.table("UCI HAR Dataset/train/X_train.txt")

# load the testing data set
testdata.load <- read.table("UCI HAR Dataset/test/X_test.txt")

# load the training subjects data set
trainsubj.load <- read.table("UCI HAR Dataset/train/subject_train.txt")

# load the testing subjects data set
testsubj.load <- read.table("UCI HAR Dataset/test/subject_test.txt")

# load the training data set
trainact.load <- read.table("UCI HAR Dataset/train/Y_train.txt")

# load the testing data set
testact.load <- read.table("UCI HAR Dataset/test/Y_test.txt")

# load activity labels
activities.load <- read.table("UCI HAR Dataset/activity_labels.txt")

#####################################################################
# format and clean data
#####################################################################

# get the column numbers that contain std or mean assuming these are the
# values required
features.selected <- grep("std|mean",features.load$V2)

# get the columns we want out of the loaded train & test data
# using the column numbers identfied previously
testdata.selected <- testdata.load[,features.selected]
traindata.selected <- traindata.load[,features.selected]

# concatenate train and test datasets into one
testtrain.combined <- rbind(testdata.selected,traindata.selected)

# concatenate activity datasets into one
act.combined <- rbind(testact.load,trainact.load)

# concatenate subject datasets into one
subj.combined <- rbind(testsubj.load,trainsubj.load)

# rename columns on main data sets
colnames(testtrain.combined) <- features.load[features.selected, 2]

# link activity description
act.combined$activity <- factor(act.combined$V1, levels = activities.load$V1
                               ,labels = activities.load$V2
                               )

# combine subjects and activities. 
subj.act.combined <- cbind (subj.combined,act.combined$activity)

# name columns correctly
colnames(subj.act.combined) <- c("SubjectID","ActivityText")

# combine everything
everything.combined <-cbind(subj.act.combined,testtrain.combined)

# build data to output
output.data <- aggregate(everything.combined[,3:81]
                        ,by = list(everything.combined$SubjectID
                        ,everything.combined$ActivityText)
                        ,FUN = mean
                        )

# Name header columns
colnames(output.data)[1:2] <- c("SubjectID","ActivityText")

# dleete file if already existing
filename <- "outputfile.txt"
if (file.exists(filename)) file.remove(filename)

# Output to file
write.table(output.data, file=filename, row.names = FALSE)

