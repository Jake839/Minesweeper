require_relative "board.rb"

class Minesweeper 

    #initialize a 2D array of a 9 x 9 minesweeper board 
    def initialize
        @game = Board.new(Array.new(9) { Array.new(9) })
    end 

    def run 
        game.get_neighbors
    end 

    attr_reader :game 

end 

game = Minesweeper.new

