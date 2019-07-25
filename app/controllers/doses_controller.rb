class DosesController < ApplicationController
  before_action :set_cocktail, only:[:new, :create, :destroy]

  def new
    @dose = Dose.new
  end

  def create
    @dose = Dose.new(dose_params)
    @dose.cocktail = @cocktail
    if @dose.save
      redirect_to cocktail_path(@cocktail)
    else
      render :new
    end
  end

  # def destroy
  #   @cocktail = Cocktail.find(params[:cocktail_id])
  # end

  private

  def dose_params
    params.require(:dose).permit(:description, :cocktail_id, :ingredient_id)
  end

  def set_cocktail
    @cocktail = Cocktail.find(params[:cocktail_id])
  end

  # def set_dose
  #   @dose = Dose.find(params[:id])
  # end
end
