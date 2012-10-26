class LabelElement < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  def belongs=(params)
    @belongs = params
  end

  def elements
    labels = Label.active.where :belong_id => self.id
    labels.map do |label|
      LabelElement.active.find label.element_id
    end
  end

  def belongs
    labels = Label.active.where :element_id => self.id
    labels.map do |label|
      LabelElement.active.find label.belong_id
    end
  end

  def destroy
    transaction do
      destroy_belongs  self.id
      destroy_elements self.id
      super
    end
  end

  def save!
    transaction do
      super
      destroy_belongs self.id
      unless @belongs.blank?
        @belongs.each do |belong|
          next if belong.to_i == 0
          label = Label.new do |l|
            l.element_id = self.id
            l.belong_id  = belong
          end
          label.save!
        end
      end
    end
    true
  end

  def destroy_belongs(element_id)
    sql = "DELETE FROM labels WHERE element_id = %d;"
    connection.execute sql % [element_id]
  end

  def destroy_elements(belong_id)
    sql = "DELETE FROM labels WHERE belong_id = %d;"
    connection.execute sql % [belong_id]
  end
end
