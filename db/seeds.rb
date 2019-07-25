# Ingredient.delete_all if Rails.env.development?

require "json"
require "rest-client"

# response = RestClient.get 'https://raw.githubusercontent.com/maltyeva/iba-cocktails/master/ingredients.json'
# ingredients = JSON.parse(response.body)

# puts "Creating ingredients..."

# ingredients.each do |key, value|
#   Ingredient.create!(name: key)
# end

# puts "Successfully created #{Ingredient.count} ingredients"

puts "Creating cocktails..."

response = RestClient.get 'https://raw.githubusercontent.com/maltyeva/iba-cocktails/master/recipes.json'
cocktails = JSON.parse(response)

cocktails.each do |h|
  Cocktail.create!(name: h["name"])
end

puts "Successfully created #{Cocktail.count} cocktails"
