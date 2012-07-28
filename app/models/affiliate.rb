class Affiliate < ActiveRecord::Base
  include ApplicationModel

  belongs_to :movie
end
