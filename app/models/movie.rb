class Movie < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  include ApplicationModel

  has_many :seens
  has_many :affiliates

  def self.search(word, offset, limit)
    search = SearchMovie.new
    search.keywords = word
    search.offset   = offset
    search.limit    = limit

    header, response = search.pull

    yield response

    ids = response['docs'].map do |element|
      element['id']
    end
    matches = Movie.active.where :id => ids
  end

  def self.text_search(word, offset, matches = Movie)
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

  def seen_users(author_id = nil)
    matches = Seen.where :negative => 0, :movie_id => self.id
    matches = matches.where Seen.no_wish
    if author_id
      matches = matches.where author_id => author_id
    end
    matches
  end
end
