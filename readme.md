
# Cleaning and Processing the UCI HAR Data Set
This readme file covers the requirements and describes the processing performed by the run_analysis.R script file on the UCI HAR data set.

The data can be obtained from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The script has been tested in R version 3.2.0 using RStudio version 0.98.1103.

## Data files
Data files should be placed in the current working directory where the run_analysis.R file resides. Required data files are as follows:
* activity_labels.txt
* features.txt
* test/subject_test.txt
* test/X_test.txt
* test/y_test.txt
* train/subject_train.txt
* train/X_train.txt
* train/y_train.txt

Files that are missing will be detected in the script and the files must be placed in the appropriate location before continuing.

## Required Packages
In order to run this script, the following packages need to be installed:
* dplyr

## Processing
Processing the data involves a number of steps:

1. The eight data files are loaded from the file system and stored as separate data frames.
2. The "test" and the "train" data are then combined to form one larger data frame. At this stage, there are no identifiers indicating which data set a record came from. Column names are obtained and applied from the Features data (features.txt).
3. Columns that do not contain either "mean()" or "std()" in the name are excluded from additional processing. The column numbers with "mean()" or "std()" are then collected and sorted before the dataset is subsetted to keep columns in similar order.
4. Activity identifiers are then matched to the appropriate descriptions by using the inner_join function (part of the dplyr package). This dataset is stored with the variable name "data3".
5. Variable names are also cleaned up, with dashes "-" and "()-" replaced by underscores and "()" removed. This assists with readability of the variable names while keeping the column names meaningful.
6. A grouping is then applied, by Subject and Activity. The mean is calculated for all of the remaining columns.
7. Results from the summarisation is saved to disk in the working directory, as "results.txt". Column names are omitted from the text file output.
8. Variables used in data processing are cleaned up after exporting the final results file, except the final "dataTidy" variable. This section can be commented out if additional transformation or analysis of the data/intermediate steps is required.


## Reading the Results
The results can be read using the read.table function, for example:
data <- read.table("results.txt", header = TRUE)