# Ingredient.delete_all if Rails.env.development?

require "json"
require "rest-client"

def add_cocktail(query)
  cocktail = query.downcase.capitalize

  response = RestClient.get "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=#{cocktail}"
  result = JSON.parse(response)

  check_cocktail = Cocktail.find_by(name: cocktail)

  if check_cocktail
    puts "#{cocktail} - #{check_cocktail.id}"
    new_cocktail = check_cocktail
  else
    new_cocktail = Cocktail.create!(name: cocktail)
  end

  # new_cocktail.glass = result["drinks"][0]["strGlass"]
  new_cocktail.description = result["drinks"][0]["strInstructions"]
  new_cocktail.image_url = result["drinks"][0]["strDrinkThumb"]
  new_cocktail.save

  ingredients = []

  result["drinks"][0].keys.each do |key|
    if key.match(/strIngredient/)
      ingredients << result["drinks"][0][key] if result["drinks"][0][key] != ""
    end
  end

  doses = []

  result["drinks"][0].keys.each do |key|
    if key.match(/strMeasure/)
      doses << result["drinks"][0][key] if result["drinks"][0][key] != ""
    end
  end

  p ingredients

  ingredient_ids = []

  ingredients.each do |ingredient|
    check_ingredient = Ingredient.find_by(name: ingredient)
    if check_ingredient
      ingredient_ids << check_ingredient.id
    else
      Ingredient.create!(name: ingredient)
    end
  end

  while doses.length < ingredient_ids.length
    doses << 0
  end

  i = 0

  doses.each do |dose|
    new_dose = Dose.new(
      description: dose,
      cocktail_id: new_cocktail.id,
      ingredient_id: ingredient_ids[i]
      )
    new_dose.ingredient = Ingredient.find(ingredient_ids[i])
    new_dose.save
    i += 1
  end
end



