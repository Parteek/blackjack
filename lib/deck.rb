module Deck
  CARDS = (1..52).to_a

  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods

    # Given a card number it returns the card name
    # card_number will be range 1..52
    def card_name
      card_type = self.card_type
      card_suit = self.card_suit
      card_type + " of " + card_suit
    end

    # Given a card number it returns the card type e.g ace, jack etc.
    # card_number will be range 1..52
    def card_type
      remainder = self.card_number%13
      case remainder
        when 1
          'Ace'
        when 11
          'Jack'
        when 12
          'Queen'
        when 0
          'King'
        else
          remainder.to_s
      end
    end

    # Given a card number it returns the card suit e.g hearts, spades etc.
    # card_number will be range 1..52
    def card_suit
      quotient = (self.card_number-1)/13
      case quotient
        when 0
          'clubs'
        when 1
          'diamonds'
        when 2
          'hearts'
        when 3
          'spades'
      end
    end
  end

  module ClassMethods

    # Given already_drawn_cards it returns a randomly chosen card from the remaining cards in the deck
    # already_drawn_cards will be an array and it will contain numbers in range 1..52
    def draw_card(already_drawn_cards)
      pending_cards = CARDS - already_drawn_cards
      pending_cards.shuffle.first
    end

    def first_four_cards
      CARDS.shuffle.first(4)
    end

  end

end
