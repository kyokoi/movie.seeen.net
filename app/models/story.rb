# encoding: utf-8

class Story < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  belongs_to :author
end
