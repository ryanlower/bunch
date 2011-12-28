module Bunch
  class DirectoryNode
    attr_reader :root, :children

    def initialize(fn)
      @root = Pathname.new(fn)
    end

    def filenames
      @filenames ||= Dir[@root.join("*")].select { |f| f !~ /_\.yml$/ }
    end

    def children
      @children ||= begin
        children = filenames.map &Bunch.method(:Tree)
        ordering_file = @root.join('_.yml')

        if File.exist?(ordering_file)
          ordering = YAML.load_file(ordering_file)
          ordered, unordered = children.partition { |c| ordering.include?(c.name) }
          ordered.sort_by { |c| ordering.index(c.name) } + unordered.sort_by(&:name)
        else
          children.sort_by(&:name)
        end
      end
    end

    def contents
      children.map(&:contents).join
    end

    def name
      File.basename(@root)
    end

    def inspect
      "#<Node @root=#{@root.inspect} @children=#{@children.inspect}>"
    end
  end
end
