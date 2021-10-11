class FormatBundle < ApplicationRecord
  validates :quantity, :price, presence: true
  validates :quantity, uniqueness: true

  belongs_to :format

  scope :sort_quantity, ->{ order(:quantity) }
  scope :sort_quantity_reverse,   ->{ order(quantity: :desc) }
end
