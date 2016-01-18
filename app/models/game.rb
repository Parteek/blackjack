class Game < ActiveRecord::Base
  validates_presence_of :bet_amount, :user_id
  validates_numericality_of :bet_amount
  belongs_to :user

  enum status: {pending: 'pending', won: 'won', drew: 'drew', lost: 'lost'}
end
