class AddRatingToCocktail < ActiveRecord::Migration[5.2]
  def change
    add_column :cocktails, :rating, :integer, default: 0, null: false
  end
end
