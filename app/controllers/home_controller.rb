class HomeController < ApplicationController

  def index

  end


  def logout
    session[:email] = nil
    redirect_to root_path
  end
end