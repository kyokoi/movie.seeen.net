class Movie < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  include ApplicationModel

  has_many :seens
  has_many :affiliates
  has_and_belongs_to_many :stories

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

    matches = []
    ids.each do |id|
      begin
        match = Movie.active.find id
        matches << match unless match.blank?
      rescue Exception => e
        logger.error e
      end
    end
    matches
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
    matches = Seen.active.where(:movie_id => self.id).where(Seen.no_wish)
    if author_id
      matches = matches.where author_id => author_id
    end
    matches
  end

  def wish_users(author_id = nil)
    matches = Seen.active.where(:movie_id => self.id).wishes
    if author_id
      matches = matches.where author_id => author_id
    end
    matches
  end

  def stars
    Seen.stars.where(:movie_id => self.id)
  end
end
