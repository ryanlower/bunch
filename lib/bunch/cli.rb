module Bunch
  class CLI
    def initialize(input, output, opts)
      @input   = Pathname.new(input)
      @output  = Pathname.new(output)
      @ext     = opts[:e].sub(/^\./, '')
    end

    def process!
      FileUtils.mkdir_p(@output.to_s)

      Dir[@input.join('*')].each do |fn|
        out = @output.join(fn.sub("#{@input}/", '').sub(/\.#{@ext}$/, '') + ".#{@ext}")
        contents = Bunch.generate(fn)
        File.open(out, 'w') { |f| f.write(contents) }
      end
    end
  end

  class << CLI
    def process!
      opts = Slop.parse! do
        banner 'Usage: bunch [options] INPUT_PATH OUTPUT_PATH'

        on :e, :extension, 'The extension of the output files (required)', :optional => false
        on :h, :help, 'Show this message' do
          display_help = true
        end
      end

      if !opts[:e] || ARGV.count < 2
        print "ERROR: Missing one or more required arguments (note that --extension is required).\n\n"
        display_help = true
      end

      if display_help
        puts opts
        exit
      end

      input  = ARGV.shift
      output = ARGV.shift

      CLI.new(input, output, opts).process!
    end
  end
end
