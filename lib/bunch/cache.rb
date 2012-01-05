module Bunch
  module Cache
  end

  class << Cache
    def initialize
      @cache = Hash.new { |h, k| h[k] = {} }
    end

    def stored?(fn)
      @cache.keys.include?(fn)
    end

    def read(fn)
      @cache[fn][:content]
    end

    def mtime(fn)
      @cache[fn][:mtime]
    end

    def write(fn, mtime, content)
      @cache[fn] = {:mtime => mtime, :content => content}
    end

    def fetch(fn, &blk)
      current_mtime = File.mtime(fn)

      if stored?(fn) && mtime(fn) == current_mtime
        read(fn)
      else
        content = blk.call
        write(fn, current_mtime, content)
        content
      end
    end
  end

  Cache.initialize
end
