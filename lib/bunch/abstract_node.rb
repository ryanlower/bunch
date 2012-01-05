module Bunch
  class AbstractNode
    def content
      raise NotImplementedError
    end
    alias name content
    alias target_extension content

    def write_to_dir(dir)
      write_to_file(File.join(dir, name))
    end

    def write_to_file(fn)
      out_file = "#{fn}#{target_extension}"
      File.open(out_file, 'w') { |f| f.write(content) }
    end

    protected
      def fetch(fn, &blk)
        Cache.fetch(fn, &blk)
      end
  end
end
