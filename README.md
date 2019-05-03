# EECS 392 - Final Project
# Ellis Saupe, Jackson Nelson-Gal
## Localized Classroom Messaging

### Notes:
There are a bunch of ICE connection errors in the debugger at the beginning of any connection.  Those have no effect on performance.
There are occasional random disconnects.  Reconnection should work cleanly from inside the app, but closing and reopening the app might help.
Immediately after our presentation, XCode / IOS simulator failed to join any services (student app can't connect, teacher app runs fine).  We cannot identify the cause of this or find a solution.  We have not tried a full reboot yet because we have enough phone's to test with.

### Frameworks/Structures Used
1. Multipeer connectivity


### Features

## Student App (Client app)
This application is for students. They can connect to a teacher's host and take part in a multitude of interactions with the classroom.
1. Session selection: A table of available classrooms is displayed for the student to choose from.  On exiting the app or if the teacher disconnects, the student will be returned to this room.
2. Discussion Board: Group chat for all students and the professor.  The professor's messages will appear in yellow.  On connecting to the teacher, all message that the teacher has received will be forwared to the student.
3. Directed Questions: Ask a question directly to the professor (no students see). Questions are anonymous.
4. In-Class Quizzes: When a teacher submits a quiz. All students will get a popup for the quiz questions. Once all students submit their response (or the teacher completes the quiz), the teacher can see the results of the quiz.  If a student is not connected when the quiz is posted, they will receive the quiz when they do connect as long as the quiz is still active.
5. Settings field for the student's display name.  This name will be used in discussion posts and on quiz submissions.

## Teacher App (Host app)
This application is for the teachers who want to host this environment in their classrooms. They can setup a classroom (set of sessions), display and run through slides/other visuals, view student questions, and create quizzes and see the results
1. Discussion Board: Identical functionality to student side.
2. Directed questions: Student questions are received in a sort of inbox page. The teacher can expand these questions for more details.  In the new view, teachers can delete/resolve the questions.  The intention is that the teacher answers these questions to the class.  Anonymous questions like this are very useful in settings such as a high school health class. 
3. Quizzes: Teachers can create a quiz with any number of questions. Each question must be multiple choice with 4 or less answers.  Teachers can post this quiz, and all connected students will be notified.  The teacher can view an approximation of the total number of students that have been sent the quiz, and the number of answers received.  Selecting a question will show the list of students that selected each answer.  Students that answered incorrectly will appear in red.
4. The teacher may set their display name for the discussion board.  Settings also displays the current number of connected students.
