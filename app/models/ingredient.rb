class Ingredient < ApplicationRecord
  has_many :cocktails, through: :doses
  has_many :doses

  validates :name, presence: true, uniqueness: true, allow_blank: false
end
