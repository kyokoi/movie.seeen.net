# encoding: utf-8

class Story < ActiveRecord::Base
  LINK_MOVIE = /(\#\d+)\s/

  scope :active, lambda {
    where :negative => 0
  }

  belongs_to :author
  has_and_belongs_to_many :movies

  def search_movie
    replaced_contents = self.contents.to_s.split("\n").each do |line|
      next line unless line =~ LINK_MOVIE

      replacement = $1
      movie_id    = replacement.gsub '#', ''
      movie       = Movie.active.where(:id => movie_id).first
      next line if movie.blank?

      line = yield line, replacement, movie
      line
    end.join("\n")
    replaced_contents
  end
end
