require "rails_helper"

describe "Calculator", type: :feature do

  before do
    Format.load_default
  end

  scenario "visitor can see the format table" do
    visit root_path
    
    expect(page).to have_selector '.format-entry', count: 3 # Default format should be displayed
  end

  scenario "visitor can see the calculator field" do
    visit root_path
    
    expect(page).to have_field 'calc_value' # Calc input is visible
    expect(page).to have_button "Calculate" # Calc field is visible
  end

  scenario "visitor can use the calculator field" do
    calculate("10 IMG 15 FLAC 13 VID")

    expect(page).to have_text "10 IMG - $800.00" # IMG output is displayed
    expect(page).to have_text "15 FLAC - $1,957.50" # FLAC is displayed
    expect(page).to have_text "13 VID - $2,370.00" # VID is displayed
  end

  scenario "visitor can use lower case codes" do
    calculate("15 img 15 flac 15 vid")

    expect(page).to have_text "15 IMG - $1,250.00" # IMG output is displayed
    expect(page).to have_text "15 FLAC - $1,957.50" # FLAC is displayed
    expect(page).to have_text "15 VID - $2,670.00" # VID is displayed
  end

  scenario "visitor can see invalid combination error" do
    calculate("16 img")

    expect(page).to have_text "16 IMG" # IMG output is displayed
    expect(page).to have_text "No bundle combination found." # Error is displayed
  end

  scenario "visitor can order just one format" do
    calculate("25 img")

    expect(page).to have_text "25 IMG - $2,050.00" # IMG output is displayed
    expect(page).to have_text "2 x 10" # Correct result is displayed
    expect(page).to have_text "1 x 5" # Correct result is displayed
    expect(page).to have_no_text "FLAC -" # FLAC output is not displayed
    expect(page).to have_no_text "VID -" # VID output is not displayed
  end

  scenario "visitor can see the hint and example" do
    calculate("25 img")

    expect(page).to have_text "Hint:" # Hint should be visible
    expect(page).to have_text "Example:" # Example should be visibles
  end

end