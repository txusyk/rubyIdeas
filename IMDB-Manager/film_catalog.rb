require 'Singleton'
require_relative 'film'

class Film_catalog
  include Singleton

  attr_reader :film_l

  def initialize
    @film_l = Hash.new
  end

  def exist?(film_name)
    @film_l.has_key?(film_name)
  end

  def add(film)
    @film_l.store(film.name, film) unless exist?(film.name)
  end

  def get_film(film_name)
    @film_l.fetch(film_name) if exist?(film_name)
  end

  def size
    @film_l.size
  end

  def print_list
    @film_l.each_key do |key|
      puts key.to_s
    end
  end

end