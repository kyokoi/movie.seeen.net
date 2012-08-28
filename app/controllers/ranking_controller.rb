# encoding: utf-8

class RankingController < ApplicationController

  before_filter do |controller|
    @display = 10
  end


  def seen
    page_title '最近映画を見ている人ランキング'
    @rankings = fetch_ranking [:weekly_seen, :monthly_seen, :yearly_seen, :all_seen]
  end

  def movie
    page_title '最近よく見られている映画ランキング'
    @rankings = fetch_ranking [:weekly_movie, :monthly_movie, :yearly_movie, :all_movie]
  end

  def star
    page_title 'お気に入りが多い映画ランキング'
    @rankings = fetch_ranking [:stars]
  end

  def wish
    page_title '見たいと思われている映画ランキング'
    @rankings = fetch_ranking [:wishs]
  end

  def cinema
    page_title '映画館ランキング'
    @rankings = fetch_ranking [:cinemas]
  end

  def detail
    @display  = 100

    kind_of_ranking = {
      :weekly_seen   => '最近１週間で映画を見ている人ランキングの詳細',
      :monthly_seen  => '最近１ヶ月で映画を見ている人ランキングの詳細',
      :yearly_seen   => '最近１年間で映画を見ている人ランキングの詳細',
      :all_seen      => '映画を見ている人ランキングの詳細',
      :weekly_movie  => '最近１週間でよく見られている映画ランキングの詳細',
      :monthly_movie => '最近１ヶ月でよく見られている映画ランキングの詳細',
      :yearly_movie  => '最近１年間でよく見られている映画ランキングの詳細',
      :all_movie     => 'よく見られている映画ランキングの詳細',
      :stars         => 'お気に入りが多い映画ランキングの詳細',
      :wishs         => '見たいと思われている映画ランキングの詳細',
      :cinemas       => '映画館ランキングの詳細'
    }
    kind = params[:kind]
    unless kind_of_ranking.include? kind.to_sym
      kind = :weekly_seen
    end
    page_title kind_of_ranking[kind.to_sym]
    @rankings = catch_data kind
  end
end
