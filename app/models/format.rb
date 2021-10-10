class Format < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, uniqueness: true

  has_many :format_bundles
  accepts_nested_attributes_for :format_bundles, allow_destroy: true

  default_scope ->{ order(:quantity) }
end
