class User < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :games

  #pending
  def money_left
    won_amount = self.games.won.sum(:win_amount)
    lost_amount = self.games.lost.sum(:bet_amount)
    won_amount - lost_amount
  end

end
