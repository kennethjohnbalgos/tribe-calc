module ApplicationHelper

  def main_page_active?
    !params[:controller].include?('devise')
  end
  
end
