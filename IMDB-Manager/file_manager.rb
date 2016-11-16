require 'Singleton'
require 'Time'
require_relative 'film_catalog'
require_relative 'actor_catalog'
require_relative 'film_list'
require_relative 'actor_list'
require_relative 'film'
require_relative 'actor'

class File_manager
  include Singleton

  def normalize_strings(line)
    error_chars = Hash.new
    error_chars.store('Ã¡', 'a')
    error_chars.store('Ã©', 'e')
    error_chars.store('Ã­', 'i')
    error_chars.store('Ã³', 'o')
    error_chars.store('Ãº', 'u')
    error_chars.store('Ã�', 'A')
    error_chars.store('Ã‰', 'E')
    error_chars.store('Ã�', 'I')
    error_chars.store('Ã“', 'O')
    error_chars.store('Ãš', 'U')
    error_chars.store('Ã¤', 'a')
    error_chars.store('Ã«', 'e')
    error_chars.store('Ã¯', 'i')
    error_chars.store('Ã¶', 'o')
    error_chars.store('Ã¼', 'u')
    error_chars.store('Ã„', 'A')
    error_chars.store('Ã‹', 'E')
    error_chars.store('Ã�', 'I')
    error_chars.store('Ã–', 'O')
    error_chars.store('Ãœ', 'U')
    error_chars.store('Ã§', 'c')
    error_chars.store('Ã ', 'a')
    error_chars.store('Ã¨', 'e')
    error_chars.store('Ã¬', 'i')
    error_chars.store('Ã²', 'o')
    error_chars.store('Ã¹', 'u')
    error_chars.store('Ã€', 'A')
    error_chars.store('Ãˆ', 'E')
    error_chars.store('ÃŒ', 'I')
    error_chars.store('Ã’', 'O')
    error_chars.store('Ã™', 'U')
    error_chars.store('Ã§', 'c')
    error_chars.store('Ã‡', 'C')

    error_chars.each_key do |key|
      line.gsub!(key, error_chars.fetch(key)) if line.include?(key)
    end
    line
  end

  def file_read(opt)
    puts '*'*25+" Start reading file "+'*'*25
    @t1 = Time.now
    File.open('/Users/Josu/IdeaProjects/EDA16-17/src/lab1/testAllActors.txt', 'r') do |f|
      f.each_line do |line|
        aux_line = line.split("\s--->\s")
        film_name = aux_line[0] # we have the name of the film
        aux_line2 = aux_line[1].split("\s&&&\s") #here we have and array with the actor names
        if opt.equal? 1
          unless film_name.include?('�')
            film_name = self.normalize_strings(film_name)
            Film_catalog.instance.add(Film.new(film_name))
          end
        else
          Film_catalog.instance.add(Film.new(film_name))
        end
        aux_line2.each_index do |index|

          actor_name = aux_line2[index]

          if actor_name.include?('(')
            aux_line = actor_name.split("\s(")
            actor_name = aux_line[0]

          end
          if actor_name.include?(',')
            aux_line = actor_name.split(",\s")
            if aux_line.length > 0
              unless aux_line[1].nil?
                @actor_surname = aux_line[0].split("\n")[0]
                @actor_name = aux_line[1]
              else
                @actor_name = aux_line[0]
              end
            end
          end
        end
        aux_actor = Actor.new(@actor_name,@actor_surname)
        if opt.eql? 1
          unless aux_actor.name.include?('�')
            aux_actor.film_list.add_film(Film.new(film_name))
            Actor_catalog.instance.add_actor(aux_actor)
            unless film_name.include?('�')
              Film_catalog.instance.get_film(film_name).actor_list.add_actor(aux_actor)
            end
          end
        else
          aux_actor.film_list.add_film(Film.new(film_name))
          Actor_catalog.instance.add_actor(aux_actor)
          Film_catalog.instance.get_film(film_name).actor_list.add_actor(aux_actor)
        end
      end
    end
    puts '*'*25+' Finished file reading '+'*'*25
    puts " Whe have spent : #{Time.now - @t1} sec"
    puts "We have storaged #{Film_catalog.instance.size} films"
  end
end

File_manager.instance.file_read(2)