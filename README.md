#Welcome to StreamLine's api
This is a rails api application that is part of the StreamLine to-do list application.  Its main functionality is that users can store a list of tasks with time estimates for completing the tasks and with optional deadlines.  The application can schedule those tasks based on what fits into a given block of time.  View it live at [surge](http://streamline.surge.sh/)

## The rules the scheduler follows are:
1. Tasks with earlier deadlines are highest priority.
2. Tasks with deadlines are higher priority than those without.
3. Tasks with the same deadline are prioritized by the following:
  1. Fit the most work into a time block possible
  2. Put the biggest tasks first
  3. When tasks are the same estimated duration, pick the oldest ones first

## The api calls are:
GET to https://sleepy-mountain-24094.herokuapp.com/oauth2authorize
to log in with google

GET on https://sleepy-mountain-24094.herokuapp.com/tasks
to get all tasks for the logged in user

POST on https://sleepy-mountain-24094.herokuapp.com/tasks
to create a new task for the logged in user with the given task params
title, description, and estimated_duration are required task params

GET on https://sleepy-mountain-24094.herokuapp.com/tasks/scheduled
to get a scheduled list of tasks for the logged in user that fits the time_block

PUT on https://sleepy-mountain-24094.herokuapp.com/tasks/:id
to update task with id with the given task params as long as it is owned by the logged in user

DELETE on https://sleepy-mountain-24094.herokuapp.com/tasks/:id
to delete task with id as long as it is owned by the logged in user
