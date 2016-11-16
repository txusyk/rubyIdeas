require_relative '../actor'
require 'test/unit'

class Tc_actor < Test::Unit::TestCase

  def test_initialize
    actorsArray = [Actor.new('Josu','Alvarez'), Actor.new('David','Max'), Actor.new('Koldo','Gojenola')]
    actorsArray.each_index do |index|
      assert_not_nil actorsArray[index].name
      p "Actor: #{actorsArray[index].name} #{actorsArray[index].surname}"
    end
  end
end