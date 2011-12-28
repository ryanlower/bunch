module Bunch
  class CLI
    def initialize(input, output, opts)
      @input  = Pathname.new(input)
      @output = output ? Pathname.new(output) : nil
      @opts   = opts

      if @opts[:server]
        run_server
      else
        generate_files
      end
    end

    def run_server
      require 'rack'
      ::Rack::Handler::WEBrick.run(Bunch::Rack.new(@input), :Port => 3001)
    rescue LoadError
      $stderr.puts "ERROR: 'gem install rack' to run Bunch in server mode."
      exit 1
    end

    def generate_files
      tree = Bunch::Tree(@input.to_s)

      if @output
        FileUtils.mkdir_p(@output.to_s)
      end

      if @opts[:all]
        if @output
          write(@output.join("all.#{tree.target_extension}"), tree.contents)
        else
          puts tree.contents
        end
      end

      if @opts[:individual]
        tree.children.each do |child|
          write(@output.join("#{child.name}.#{child.target_extension}"), child.contents)
        end
      end
    end

    private
      def write(fn, contents)
        File.open(fn, 'w') { |f| f.write(contents) }
      end
  end

  class << CLI
    def process!
      opts = Slop.parse! do
        banner 'Usage: bunch [options] INPUT_PATH [OUTPUT_PATH]'

        on :s, :server, 'Instead of creating files, use WEBrick to serve files from INPUT_PATH'
        on :i, :individual, 'Create one output file for each file or directory in the input path (default)', :default => true
        on :a, :all, 'Create an all.[extension] file combining all inputs'
        on :h, :help, 'Show this message' do
          display_help = true
        end
      end

      if ARGV.count < 1
        $stderr.puts "ERROR: Must give an input path."
        display_help = true
      end

      if ARGV.count < 2 && opts[:individual] && !opts[:server]
        $stderr.puts "ERROR: Must give an output path unless --no-individual or --server is provided."
        display_help = true
      end

      if display_help
        $stderr.puts "\n#{opts}"
        exit
      end

      input  = ARGV.shift
      output = ARGV.shift

      CLI.new(input, output, opts)
    rescue Exception => e
      if ENV['BUNCH_DEBUG']
        raise
      else
        $stderr.puts "ERROR: #{e.message}"
      end
    end
  end
end
