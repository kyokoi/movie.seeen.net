class Tag < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  include ApplicationModel

  ACONDITION_AREA = 85

  def self.area
    {:belong => ACONDITION_AREA}
  end

  def self.map_of_attribs
    [['Tag', '0'], ['Group', '1']]
  end

  def self.list_of_attribs
    Tag.where :negative => 0, :attrib => 1
  end

  def attrib_code
    code = 0
    code = 1 if self.attrib
    code
  end

  def attrib_name
    code = 'Tag'
    code = 'Group' if self.attrib
    code
  end

  def belong_tag
    return Tag.new(:id => 0, :name => 'Root') if self.belong == 0
    Tag.find_by_id_and_negative self.belong, 0
  rescue
    Tag.new :id => 0, :name => 'Unknown'
  end

  def follow_tags
    Tag.list_of_belong_for self.id
  end

  def self.list_of_belong_for(code)
    Tag.where :negative => 0, :belong => code
  end
end
