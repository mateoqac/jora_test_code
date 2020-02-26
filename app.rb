#!/usr/bin/ruby
class App
  require_relative 'model/robot'
  require_relative 'model/orientation'
  
  @@robot = Robot.new
  
  def self.setted?
    @@robot.setted
  end

  def self.report
    @@robot.report
  end 

  def self.left
    @@robot.left
  end

  def self.right
    @@robot.right
  end

  def self.move
    @@robot.move
  end

  def self.place(x,y,face)
    begin
      @@robot.place(x.to_i, y.to_i, face.upcase)
    rescue Orientation::OrientationError => e
      puts e.message
    end
  end

  def self.not_settled_message
    puts 'Robot has not been settled. Use PLACE command for that.'
  end
end

loop do
  input = gets.chomp
  command, *params = input.split /\s/
  x,y,face = params.first.split(/\s*,\s*/) unless params.first.nil?
  if command == 'PLACE'
    App.place(x,y,face)
  elsif App.setted?
    case command
      when 'LEFT'
        App.left
      when 'RIGHT'
        App.right
      when 'MOVE'
        App.move
      when 'REPORT'
        puts App.report
      else
        puts 'Invalid command'
    end
  else
    App.not_settled_message
  end
end