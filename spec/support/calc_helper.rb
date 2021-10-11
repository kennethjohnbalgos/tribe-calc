module CalcHelper
  def calculate(order_string)
    visit root_path
    fill_in "calc_input", with: order_string
    click_button "Calculate"
  end
end