module Orientation

require 'singleton'

  class North
    include Singleton

    def to_s
      "NORTH"
    end

    def left
      West.instance
    end

    def right
      East.instance
    end
  end

  class East
    def to_s
      "EAST"
    end

    include Singleton
    def left
      North.instance
    end

    def right
      South.instance
    end
  end

  class South

    def to_s
      "SOUTH"
    end

    include Singleton
    
    def left
      East.instance
    end

    def right
      West.instance
    end
  end

  class West
    include Singleton
    
    def to_s
      "WEST"
    end 

    def left
      South.instance
    end

    def right
      North.instance
    end
  end
  
  class OrientationError < StandardError
    attr_accessor :message 
    def initialize
      @message = 'The orientation value needs to be NORTH, EAST, SOUTH or WEST'
    end
  end
end