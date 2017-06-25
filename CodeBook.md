Code Book
=========

The dataset produced from running run_analysis.R, contains the mean of each variable for each activity and each subject.

* subject - the subject id
* activity - the activity represented by the variables and is one of: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

From the features_info.txt, any variables with mean() in the name are considered to represent a mean value and similarly, anything containing std() are considered to represent a standard deviation. Any other features were ignored in producing this dataset.

Some corrections were made to the feature names...

* Anything starting with "t" was replaced by "time"
* Anything starting with "f" was replaced by "frequency"
* "Acc" was replaced by "Accelerometer"
* "Gyro" was replaced by "Gyroscope"
* "Mag" was replaced by "Magnitude"
* "BodyBody" was replaced by "Body"

The full list of features and their meanings can be found in the features_info.txt file contained with the original data.
