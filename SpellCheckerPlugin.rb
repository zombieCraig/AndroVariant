# This plugin reads through the strings in a DEX file and analyzes them in
# the same fashion a spell checker would but the 'dictionary' is a list
# of strings the checker is interested in finding near matches

require 'AndroVPlugin'

class SpellCheckerPlugin < AndroVPlugin

  def analyze
    
  end

  def report
    puts "Results from SpellCheckerPlugin"
    puts "  Number of Strings:      #{@dex.strings.count}"
  end
end
