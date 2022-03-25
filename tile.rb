class Tile 

    attr_reader :flagged, :position, :revealed
    attr_accessor :has_bomb, :neighbors, :value 

    def initialize(row, col)
        @has_bomb = false 
        @surrounding_bombs = 0 
        @flagged = false 
        @revealed = false 
        @value = nil 
        @position = [row, col]
        @neighbors = []
    end 

end 