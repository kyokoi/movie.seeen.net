class Author < ActiveRecord::Base
  scope :active, lambda {
    where :negative => 0
  }

  include ApplicationModel

  has_many :seens
  has_many :monthly_seens

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
        user.image = "movies/_noimage.jpg" if user.image.nil?
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
end
