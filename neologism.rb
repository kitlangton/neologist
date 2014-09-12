require 'thor'
require 'rainbow'

class Neologist < Thor
  desc "neolog", "select some text to replace"
  def neolog
    d = Dir.new(Dir.pwd)
    files = []
    d.each do |file|
      files << file if file !~ /^\.+$/
    end
    puts files
    renamer = Renamer.new(files)
    select_text = ask(Rainbow("Pattern:").red)
    renamer.select(select_text)
    puts "--"
    puts renamer.show_selections
    selections = renamer.selections
    puts "=="
    replace_text = ask(Rainbow("Replacement:").blue)
    puts "--"
    renamer.replace(replace_text)
    puts renamer.show_replacements
    puts "\n"
    neologisms = renamer.neologisms

    return unless yes?('Make change?')
    selections.each do |selection|
      File.rename(selection,neologisms.shift)
    end
  end
end

class Renamer

  attr_reader :orig_names, :selections, :last_regex, :neologisms, :last_replace

  def initialize(orig_names)
    @orig_names = orig_names
  end

  def select regex = ".+"
    make_selection regex
  end

  def replace replacement
    @neologisms = make_replacement replacement
  end

  def show_selections
    orig_names.map do |file|
      file.gsub(/(#{last_regex})/,Rainbow("\\1").red)
    end
  end

  def show_replacements 
    selections.map do |file|
      file.gsub(/#{last_regex}/,Rainbow("#{last_replace}").blue)
    end
  end

  private

  def make_selection regex
    @last_regex = regex
    @selections = orig_names.select{|f| f =~ /#{regex}/ }
  end

  def make_replacement replacement
    @last_replace = replacement
    selections.map do |file|
      file.gsub(/#{last_regex}/,"#{replacement}")
    end
  end



end

# d = Dir.new("#{Dir.home}/Desktop/Test Renamer/")
# Dir.chdir(d)
# d.each do |f|
#   next unless f.include?("Screen")
#   File.rename( f, new_name )
#   p new_name
# end

#
#
# puts "Enter the file search query"
# searchPattern = gets.strip
# puts "Enter the target to replace"
# target = gets.strip
# puts "Enter the new target name"
# newTarget = gets.strip
# Dir.glob(searchPattern).sort.each do |entry|
#   if File.basename(entry, File.extname(entry)).include?(target)
#     newEntry = entry.gsub(target, newTarget)
#     File.rename( entry, newEntry )
#     puts "Rename from " + entry + " to " + newEntry
#   end
# end
