require "rails_helper"

describe "Logout", type: :system do
  before do
    @user = create :user
  end

  scenario "valid for logged in user" do
    login(@user.email, @user.password)
    click_link "Log out"

    expect(page).to have_content "You have successfully logged out." # Process is working
    expect(page).to have_no_text "Welcome, #{@user.email.split('@').first}!" # User is not logged in
    expect(page).to have_no_link "Log out" # User should not see the log out link
  end

  scenario "not visible for non-logged in user" do
    visit new_user_session_path

    expect(page).to have_no_link "Log out" # User can see the log out link
  end
end