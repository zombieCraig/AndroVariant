require 'optparse'

class AndroVOptions
attr_reader :options, :opts, :optparse

  def initialize
    @options = {}

    optparse = OptionParser.new do |opts|
      opts.banner = "Usage androv [options] file.apk"

      @options[:verbose] = false
      @options[:plugins] = []

      opts.on('-v', '--verbose', 'Verbose') do
        @options[:verbose] = true
      end

      opts.on('-p', '--plugin FILE', 'Plugin files') do |plugin|
        @options[:plugins] << plugin
      end

      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end

    optparse.parse!
  end

end
