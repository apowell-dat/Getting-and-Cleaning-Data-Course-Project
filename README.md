# Getting-and-Cleaning-Data-Course-Project
Final Project for Coursera course: Getting and Cleaning Data

#Explanation of R script (run_analysis.R) used to clean data

The script in the analysis file was designed to accomplish the following tasks:

- Merge the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement.
- Use descriptive activity names to name the activities in the data set.
- Appropriately label the data set with descriptive variable names.
- From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

First, the script loads necessary packages, establishes the working directory, and downloads/unzips the raw data files.

Second, the script loads activity labels and features. It then subsets the raw feature list according to only our variables of interest (i.e., those indicating either mean or standard deviation). *gsub* is used to replace characters that make variable names difficult for human readability (i.e., ()) with empty spaces ("").

Third, the separately loads the train and test datasets and merges respective measurement variables, activity labels, and subject numbers for each of the two raw datasets.

Fourth, the script merges the test and train datasets and reorders rows according to subject number (SubjectNum).

Finally, the script converts class labels (activities numbered 1-6) to actual activity names (walking, walking up, walking down, sitting, standing, laying) and then melts and recasts the data before exporting the tidy data in .csv format.