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
      Bunch.load_ignores(@input)
      tree = Bunch.tree_for(@input.to_s, @opts)

      if @output
        FileUtils.mkdir_p(@output.to_s)
      end

      if @opts[:all]
        if @output
          tree.write_to_file(@output.join('all'))
        else
          puts tree.content
        end
      end

      if @opts[:individual]
        tree.children.each do |child|
          child.write_to_dir(@output)
        end
      end
    end
  end

  class << CLI
    def process!
      CLI.new(*parse_opts)
    rescue => e
      if ENV['BUNCH_DEBUG']
        raise
      else
        $stderr.puts "ERROR: #{e.message}"
        exit 1
      end
    end

    def parse_opts
      options = {:individual => true}

      opts = OptionParser.new do |opts|
        opts.banner = 'Usage: bunch [options] INPUT_PATH [OUTPUT_PATH]'

        opts.on '-s', '--server', 'Instead of creating files, use WEBrick to serve files from INPUT_PATH.' do
          options[:server] = true
        end

        opts.on '-i', '--[no-]individual', 'Create one output file for each file or directory in the input path (default).' do |i|
          options[:individual] = i
        end

        opts.on '-a', '--all', 'Create an all.[extension] file combining all inputs.' do
          options[:all] = true
        end

        opts.on '-r', '--recurse', 'Recursively generate one output file for every input file and directory.' do
          options[:recurse] = true
        end

        opts.on_tail '-h', '--help', 'Show this message.' do
          puts opts
          exit
        end
      end

      opts.parse!

      if ARGV.count < 1
        raise "Must give an input path.\n\n#{opts}"
      end

      if ARGV.count < 2 && options[:individual] && !options[:server]
        raise "Must give an output path unless --no-individual or --server is provided."
      end

      input  = ARGV.shift
      output = ARGV.shift

      [input, output, options]
    end
  end
end
