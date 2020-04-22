# Mental Health App
## Project Goals
1. Encourage users to more consciously monitor their mental health and equip them with useful personalized practices/activities to address issues. 
2. Create a user-specific experience in tune to the activities that aid the user's mental health most, the amount of time/resources they have to dedicate to their mental health, and present their progress in a meaningful manner.
3. Document the user's progress in their mental health journey so they can better monitor their mental health state.

## Features
1. A personal account that stores the user's information
2. An initial survey to gather a summary of where the user is beginning at and to be able to immediately provide feedback on their mental health status
3. A daily check-in where a user may quickly select from options their overall mood for the day and input a summary of accomplished activities were done for the user's mental health
4. Daily alerts to remind users to input their information
5. Motivating/humorous quote that changes each day to encourage positive thinking
6. A resource page of professional contacts for emergent situations
7. A calendar view to track their mental health progress for the month
8. Display constraints: iPhone 8 and any form of iPhone 11 on portrait lock orientation

## Overall Architecture
1. Tab View with 5 options: information, journal, home, calendar, & profile
2. Information option will include discussion about more extensive resources
3. Journal will prompt user to enter activities accomplished that day
4. Home option will display daily recommendations and prompt to enter mood
5. Calendar will display month's summary of moods and allow users to get a detail view of any day they tracked
6. Profile page will provide a summary from the initial questionnaire

## Audience
We are hoping to target people who wish to become more in tune with their mental health and track activities that are associated with more positive moods. Additionally, we hope to help people be mindful of their day to day mood and feel empowered to take action to improve it.

## Contributions
1. Zoe Superville: Developed initial wireframe, designed general UI for tab views, improved segues between views, developed daily notification + initial permission prompt for access to notifying users
2. Kassen Qian: Developed initial figma mockups, designed UI themes & initial questionnaire, developed calendar UI, designed and implemented app icon, + tested changed daily mood inputs and connectivity
3. Laura Li: Researched survey questions and activities pertaining to mental health, developed JSON parsing for daily motivational quote, used database to prompt users with a personalized daily activity recommendation, + designed home page
4. Anna Darwish: Developed database integration for user authentication + daily data input + historical/profile information with Firebase, implemented error checking for poor input when creating a new profile, implemented network connectivity alerts, integrated JTAppleCalendar pod into project, designed detail calendar UI view and sigin in/sign up views, + tested connectivity and earlier daily logs of users


