class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def route_not_found
    flash[:alert] = "The page you requested doesn't exist"
    redirect_to root_path
  end
end
