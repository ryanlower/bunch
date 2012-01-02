module Bunch
  class DirectoryNode
    attr_reader :root

    def initialize(fn)
      @root = Pathname.new(fn)
    end

    def filenames
      Dir[@root.join("*")].select { |f| f !~ /_\.yml$/ }
    end

    def children
      @children ||= begin
        children = filenames.map &Bunch.method(:tree_for)
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

    def target_extension
      @target_extension ||= begin
        exts = children.map(&:target_extension).compact.uniq
        if exts.count == 1
          exts.first
        else
          raise "Directory contains non-homogeneous nodes: #{exts.inspect}"
        end
      end
    end

    def content
      @content ||= children.map(&:content).join
    end

    def name
      File.basename(@root)
    end

    def inspect
      "#<DirectoryNode @root=#{@root.inspect} @children=#{children.inspect}>"
    end
  end
end
