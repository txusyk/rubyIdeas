require 'test/unit'
require_relative '../film_catalog'
require_relative '../actor'

class Tc_film_catalog < Test::Unit::TestCase

  def test_initialize
    assert_not_nil(Film_catalog.instance)
  end

  def test_add_exist?
    assert_equal(false, Film_catalog.instance.exist?('Guardians of Galaxy'))
    Film_catalog.instance.add(Film.new('Guardians of Galaxy'))
    assert_equal(true, Film_catalog.instance.exist?('Guardians of Galaxy'))
  end

  def test_get_film
    film = Film.new('Fargo')
    #We do not have added the film yet
    assert_equal(nil, Film_catalog.instance.get_film('Fargo'))

    #We add the film now
    Film_catalog.instance.add(film)
    assert_equal(film, Film_catalog.instance.get_film('Fargo'))
  end

  def test_size
    #We have added 2 films before
    assert_equal(2, Film_catalog.instance.size)
  end

  def test_print_list
    Film_catalog.instance.print_list
  end
end