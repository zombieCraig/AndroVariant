# This plugin reads through the strings in a DEX file and analyzes them in
# the same fashion a spell checker would but the 'dictionary' is a list
# of strings the checker is interested in finding near matches

# This 'spell checker' uses Levenshtein text distance algorithm

require 'AndroVPlugin'
require 'yaml'
require 'rubygems'
require 'text/levenshtein'

class SpellCheckerPlugin < AndroVPlugin

  def load_config
    config_file = File.open(File.join("config", "spell_check_settings.yml"))
    @settings = YAML.load(config_file)
    string_sigs = File.open(File.join("config", "string_sigs.yml"))
    @sigs = YAML.load(string_sigs)
  end

  def check_distance(str)
    @sigs.each do |variant, variantdata|
      variantdata.each do |sig|
        if sig.sig_type = "str" then
          distance = Text::Levenshtein.distance(str, sig.sig_data)
          if distance < @settings[:threshold] then
            puts "Found match: #{distance} #{str} =~ #{sig.sig_data}" if @settings[:verbose]
            sig.match = str
            sig.distance = distance
            sig.hits ? sig.hits += 1 : sig.hits = 1
            if distance = 0 then
              sig.exact_matches ? sig.exact_matches += 1 : sig.exact_matches = 1
            end
            @matches[variant] ? @matches[variant] += 1 : @matches[variant] = 1
          end
        end
      end
    end
  end

  def analyze
    @matches = {}
    @dex.strings.each do |str|
      if str.size >= @settings[:min_size] then
        if str=~/^L(\S+);$/ then
          $1.split("/").each do |chunk|
            check_distance(chunk) if chunk.size > @settings[:min_size]
          end
        else
          check_distance(str)
        end
      end
    end
  end

  def report
    puts "Results from SpellCheckerPlugin"
    puts "  Number of Strings:      #{@dex.strings.count}"
    if @matches.size > 0 then
      @matches.each do |variant, hits|
        puts "  Found variant #{variant}"
        @sigs[variant].each do |v|
          v.hits = 0 if not v.hits
          v.exact_matches = 0 if not v.exact_matches
          puts "    #{v.sig_data} found #{v.hits} expected #{v.expected_hits} exact matches #{v.exact_matches}"
        end
      end
    else
      puts "  No string constants breached nearest signature thresholds"
    end
    return @sigs
  end
end
