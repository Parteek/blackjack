module BlackjackGame
  MAX_SCORE = 21
  MIN_DEALER_SCORE = 17
  FORCED_STOP = 17

  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods

    # this method works if no one is busted
    # it takes the dealer cards and player cards and applies the rules and declares the winner
    def decision_maker(dealer_cards, player_cards)
      dealer_score = self.class.score(dealer_cards)
      player_score = self.class.score(player_cards)
      game_status = ''
      blackjack = false
      if player_score > dealer_score
        game_status = 'won'
      elsif dealer_score > player_score
        game_status = 'lost'
      else
        player_blackjack = self.class.blackjack?(player_cards)
        dealer_blackjack = self.class.blackjack?(dealer_cards)
        if dealer_blackjack and player_blackjack
          game_status = 'drew'
        elsif player_blackjack
          game_status = 'won'
          blackjack = true
        elsif dealer_blackjack
          game_status = 'lost'
        else
          game_status = 'drew'
        end
      end
      return game_status, blackjack
    end
  end

  module ClassMethods
    # it gives the min card values for a card for example for card number 1 (ace) gives 1
    def card_value(card_number)
      remainder = card_number%13
      case remainder
        when 0,11,12
          10
        else
          remainder
      end
    end

    # it calculates the max possible score (without bust if possible) using the drawn cards array
    def score(drawn_cards)
      ace_present = false
      score = 0
      drawn_cards.each do |card_number|
        value = card_value(card_number)
        score += value
        ace_present = true if value == 1
      end
      if ace_present and score + 10 <= 21
        score+10
      else
        score
      end
    end

    # it calculates the min possible score using the drawn cards array
    def min_score(drawn_cards)
      score = 0
      drawn_cards.each do |card_number|
        value = card_value(card_number)
        score += value
      end
      score
    end

    # it takes the score as input and checks for the bust
    def bust?(score)
      if score > MAX_SCORE
        true
      else
        false
      end
    end

    # it checks for the dealer if he has to force stop on some score given drawn_cards.
    def forced_stop?(drawn_cards)
      if min_score(drawn_cards) == FORCED_STOP
        true
      end
    end

    # it checks for the blackjack given drawn cards
    def blackjack?(drawn_cards)
      if max_score?(drawn_cards) and drawn_cards.length == 2
        true
      else
        false
      end
    end

    # it checks for the dealer if he can stop on some score given drawn_cards.
    def can_stop?(drawn_cards)
      if score(drawn_cards) >= MIN_DEALER_SCORE
        true
      else
        false
      end
    end

    # it checks the score is the max score for given drawn cards
    def max_score?(drawn_cards)
      if score(drawn_cards) == MAX_SCORE
        true
      else
        false
      end
    end
  end
end