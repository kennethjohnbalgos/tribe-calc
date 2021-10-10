require "rails_helper"

describe "Login", type: :system do
  before do
    @user = create :user
  end

  scenario "valid if credentials are correct" do
    login(@user.email, @user.password)

    expect(page).to have_text "Welcome, #{@user.email.split('@').first}!" # User is logged in
    expect(page).to have_link "Log out" # User can see the log out link
    expect(page).to have_current_path root_path # User is redirected to the main page
  end

  scenario "invalid for unregistered email" do
    email = Faker::Internet.email
    login(email, "newpassword")

    expect(page).to have_no_text "Welcome, #{email.split('@').first}!" # User is not logged in
    expect(page).to have_text "Invalid email address or password." # Error is displayed
    expect(page).to have_no_link "Log out" # User should not see the log out link
  end

  scenario "invalid for wrong password" do
    login(@user.email, "invalidpassword")

    expect(page).to have_no_text "Welcome, #{@user.email.split('@').first}!" # User is not logged in
    expect(page).to have_text "Invalid email address or password." # Error is displayed
    expect(page).to have_no_link "Log out" # User should not see the log out link
  end
end