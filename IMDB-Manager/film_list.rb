require_relative 'film'

class Film_list

  attr_reader :film_l

  def initialize
    @film_l = Hash.new
  end

  private
  def exist?(film_name)
    @film_l.has_key?(film_name)
  end

  public
  def add_film(film)
    @film_l.store(film.name, film) unless exist?(film.name)
  end

  def get_film(film_name)
    @film_l.fetch(film_name) if exist?(film_name)
  end

end