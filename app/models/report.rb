# encoding: utf-8

class Report < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  belongs_to :author


  def condition
    logger.info self.status
    self.status ? '対応済み' : '未対応'
  end

  def resolver
    if self.resolver_id.blank?
      return ' '
    end
    author = Author.active.find self.resolver_id
    author.name
  rescue Exception => e
    return '不明'
  end

  def self.unresolves
    self.active.where(:status => false).order("status, created_at DESC")
  end
end
