class MovieAttribute < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  belongs_to :movie
end
