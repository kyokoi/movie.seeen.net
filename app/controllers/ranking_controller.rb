# encoding: utf-8

class RankingController < ApplicationController

  before_filter do |controller|
    @display = 10
  end


  def seen
    @rankings = fetch_ranking [:weekly_seen, :monthly_seen, :yearly_seen, :all_seen]
    @rankings = {}
    [:weekly_seen, :monthly_seen, :yearly_seen, :all_seen].each do |title|
      @rankings[title] = RankingIterator.new title, Author
    end

    page_title '映画を見ている人のランキング'
    description "映画をよく見ている人のランキングです。"
  end

  def movie
    @rankings = {}
    [:weekly_movie, :monthly_movie, :yearly_movie, :all_movie].each do |title|
      @rankings[title] = RankingIterator.new title
    end

    page_title '映画のランキング'

    top_three = @rankings[:weekly_movie][0, 3].map{|movie| movie.name_of_japan}
    description "最近は、#{top_three.join('、')} がよく見られています。"
    top_three.each do |movie_name|
      keywords movie_name
    end
    keywords '映画のランキング'
  end

  def star
    @rankings = RankingIterator.new :stars

    page_title 'お気に入りの映画ランキング'

    top_three = @rankings[0, 3].map{|movie| movie[:name]}
    description "#{top_three.join('、')} がお気に入りによく登録されています。"
    top_three.each do |movie_name|
      keywords movie_name
    end
    keywords 'お気に入りの映画ランキング'
  end

  def wish
    @rankings = RankingIterator.new :wishs

    page_title "観たい映画のランキング"

    top_three = @rankings[0, 3].map{|movie| movie[:name]}
    description "最近は、#{top_three.join('、')} が人気です。"
    top_three.each do |movie_name|
      keywords movie_name
    end
    keywords '見たい映画ランキング'
  end

  def cinema
    @rankings = fetch_ranking [:cinemas]

    page_title '映画館ランキング'

    top_three = @rankings[:cinemas][:set][0, 3].map{|movie| movie[:name]}
    description "#{top_three.join('、')} が人気の映画館です。"
    top_three.each do |movie_name|
      keywords movie_name
    end
    keywords '映画館ランキング'
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

    top_three = @rankings[:set][0, 3].map{|movie| movie[:name]}
    description "#{top_three.join('、')} …のランキング１００位まで。"
    top_three.each do |movie_name|
      keywords movie_name
    end
  end
end
