class Tile 

    def initialize(row, col)
        @has_bomb = false 
        @flagged = false 
        @revealed = false 
        @position = [row, col]
    end 

end 