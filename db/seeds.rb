# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Recipe.collection.find.delete_many

#puts "adding recipes"
#JSON.parse(File.read('db/recipes.json')).each do |doc|
#  Recipe.collection.insert_one(doc)
#end