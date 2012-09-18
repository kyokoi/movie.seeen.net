# encoding: utf-8

class ApplicationController < ActionController::Base

  INPUT_PATH = "#{Rails.root.to_s}/data/ranking/"
  SUPER_USERS = [1, 6, 7, 8, 17, 47]

  protect_from_forgery

  before_filter :logged_in?, :meta_initialize


  protected

  def page_title(message)
    @meta[:title] = "映画箱#{'：' unless message.blank? }#{message}"
  end

  def description(message)
    @meta[:description] = message
  end

  def keywords(message)
    @meta[:keywords].unshift message
  end

  def meta_initialize
    @meta = {
      :title        => '映画箱：見た映画を記録しよう',
      :description  => "見たい映画を記録する。見た映画を記録する。思い出の映画を忘れないように履歴をメモしよう。",
      :keywords     => [
        '映画メモ',
        '映画管理',
        '映画記録',
        '映画日記',
        '見た映画',
        '見たい映画',
        '観た映画',
        '観たい映画',
        '映画箱'
      ]
    }
  end

  def logged_in?
    uid      ||= session[:uid]
    provider ||= session[:provider]

    @author = Author.find_by_uid_and_provider_and_negative(uid, provider, 0)
#    @author = Author.new do |author|
#      author.id  = 1
#      author.uid = '1072433145'
#      author.name = 'Manabu Oshiro'
#      author.email = 'shirodai@gmail.com'
#      author.image = 'http://graph.facebook.com/1072433145/picture?type=square'
#      author.provider = 'facebook'
#    end
    @author ||= Author.create_guest
  end

  def logged_into_admin(author)
    unless special_user? author
      redirect_to root_path
      return
    end
    author
  end

  def special_user?(author)
    SUPER_USERS.include? author.id
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
