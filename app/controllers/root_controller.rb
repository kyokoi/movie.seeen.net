# encoding: utf-8

class RootController < ApplicationController

  INDEX_STORIES_LIMIT        = 3
  INDEX_SUMMARY_MOVIE_LIMIT  = 10
  INDEX_SUMMARY_AUTHOR_LIMIT = 10

  def index
    page_title "観た映画管理サイト　観たい映画管理サイト"
    description "観た映画は記録しよう。観たい映画もメモしよう。思い出の映画は、管理、記録、メモ。自分だけの映画履歴を作っちゃおう。日本最大級の映画管理サイトを目指します。"

    # posts
    @posts = Story.active.limit INDEX_STORIES_LIMIT
    @posts = @posts.order "release_at, created_at DESC"

    @weekly = fetch_ranking [:weekly_movie]
    @weekly[:weekly_movie][:set].slice!(INDEX_SUMMARY_MOVIE_LIMIT..-1)

    @weekly[:weekly_movie][:set].map! do |movie|
      movie_for_outline = Movie.active.where(:id => movie[:id]).first
      movie[:outline] = movie_for_outline.outline || ''

      movie[:stars] = Seen.where(:movie_id => movie[:id]).stars.count
      movie[:watch] = Seen.active.where(:movie_id => movie[:id]).where(Seen.no_wish).count
      movie[:wish]  = Seen.active.where(:movie_id => movie[:id]).wishes.count

      seens = Seen.active.where(:movie_id => movie[:id])
      seens = seens.limit(INDEX_SUMMARY_AUTHOR_LIMIT).order("date DESC")
      movie[:seens] = seens
      movie
    end
  end

  def login
    page_title "見た映画を記録しよう！"

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
