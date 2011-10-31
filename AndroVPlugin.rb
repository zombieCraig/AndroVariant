# Base class plugin

require 'VariantData'

class AndroVPlugin
attr_accessor :dex, :dasm

  def initialize(dex, dasm)
    @dex = dex
    @dasm = dasm
  end

  # Loads any config settings and definitions
  def load_config

  end

  # Analyzes the loaded dex file
  def analyze

  end

  # Prints a report
  def report

  end
end
