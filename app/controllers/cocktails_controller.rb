class CocktailsController < ApplicationController
  before_action :set_cocktail, only:[:show, :edit, :update, :destroy]
  before_action :set_doses, only:[:show, :edit, :update, :destroy]

  def index
    @cocktails = Cocktail.all
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

  private

  def cocktail_params
    params.require(:cocktail).permit(:name, :image_url, :description)
  end

  def set_cocktail
    @cocktail = Cocktail.find(params[:id])
  end

  def set_doses
    @doses = Dose.where(cocktail_id: params[:id])
  end
end
