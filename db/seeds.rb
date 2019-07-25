# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "json"
require "rest-client"

response = RestClient.get 'https://hacker-news.firebaseio.com/v0/topstories.json'
top_ten = JSON.parse(response.body).take(10)

puts top_ten
