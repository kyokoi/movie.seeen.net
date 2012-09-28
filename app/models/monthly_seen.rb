class MonthlySeen < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  belongs_to :author


  def self.monthly(target_month)
    start_date = target_month.beginning_of_month
    end_date   = target_month.end_of_month
    self.where :date => (start_date.to_date)..(end_date.to_date)
  end
end
