require 'Singleton'
require_relative 'actor'

class Actor_catalog
  include Singleton

  attr_reader :actorL

  def initialize
    @actorL = Hash.new
  end

  def exist? (name, surname)
    @actorL.has_key?(name+' '+surname)
  end

  def add_actor(actor)
    @actorL.store(actor.name+' '+actor.surname, actor) unless exist?(actor.name, actor.surname)
  end

  def remove(actor)
    @actorL.delete(actor.name+' '+actor.surname) if exist?(actor.name, actor.surname)
  end

  def size
    @actorL.keys.size
  end

  def print
    @actorL.each_key do |key|
      puts key.to_s
    end
  end

end