module Bunch
  class NullNode < FileNode
    def content
      ''
    end

    def target_extension
      nil
    end
  end
end
