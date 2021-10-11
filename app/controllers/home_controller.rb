class HomeController < ApplicationController
  def index
    # Set the input value
    @input = calc_value
    # Set the results if there's an input value
    @results = Format.process(@input) if @input.present?
  end

  def calc_value
    params[:calc].try("[]", "value")
  end
end
