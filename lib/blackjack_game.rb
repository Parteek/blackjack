module BlackjackGame
  MAX_SCORE = 21
  MIN_DEALER_SCORE = 17
  FORCED_STOP = 17

  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
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
    def card_value(card_number)
      remainder = card_number%13
      case remainder
        when 0,11,12
          10
        else
          remainder
      end
    end

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

    def min_score(drawn_cards)
      score = 0
      drawn_cards.each do |card_number|
        value = card_value(card_number)
        score += value
      end
      score
    end

    def bust?(score)
      if score > MAX_SCORE
        true
      else
        false
      end
    end

    def forced_stop?(drawn_cards)
      if min_score(drawn_cards) == FORCED_STOP
        true
      end
    end

    def blackjack?(drawn_cards)
      if score(drawn_cards) == MAX_SCORE and drawn_cards.length == 2
        true
      else
        false
      end
    end

    def can_stop?(drawn_cards)
      if score(drawn_cards) >= MIN_DEALER_SCORE
        true
      else
        false
      end
    end

    def max_score?(drawn_cards)
      if score(drawn_cards) == MAX_SCORE
        true
      else
        false
      end
    end
  end
end