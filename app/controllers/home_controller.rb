class HomeController < ApplicationController
  def index
    @input = calc_value
    @results = Format.process(@input) if @input.present?
  end

  def calc_value
    params[:calc].try("[]", "value")
  end
end
