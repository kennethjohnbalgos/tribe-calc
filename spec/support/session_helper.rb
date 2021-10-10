module SessionHelper
  def login(email, password)
    visit new_user_session_path
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    click_button "Log in"
  end

  def register(email, password, password_confirmation)
    visit new_user_registration_path
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    fill_in "user_password_confirmation", with: password_confirmation
    click_button "Register"
  end
end