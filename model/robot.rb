class Robot
  require_relative 'orientation'

  attr_accessor :position, :facing, :setted

  FACES = {
    NORTH: Orientation::North.instance,
    SOUTH: Orientation::South.instance,
    WEST: Orientation::West.instance,
    EAST: Orientation::East.instance
}.freeze

  def initialize
    @setted = false
  end

  def place(x,y,facing)
    raise_orientation_error unless FACES.keys.include?(facing.to_sym)
    return unless into_the_board?(x.to_i,y.to_i)

    @position = [x.to_i,y.to_i] 
    @facing = FACES[facing.to_sym]
    @setted = true
  end

  def left
    @facing = facing.left if @facing
  end

  def right
    @facing = facing.right if @facing
  end

  def move
    case @facing
    when Orientation::North.instance
      position[0] += 1 if can_move?('north')
    when Orientation::South.instance
      position[0] -= 1 if can_move?('south')
    when Orientation::East.instance
      position[1] += 1 if can_move?('east')
    when Orientation::West.instance
      position[1] -= 1 if can_move?('west')
    end 
  end

  def report
    return '' unless setted
    "Output: #{position[0]},#{position[1]},#{facing.to_s}"
  end

  def into_the_board?(x,y)
    x.to_i.between?(0,ENV['TABLEBOARD_X'].to_i) && y.to_i.between?(0,ENV['TABLEBOARD_Y'].to_i)
  end

  def can_move?(dir)
    return false unless setted

    case dir
    when 'north'
      ENV['TABLEBOARD_X'].to_i >= position[0]+1
    when 'south'
      position[0]-1 >= 0
    when 'east'
      ENV['TABLEBOARD_Y'].to_i >= position[1]+1
    when 'west'
      position[1]-1 >= 0
    end
  end

  private 

  def raise_orientation_error
    raise Orientation::OrientationError.new
  end
end