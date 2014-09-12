require 'minitest/autorun'

require_relative 'neologisim'

class RenamerTest < MiniTest::Test

  def setup
    @files = ["Papa Gee","Mama Gee"]
    @neo = Renamer.new(@files)
  end

  def test_use_no_regex
    new_files = ["|Papa Gee|","|Mama Gee|"]
    assert_equal new_files, @neo.select
  end

  def test_simple_select
    new_files = ["Papa |Gee|","Mama |Gee|"]
    assert_equal new_files, @neo.select("Gee")
  end

  def test_simple_replace
    new_files = ["Papa |Okay|","Mama |Okay|"]
    @neo.select("Gee")
    assert_equal new_files, @neo.replace("Okay")
  end

end
