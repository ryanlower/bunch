module Bunch
  class Node
    attr_reader :root, :children

    def initialize(fn)
      @root = fn

      filenames = Dir["#{fn}/*"].select do |f|
        f =~ /\.#{Bunch.extension}$/ || File.directory?(f)
      end

      if File.exist?("#{fn}/_.yml")
        filenames = order_files("#{fn}/_.yml", filenames)
      end

      @children = filenames.map &Bunch.method(:tree_for)
    end

    def contents
      @children.map(&:contents).join
    end

    def inspect
      "#<Node @root=#{@root.inspect} @children=#{@children.inspect}>"
    end

    private
      def order_files(path, filenames)
        ordering = YAML.load_file(path)
        filenames.sort_by do |fn|
          ordering.index(File.basename(fn, ".#{Bunch.extension}")) || 999
        end
      end
  end
end
