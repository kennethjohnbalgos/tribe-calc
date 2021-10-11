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

    expect(page).to have_css('.calc-input') # Calc input is visible
    expect(page).to have_css('calc-btn') # Calc field is visible
  end

  scenario "visitor can use the calculator field" do
    calculate("10 IMG 15 FLAC 13 VID")

    expect(page).to have_text "10 IMG $800" # IMG output is displayed
    expect(page).to have_text "15 FLAC $1957.50" # FLAC is displayed
    expect(page).to have_text "13 VID $2370" # VID is displayed
  end

end