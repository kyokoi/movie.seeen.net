# encoding: utf-8

class RootController < ApplicationController
  def index
    page_title "見た映画を記録しよう！index"
  end

  def login
    page_title "見た映画を記録しよう！login"

    @return_url = 'http://' + request.host + (params[:return_url] || root_path)
  end

  def login_callback
    return_url = authorize
    redirect_to return_url
  end

  def failure
    logger.info "failure provider authentication"
    render :index
  end

  def logout
    session[:uid]      = nil
    session[:provider] = nil
    logged_in?
  end
end
