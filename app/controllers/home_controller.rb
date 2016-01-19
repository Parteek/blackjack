class HomeController < ApplicationController
  before_action :auth_redirect!, only: [:index]

  def index

  end


  def logout
    session[:email] = nil
    redirect_to root_path
  end
end