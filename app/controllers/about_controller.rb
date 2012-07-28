class AboutController < ApplicationController
  def index
  end


  protected

  def redirect_to_login_if_one_do_not
    logged_in?
  end
end
