class AddGlassToCocktail < ActiveRecord::Migration[5.2]
  def change
    add_column :cocktails, :glass, :string
  end
end
