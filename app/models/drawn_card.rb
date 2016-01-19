class DrawnCard < ActiveRecord::Base
  include Deck
  validates_presence_of :game_id, :card_number
  validates_numericality_of :game_id, :card_number

  belongs_to :user
  belongs_to :game
end
