# encoding: utf-8

class RankingController < ApplicationController

  def seen
    @display  = 10
    @rankings = fetch_ranking [:weekly_seen, :monthly_seen, :yearly_seen, :all_seen]
  end

  def movie
    @display  = 10
    @rankings = fetch_ranking [:weekly_movie, :monthly_movie, :yearly_movie, :all_movie]
  end

  def star
    @display  = 10
    @rankings = fetch_ranking [:stars]
  end

  def wish
    @display  = 10
    @rankings = fetch_ranking [:wishs]
  end

  def cinema
    @display  = 10
    @rankings = fetch_ranking [:cinemas]
  end

  def detail
    @display  = 100
    @rankings = catch_data params[:kind]
  end
end
