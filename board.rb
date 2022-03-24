require_relative "tile.rb"

class Board 

    #initialize each tile on the board 
    def initialize(board)
        row_idx = -1  
        @board = board.map do |row| 
            row_idx += 1 
            col_idx = -1  
            row.map do |tile| 
                col_idx += 1 
                Tile.new(row_idx, col_idx)
            end 
        end   
    end 
    
end 