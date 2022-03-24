class Tile 

    attr_reader :position
    attr_accessor :neighbors

    def initialize(row, col)
        @has_bomb = false 
        @surrounding_bombs = 0 
        @flagged = false 
        @revealed = false 
        @position = [row, col]
        @neighbors = []
    end 
    
end 