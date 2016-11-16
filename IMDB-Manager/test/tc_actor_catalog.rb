require 'test/unit'
require_relative '../actor_catalog'
require_relative '../actor'

class Tc_actor_catalog < Test::Unit::TestCase

  def test_initialize
    assert_not_nil(Actor_catalog.instance)
    p '*****'*5+'test_initialize'+'*****'*5
    p 'Is Actor_catalog null? --->'+Actor_catalog.instance.nil?.to_s
  end

  def test_add_exist?
    Actor_catalog.instance.add(Actor.new('Josu','Alvarez'))
    assert_equal(true, Actor_catalog.instance.exist?('Josu','Alvarez'))
    p '*****'*5+'test_add_exist?'+'*****'*5
    p "Actor: Josu Alvarez ---> #{Actor_catalog.instance.exist?('Josu','Alvarez')}"
  end

  def test_remove
    Actor_catalog.instance.remove(Actor.new('Josu','Alvarez'))
    p '*****'*5+'test_remove'+'*****'*5
    p "Actor: Josu Alvarez ---> #{Actor_catalog.instance.exist?('Josu','Alvarez')}"
  end

end