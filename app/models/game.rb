class Game < ActiveRecord::Base
  include BlackjackGame

  validates_presence_of :bet_amount, :user_id
  validates_numericality_of :bet_amount

  belongs_to :user
  has_many :drawn_cards

  enum status: {pending: 'pending', won: 'won', drew: 'drew', lost: 'lost'}

  after_commit :draw_four_cards, on: :create

  #it is called as soon as the game starts allocates 2 cards to player and dealer alternatively
  def draw_four_cards
    cards = DrawnCard.first_four_cards
    cards.each_with_index do |card_number, index|
      if index%2 == 0 #player_cards
        self.drawn_cards.create({user_id: self.user_id, card_number: card_number})
      else #dealer cards
        self.drawn_cards.create({user_id: nil, card_number: card_number})
      end
    end
  end

  #it draws one card and calls check for stop
  def draw_card(user_id)
    card_number = DrawnCard.draw_card(self.drawn_cards.pluck(:card_number))
    self.drawn_cards.create({user_id: user_id, card_number: card_number})
    self.check_for_stop user_id
  end

  #fetches card numbers from the db
  def card_numbers(user_id)
    self.drawn_cards.where(user_id: user_id).pluck(:card_number)
  end

  # calculates the score of the player or dealer in the game
  def calculate_score(user_id)
    Game.score(self.card_numbers user_id)
  end

  # this method checks for bust and forced stop for dealer
  def check_for_stop user_id
    score = self.calculate_score(user_id)
    if Game.bust?(score)
      if user_id.nil?
        self.update_attributes({dealer_score: score, status: 'won', win_amount: (self.bet_amount*2)})
      else
        self.update_attributes({player_score: score, status: 'lost'})
      end
    elsif Game.max_score?(self.card_numbers(user_id))
      self.stop(user_id)
    elsif user_id.nil? and Game.forced_stop?(self.card_numbers(user_id))
      self.stop(user_id)
    elsif user_id.nil? and Game.can_stop?(self.card_numbers(user_id))
      user_game_status, blackjack = self.decision_maker(self.card_numbers(user_id), self.card_numbers(self.user_id))
      if user_game_status == "lost"
        self.stop(user_id)
      end
    end

  end

  # this method stops the player or dealer if dealer stops then we get the result of the match and based on the result allocate money
  def stop(user_id)
    if user_id.present?
      self.update_attributes(player_score: calculate_score(user_id))
      check_for_stop nil
    else
      user_game_status, blackjack = self.decision_maker(self.card_numbers(nil), self.card_numbers(self.user_id))
      win_amount = nil
      if user_game_status == 'won' and blackjack
        win_amount = 2.5*bet_amount
      elsif user_game_status == 'won'
        win_amount = 2*bet_amount
      end
      self.update_attributes(dealer_score: calculate_score(user_id), status: user_game_status, win_amount: win_amount)
    end
  end

  #checks if dealer can stop
  def dealer_stop?
    Game.can_stop?(self.card_numbers nil)
  end
end
