require '/usr/local/apps/movie_seen/app/models/movies_reslut'

class Movie < ActiveRecord::Base
  include ApplicationModel

  has_many :seens
  has_many :affiliates

  MOVIESRESUT_KIND_OF_SEENS  = 245
  MOVIESRESUT_KIND_OF_STARS  = 246
  MOVIESRESUT_KIND_OF_WISHES = 248


  def self.text_search(word, matches = Movie)
    word.split(/[[:space:]]/, 3).each do |sentence|
      next if sentence.blank?
      matches = matches.where(
        'name_of_original LIKE ? OR name_of_japan LIKE ? OR name_of_japan_kana LIKE ? OR name_of_english LIKE ? OR outline LIKE ?',
        "%#{sentence}%",
        "%#{sentence}%",
        "%#{sentence}%",
        "%#{sentence}%",
        "%#{sentence}%"
      )
    end
    matches
  end

  def category_tag
    tags = self.category.split ','
    Tag.where(:id => tags, :attrib => 0, :negative => 0)
  end

  def result_of_seen
    result MOVIESRESUT_KIND_OF_SEENS
  end

  def result_of_star
    result MOVIESRESUT_KIND_OF_STARS
  end

  def result_of_wish
    result MOVIESRESUT_KIND_OF_WISHES
  end

  def result(kind_id)
    movie_result = MoviesResult.where(
      :movie_id => self.id, :kind_id  => kind_id, :negative => 0
    ).first
    if movie_result.blank?
      movie_result = MoviesResult.new
      movie_result.movie_id = self.id
      movie_result.kind_id  = kind_id
      movie_result.number   = false
      movie_result.negative = 0
    end
    movie_result
  end

  def seen_users(author_id = nil)
    matches = Seen.where :negative => 0, :movie_id => self.id
    matches = matches.where Seen.no_wish
    if author_id
      matches = matches.where author_id => author_id
    end
    matches
  end
end
