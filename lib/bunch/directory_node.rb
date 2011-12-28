module Bunch
  class DirectoryNode
    attr_reader :root, :children

    def initialize(fn)
      @root = Pathname.new(fn)
      @filenames = Dir[@root.join("*")].select { |f| f !~ /_\.yml$/ }
      reorder_files
      @children = @filenames.map &Bunch.method(:Tree)
    end

    def contents
      @children.map(&:contents).join
    end

    def inspect
      "#<Node @root=#{@root.inspect} @children=#{@children.inspect}>"
    end

    private
      def reorder_files
        ordering_file = @root.join("_.yml")

        if File.exist?(ordering_file)
          ordering = YAML.load_file(ordering_file)
          files_without_ordering = []

          ordered_files = @filenames.sort_by do |fn|
            name = File.basename(fn)
            ordering.index { |o| name.start_with?(o) } ||
              (files_without_ordering << fn; 999)
          end - files_without_ordering

          @filenames = ordered_files + files_without_ordering.sort
        else
          @filenames.sort!
        end
      end
  end
end
