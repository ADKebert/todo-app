# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: "Alan")
User.create(name: "Brett")
Task.create(title: "Front End 1", description: "doing front end magic", deadline: "2016-10-7 14:00:00", estimated_duration: 20, user_id: 2)
Task.create(title: "Back End 1", description: "doing back end magic", deadline: "2016-10-7 14:00:00", estimated_duration: 20, user_id: 1)
Task.create(title: "Back End 2", description: "doing back end magic", deadline: "2016-10-7 14:00:00", estimated_duration: 20, user_id: 1)
Task.create(title: "Front End 2", description: "doing front end magic", deadline: "2016-10-7 14:00:00", estimated_duration: 20, user_id: 2)
