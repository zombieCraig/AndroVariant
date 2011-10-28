# This plugin reads through the strings in a DEX file and analyzes them in
# the same fashion a spell checker would but the 'dictionary' is a list
# of strings the checker is interested in finding near matches

# This 'spell checker' uses Levenshtein text distance algorithm

require 'AndroVPlugin'
require 'yaml'
require 'rubygems'
require 'text/levenshtein'

class VariantData
  attr_accessor :match, :match_on, :distance, :variant, :hits, :exact_matches
end

class SpellCheckerPlugin < AndroVPlugin

  def load_config
    config_file = File.open(File.join("config", "spell_check_settings.yml"))
    @settings = YAML.load(config_file)
    string_sigs = File.open(File.join("config", "string_sigs.yml"))
    @sigs = YAML.load(string_sigs)
  end

  def check_distance(str)
    @sigs.each do |sig, variant|
      distance = Text::Levenshtein.distance(str, sig)
      if distance < @settings[:threshold] then
        puts "Found match: #{distance} #{str} =~ #{sig}" if @settings[:verbose]
        if @matches[variant] then
          @matches[variant].hits += 1
          @matches[variant].exact_matches += 1 if distance == 0
        else
          newVariant =  VariantData.new
          newVariant.match = str
          newVariant.match_on = sig
          newVariant.distance = distance
          newVariant.variant = variant
          newVariant.hits = 1
          if distance == 0 then
            newVariant.exact_matches = 1
          else
            newVariant.exact_matches = 0
          end
          @matches[variant] = newVariant # We only one one per variant
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
      @matches.each do |variant, match|
        if match.exact_matches == match.hits then
          puts "  Exact Match: #{variant} - Hits: #{match.hits} exact matches: #{match.exact_matches}"
        else
          puts "  Variant Match: #{variant} - Hits: #{match.hits} exact matches: #{match.exact_matches}"
        end
      end
    else
      puts "  No string constants breached nearest signature thresholds"
    end
  end
end
