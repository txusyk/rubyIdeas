require 'test/unit'
require_relative '../file_manager'

class Tc_file_manager < Test::Unit::TestCase

  def test_normalizeStrings
    name1 = 'JosÃ¼ Ã„lvÃ¡rez'
    name2 = 'Ãˆneko GÃ³mez'
    name3 = 'DÃ¤vÃ¬d MÃ¤x'

    p "Name: JosÃ¼ Ã„lvÃ¡rez ---> #{File_manager.instance.normalize_strings(name1)}"
    p "Name: Ãˆneko GÃ³mez ---> #{File_manager.instance.normalize_strings(name2)}"
    p "Name: DÃ¤vÃ¬d MÃ¤x ---> #{File_manager.instance.normalize_strings(name3)}"

  end
end