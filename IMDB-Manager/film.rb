require_relative 'actor_list'

class Film

  attr_reader :name, :money_earned, :actor_list

  def initialize(film_name)
    @name = film_name
    @money_earned = 0
    @actor_list = Actor_list.new
  end

  def increment_money_earned (moneyToAdd)
    @money_earned += moneyToAdd
  end


end