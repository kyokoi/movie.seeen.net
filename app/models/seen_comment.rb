class SeenComment < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  belongs_to :author
  belongs_to :seen

  validate :exist_related_model?


  private

  def exist_related_model?
    begin
      Seen.active.find self.seen_id
    rescue Exception => e
      errors.add :seen_id, e.to_s
    end
    begin
      Author.active.find self.author_id
    rescue Exception => e
      errors.add :author_id, e.to_s
    end
  end
end
