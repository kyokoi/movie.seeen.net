class Sample < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }
end
