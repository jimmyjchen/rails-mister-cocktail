require "json"
require "rest-client"

class CocktailsController < ApplicationController
  before_action :set_cocktail, only: [:show, :edit, :update, :destroy]
  before_action :set_doses, only: [:show, :edit, :update, :destroy]

  def index
    @cocktails = Cocktail.all.order(name: :asc)
  end

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    if @cocktail.save
      redirect_to cocktail_path(@cocktail)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @cocktail.update(cocktail_params)
      redirect_to cocktail_path(@cocktail)
    else
      render :edit
    end
  end

  def destroy
    @cocktail.destroy
    redirect_to cocktails_path
  end

  def search
    @cocktail = show_cocktail(params[:search])
  end

  def add
    @cocktail = add_cocktail(params[:search])
    redirect_to cocktail_path(@cocktail)
  end

  private

  def cocktail_params
    params.require(:cocktail).permit(:name, :image_url, :description, :rating)
  end

  def set_cocktail
    @cocktail = Cocktail.find(params[:id])
  end

  def set_doses
    @doses = Dose.where(cocktail_id: params[:id])
  end


  def get_ingredients(result)
    ingredients = []

    result["drinks"][0].each_pair do |key, value|
      if value.nil?
        p "#{key}'s value is nil"
      elsif key.match(/strIngredient/) && value.match(/\S/)
        ingredients << result["drinks"][0][key]
      else
        p "#{key}'s value is empty"
      end
    end
    ingredients
  end

  def get_doses(result)
    doses = []

    result["drinks"][0].each_pair do |key, value|
      if value.nil?
        p "#{key}'s value is nil"
      elsif key.match(/strMeasure/) && value.match(/\S/)
        doses << result["drinks"][0][key]
      else
        p "#{key}'s value is empty"
      end
    end
    doses
  end

  def show_cocktail(query)
    cocktail = query["name"].downcase.capitalize
    response = RestClient.get "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=#{cocktail}"
    result = JSON.parse(response)
    if result["drinks"].nil?
      return nil
    end

    ingredients = get_ingredients(result)

    doses = get_doses(result)

    until doses.length == ingredients.length
      doses << 'N/A'
    end

    @cocktail_show = {
      name: cocktail,
      description: result["drinks"][0]["strInstructions"],
      image_url: result["drinks"][0]["strDrinkThumb"],
      glass: result["drinks"][0]["strGlass"],
      ingredients: ingredients,
      doses: doses
    }

    @cocktail_show
  end

  def add_cocktail(query)
    cocktail = query.downcase.capitalize

    response = RestClient.get "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=#{cocktail}"
    result = JSON.parse(response)

    check_cocktail = Cocktail.find_by(name: cocktail)
    if check_cocktail
      @new_cocktail = check_cocktail
    elsif result["drinks"].nil? == false
      @new_cocktail = Cocktail.create!(name: cocktail)
    else
      return nil
    end

    @new_cocktail.glass = result["drinks"][0]["strGlass"]
    @new_cocktail.description = result["drinks"][0]["strInstructions"]
    @new_cocktail.image_url = result["drinks"][0]["strDrinkThumb"]
    @new_cocktail.save

    ingredients = get_ingredients(result)

    doses = get_doses(result)

    ingredient_ids = []

    ingredients.each do |ingredient|
      check_ingredient = Ingredient.find_by(name: ingredient)
      if check_ingredient
        ingredient_ids << check_ingredient.id
      else
        new_ingredient = Ingredient.create!(name: ingredient)
        ingredient_ids << new_ingredient.id
      end
    end

    until doses.length == ingredients.length
      doses << 'N/A'
    end

    i = 0

    doses.each do |dose|
      new_dose = Dose.new(
        description: dose,
        cocktail_id: @new_cocktail.id,
        ingredient_id: ingredient_ids[i]
        )
      new_dose.ingredient = Ingredient.find(ingredient_ids[i])
      new_dose.save
      i += 1
    end

    @new_cocktail
  end
end
