MVVM
Local JSON Fetch
Codable/Decodable

**Background**
Our therapist community manager would like an app that is able to display each of the following lists of information:



1. A list all therapists that are currently on duty.
Sort the list by the time remaining until the end of the therapist’s shift, shortest to longest. For instance if therapist Freud is on duty between 9:00AM and 11:00AM, and the current device time is 10:59AM, this therapist should appear towards the top of the list.

2. A List of of all therapists that are scheduled to start working later in the day.
Sort the list by the time remaining until the start of the therapist’s shift, shortest to longest. For instance if therapist Freud is on duty between 9:00AM and 11:00AM, and the current device time is 8:59AM, this therapist should appear towards the top of the list.
Do not include therapists that have completed their shift.

3. A list of gaps during the day when there are no therapists on duty


