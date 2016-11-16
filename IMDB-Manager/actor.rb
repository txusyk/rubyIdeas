require_relative 'film_list'

class Actor

  attr_reader :name, :surname, :film_list
  attr_writer :film_list

  def initialize(name, surname)
    @name = name.to_s
    @surname = surname.to_s
    @film_list = Film_list.new
  end
end