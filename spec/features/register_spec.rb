require "rails_helper"

describe "Register", type: :system do
  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password(min_length: 8) }

  scenario "valid for new account" do
    register(email, password, password)

    expect(page).to have_content "Welcome! You have signed up successfully." # Process is working
    expect(User.last.email).to eq(email) # User record is created
    expect(page).to have_text "Welcome, #{email.split('@').first}!" # User is  logged in
    expect(page).to have_link "Log out" # User can see the log out link
    expect(page).to have_current_path root_path # User is redirected to the main page
  end

  scenario "invalid for existing email" do
    @user = create :user
    register(@user.email, @user.password, @user.password)

    expect(page).to have_text "Email has already been taken" # Error is displayed
    expect(page).to have_no_text "Welcome, #{@user.email.split('@').first}!" # User should not be logged in
    expect(page).to have_no_link "Log out" # User should not see the log out link
  end

  scenario "invalid for non-matching password" do
    register(email, password, "xpassword")

    expect(page).to have_text "Password confirmation doesn't match" # Error is displayed
    expect(page).to have_no_text "Welcome, #{email.split('@').first}!" # User should not be logged in
    expect(page).to have_no_link "Log out" # User should not see the log out link
  end
end