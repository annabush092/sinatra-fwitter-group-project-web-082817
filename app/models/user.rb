class User < ActiveRecord::Base
  has_many :tweets

  def slug
    self.username.downcase.split(" ").join("-")
  end

  def self.find_by_slug(sl)
    self.all.find do |user|
      user.slug == sl
    end
  end

  def authenticate(pw_attempt)
    if pw_attempt == self.password
      self 
    else
      false
    end
  end

end
