class Label < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  def element
    LabelElement.active.find self.element_id
  end
end
