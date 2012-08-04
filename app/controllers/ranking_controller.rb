# encoding: utf-8

class RankingController < ApplicationController
  INPUT_PATH = '/usr/local/apps/movie_seen/data/ranking/'

  def seen
    @display  = 10
    @rankings = compile [:weekly_seen, :monthly_seen, :yearly_seen, :all_seen]
  end

  def movie
    @display  = 10
    @rankings = compile [:weekly_movie, :monthly_movie, :yearly_movie, :all_movie]
  end

  def star
    @display  = 10
    @rankings = compile [:stars]
  end

  def wish
    @display  = 10
    @rankings = compile [:wishs]
  end

  def cinema
    @display  = 10
    @rankings = compile [:cinemas]
  end

  def detail
    @display  = 100
    @rankings = catch_data params[:kind]
  end


  private

  def compile(target)
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
