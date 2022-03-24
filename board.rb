require_relative "tile.rb"

class Board 

    #initialize each tile on the board 
    def initialize(board)
        @board = board.map do |row| 
            row.map { |tile| Tile.new }
        end   
    end 
    
end 