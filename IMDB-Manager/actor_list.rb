require_relative 'actor'

class Actor_list

  def initialize
    @actor_list = Hash.new
  end

  def exist? (name, surname)
    @actor_list.has_key?(name+' '+surname)
  end

  def add_actor (actor)
    @actor_list.store(actor.name+' '+actor.surname, actor) unless exist?(actor.name,actor.surname)
  end

  def get_actor (name,surname)
    @actor_list.fetch(name+' '+surname) if exist?(name,surname)
  end

  def remove_actor (actor)
    actor_name = "#{actor.name} #{actor.surname}"
    @actor_list.delete(actor_name) if exist?(actor.name, actor.surname)
  end

  def print_actors
    puts 'These are all the actors'
    puts @actor_list.each_key
  end

end