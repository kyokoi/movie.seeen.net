class Broadcast < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  belongs_to :movie

  #validates :movie_id, :presence => true, :exist_movie?
  validate :exist_movie?


  private

  def exist_movie?
    Movie.active.find self.movie_id
  rescue Exception => e
    errors.add :movie_id, e.to_s
  end
end
