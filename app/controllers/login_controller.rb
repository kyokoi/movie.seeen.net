# encoding: utf-8

class LoginController < ApplicationController
  def index
    page_title "見た映画を記録しよう！"

    if logged_in?
      return redirect_to search_path
    end

    unless auth = request.env["omniauth.auth"]
      logger.info "No login status"
      return render
    end

    logger.info "Authentication is OKay"
    @author = Author.authorize auth

    session[:uid]      = @author.uid
    session[:provider] = @author.provider
    return redirect_to search_path
  end

  def failure
    logger.info "failure provider authentication"
    render :index
  end

  def logout
    session[:uid]      = nil
    session[:provider] = nil
  end
end
