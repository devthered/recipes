# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Recipe.collection.find.delete_many
User.collection.find.delete_many

puts "creating users..."
devin = User.create(name: "Devin Reed", email: "reed.devin@gmail.com", password: "nevermore", activated: true, admin: true)
kush = User.create(name: "Kush Patel", email: "kp@example.com", password: "nevermore", activated: true, admin: false)
chris = User.create(name: "Chris Reed", email: "cr@example.com", password: "nevermore", activated: true, admin: false)

puts "loading recipes from files..."
JSON.parse(File.read('db/recipes.json')).each do |doc|
  user = devin
  if doc["source"] == "Kush Patel"
    user = kush
  elsif doc["source"] == "Chris Reed"
    user = chris
  end
  Recipe.create(doc.merge(owner: user))
end

puts "done!"