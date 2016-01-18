class User < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email

  #pending
  def money_left
    0
  end

end
