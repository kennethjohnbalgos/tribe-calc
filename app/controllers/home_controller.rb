class HomeController < ApplicationController
  def index
    @input = calc_value
  end

  def calc_value
    params[:calc].try("[]", "value")
  end
end
