require 'rails_helper'

RSpec.describe Format, type: :model do

  before do
    @format = Format.new
  end

  it "is valid with valid attributes" do
    @format.name = Faker::Code.imei
    @format.code = Faker::Code.imei
    
    expect(@format).to be_valid
  end

  it "is not valid without a name" do
    @format.name = nil
    @format.code = Faker::Code.imei

    expect(@format).to be_invalid
  end

  it "is not valid without a code" do
    @format.name = Faker::Code.imei
    @format.code = nil

    expect(@format).to be_invalid
  end 

  it "is not valid for not unique code" do
    existing_format = create :format

    @format.name = Faker::Code.imei
    @format.code = existing_format.code

    expect(@format).to be_invalid
  end 

end
