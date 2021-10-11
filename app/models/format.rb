class Format < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, uniqueness: true

  has_many :format_bundles
  accepts_nested_attributes_for :format_bundles, allow_destroy: true

  def self.load_default
    seed_file = Rails.root.join('db', 'seeds', 'default_format.yml')
    data = YAML::load_file(seed_file)

    data.each do |f|
      format = Format.where(code: f["code"]).first_or_create
      format.update_attribute(:name, f["name"])
      f["bundles"].each do |b|
        bundle = format.format_bundles.where(quantity: b["quantity"]).first_or_create
        bundle.update_attribute(:price, b["price"])
      end
    
      quantities = f["bundles"].collect{|x| x["quantity"]}
      format.format_bundles.where.not(quantity: quantities).destroy_all
    end
  end
end
