class FormatBundle < ApplicationRecord
  validates :quantity, :price, presence: true
  validates :quantity, uniqueness: true

  belongs_to :format
end
