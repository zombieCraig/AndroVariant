# Base class plugin

class AndroVPlugin
attr_accessor :dex

  def initialize(dex)
    @dex = dex
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
