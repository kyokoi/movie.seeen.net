class MovieAttribute < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  belongs_to :movie


  def self.update(movie_id, movie_attributes)
    attributes = MovieAttribute.active.where :movie_id => movie_id
    attributes.each do |attribute|
      attribute.destroy
    end
    unless movie_attributes['regions'].blank?
      movie_attributes['regions'].each do |region_id|
        attribute = MovieAttribute.new
        attribute.movie_id   = movie_id
        attribute.element_id = region_id
        attribute.belong_id  = 1
        attribute.save!
      end
    end
  end
end
