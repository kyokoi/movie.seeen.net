# encoding: utf-8

class Author < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  has_many :monthly_seens
  has_many :reports
  has_many :seen_comments
  has_many :seens
  has_many :stories


  def self.service_login_author(author = nil)
    @@author = author if author
    @@author
  end

  def guest?
    yield if block_given? && self.uid.blank?
    self.uid.blank?
  end

  def facebooker?
    self.belong? [:facebook]
  end

  def twitterian?
    self.belong? [:twitter]
  end

  def googlist?
    self.belong? [:google_oauth2]
  end

  def belong?(service_name = nil)
    if service_name.blank?
      service_name = [:facebook, :twitter, :google_oauth2]
    end
    service_name.include? self.provider.to_sym
  end

  def name_by_status
    yield if @@author.guest?
    self.name
  end

  def same?(author)
    self.id == author.id
  end

  def self.authorize(auth)
    author = active.where(
      :provider => auth['provider'], :uid => auth['uid']
    ).first

    if author.blank?
      author = create! do |user|
        user.uid      = auth['uid']
        user.name     = auth['info']['name']
        user.email    = auth['info']['email']
        user.image    = auth['info']['image']
        user.provider = auth['provider']

        user.email = "" if user.email.nil?
        user.image = "movies/_noimage.jpg" if user.image.blank?
      end
    end

    need_to_update = case
    when author.name  != auth['info']['name']
      author.name = auth['info']['name']
    when author.email != auth['info']['email']
      author.email = auth['info']['email']
    when author.image != auth['info']['image']
      author.image = auth['info']['image']
    end
    author.save! if need_to_update

    author
  end

  def self.create_guest
    author = Author.new do |user|
      user.uid      = nil
      user.name     = 'ゲスト'
      user.provider = 'movie.seeen.net'

      user.email = "" if user.email.nil?
      user.image = "movies/_noimage.jpg" if user.image.blank?
    end
    author
  end
end
