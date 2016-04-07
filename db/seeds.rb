# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: "Manuel Eberhardinger", email: "manuel@rocketshp.com", password: "password", password_confirmation: "password", admin: true)
User.create(name: "Mark Hayes", email: "mark@rocketshp.com", password: "password", password_confirmation: "password", admin: true)
