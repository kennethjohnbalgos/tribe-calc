require "rails_helper"

describe "Calculator", type: :system do

  before do
    @format = create :format
    @bundle = create :format_bundle, format: @format
  end

  scenario "visitor viewing the format table" do
    visit root_path

    expect(page).to have_text "Welcome to Tribe:Calc!" # User is not logged in
    expect(page).to have_text "Submission Format" # Table is displayed
    expect(page).to have_text @format.code # Format is displayed
    expect(page).to have_text "#{@bundle.quantity} @ $#{@bundle.price}" # Bundle is displayed
  end

  scenario "guest viewing the format table" do
    @user = create :user
    login(@user.email, @user.password)

    expect(page).to have_text "Welcome, #{@user.email.split('@').first}!" # User is logged in
    expect(page).to have_text "Submission Format" # Table is displayed
    expect(page).to have_text @format.code # Format is displayed
    expect(page).to have_text "#{@bundle.quantity} @ $#{@bundle.price}" # Bundle is displayed
  end

end