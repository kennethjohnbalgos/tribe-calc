require 'rails_helper'

RSpec.describe Format, type: :model do

  before do
    @format = create :format
    @bundle = @format.format_bundles.new
  end

  it "is valid with valid attributes" do
    @bundle.quantity = Faker::Number.number(digits: 1)
    @bundle.price = Faker::Number.decimal(l_digits: 2)
    
    expect(@bundle).to be_valid
  end

  it "is valid to have multiple bundles" do
    @bundle.quantity = Faker::Number.number(digits: 1)
    @bundle.price = Faker::Number.decimal(l_digits: 2)
    @bundle.save

    create :format_bundle, format: @format
    
    expect(@format.format_bundles.count).to eq(2)
  end

  it "is not valid without a quantity" do
    @bundle.quantity = nil
    @bundle.price = Faker::Number.decimal(l_digits: 2)

    expect(@bundle).to be_invalid
  end

  it "is not valid without a price" do
    @bundle.quantity = Faker::Number.number(digits: 1)
    @bundle.price = nil

    expect(@bundle).to be_invalid
  end 

  it "is not valid for not unique quantity" do
    existing_bundle = create :format_bundle, format: @format

    @bundle.quantity = existing_bundle.quantity
    @bundle.price = Faker::Number.decimal(l_digits: 2)

    expect(@bundle).to be_invalid
  end 

end
