class MoviesResult < ActiveRecord::Base
  include ApplicationModel

  belongs_to :movie

  RESULT_SETS = ['245' => 'all', '246' => 'stars', '247' => 'no_stars', '248' => 'wish']

  def self.totalize(movie_id)
    results = self.where :negative => 0, :movie_id => movie_id
  end
end
