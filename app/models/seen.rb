# encoding: utf-8

class Seen < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  EVALUATION_STAR_ID = 83
  EVALUATION_WISH_ID = 84

  belongs_to :movie
  belongs_to :author

  def self.wishes(author_id = nil)
    self.the_number_of_evaluation EVALUATION_WISH_ID, author_id
  end

  def self.stars(author_id = nil)
    self.the_number_of_evaluation EVALUATION_STAR_ID, author_id
  end

  def self.the_number_of_evaluation(evaluation, author_id)
    matches = self.where(:negative => 0, :evaluation => evaluation)
    unless author_id.blank?
      matches = matches.where :author_id => author_id
    end
    matches
  end

  def self.all_seens(author_id = nil)
    matches = self.active
    unless author_id.blank?
      matches = self.where :author_id => author_id
    end
    matches = matches.where self.no_wish
    matches
  end

  def self.wishlist(matches = self)
    matches.where(:negative => 0).where(self.wish)
  end

  def self.wish
    {:evaluation => EVALUATION_WISH_ID}
  end

  def self.no_wish
    self.not_equal EVALUATION_WISH_ID
  end

  def self.star
    {:evaluation => EVALUATION_STAR_ID}
  end

  def self.no_star
    self.not_equal EVALUATION_STAR_ID
  end

  def self.not_equal(tag_id)
    self.arel_table[:evaluation].not_eq(tag_id)
  end

  def self.not(column_name, value)
    self.where self.arel_table[column_name].not_eq(value)
  end

  def wish?
    self.evaluation.to_i == EVALUATION_WISH_ID
  end

  def star?
    self.evaluation.to_i == EVALUATION_STAR_ID
  end

  def evaluation_alt
    case
    when self.wish? then '見たい映画'
    when self.star? then 'お気に入りの映画'
    else
      '見たことがある映画'
    end
  end

  def acondition_tag
    if self.acondition.blank? || self.acondition == "0"
      tag = Tag.new
      tag.name = '未選択'
      return tag
    end
    Tag.where(:id => self.acondition, :attrib => 0, :negative => 0).first
  end

  def evaluation_tag
    tags = self.evaluation.split ','
    Tag.where(:id => tags, :attrib => 0, :negative => 0)
  end
end
