# encoding: utf-8

class ApplicationController < ActionController::Base

  INPUT_PATH = '/usr/local/apps/movie_seen/data/ranking/'
  SUPER_USERS = [1, 6, 7, 8, 17, 47]

  protect_from_forgery

  before_filter :logged_in?


  protected

  def page_title(messege)
    @page_title = "#{messege} - 映画の履歴を残す 見たい映画をメモ・記録する"
  end

  def logged_in?
    uid      ||= session[:uid]
    provider ||= session[:provider]

    @author = Author.find_by_uid_and_provider_and_negative(uid, provider, 0)
    @author ||= Author.create_guest
  end

  def logged_into_admin(author)
    unless SUPER_USERS.include? author.id
      redirect_to :controller => 'login'
      return
    end
  end

  def authorize
    unless auth = request.env["omniauth.auth"]
      logger.info "No login status"
      return render
    end

    logger.info "Authentication is OKay"
    @author = Author.authorize auth

    session[:uid]      = @author.uid
    session[:provider] = @author.provider

    return_url = request.env['omniauth.origin'] || root_path
  end

  def fetch_ranking(target)
    rankings = Hash.new
    target.each do |title|
      if contents = catch_data(title)
        rankings[title] = contents
      end
    end
    rankings
  end

  def catch_data(title)
    YAML.load_file "#{INPUT_PATH}#{title}.yml"
  end
end
