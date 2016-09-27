#Welcome to StreamLine's api
This is a rails api application that is part of the StreamLine to-do list application.  It main functionality is that users can store a list of tasks with time estimates for completing the tasks and with optional deadlines.  The application can schedule those tasks based on what fits into a given block of time.  View it live at [heroku](https://sleepy-mountain-24094.herokuapp.com/)

## The rules the scheduler follows are:
1.Tasks with earlier deadlines are highest priority.
2.Tasks with deadlines are higher priority than those without.
3.Tasks with the same deadline are prioritized by the following:
  1.Fit the most work into a time block possible
  2.Put the biggest tasks first
  3.When tasks are the same estimated duration, pick the oldest ones first

## The api calls are:
POST to https://sleepy-mountain-24094.herokuapp.com/users
to find or create a user with the given name

GET on https://sleepy-mountain-24094.herokuapp.com/tasks
to get all tasks for the given user_id

POST on https://sleepy-mountain-24094.herokuapp.com/tasks
to create a new task for user_id with the given task params
title, description, and estimated_duration are required task params along with a valid user_id

GET on https://sleepy-mountain-24094.herokuapp.com/tasks/scheduled
to get a scheduled list of tasks for the user_id that fits the time_block

PUT on https://sleepy-mountain-24094.herokuapp.com/tasks/:id
to update task with id with the given task params

DELETE on https://sleepy-mountain-24094.herokuapp.com/tasks/:id
to delete task with id
