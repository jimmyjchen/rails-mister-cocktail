Ingredient.delete_all if Rails.env.development?

require "json"
require "rest-client"


response = RestClient.get "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
result = JSON.parse(response)

puts "Attempting to add ingredients to the database..."

result["drinks"].each do |ingredient|
  new_ingredient = Ingredient.create!(name: ingredient["strIngredient1"])
  puts "Added #{new_ingredient} to the database!"
end

puts "Successfully added #{Ingredient.count} ingredients to the database."
