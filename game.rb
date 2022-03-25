require_relative "board.rb"

class Minesweeper 

    #initialize a 2D array of a 9 x 9 minesweeper board 
    def initialize
        @game = Board.new(Array.new(9) { Array.new(9) })
    end 

    def run 
        game.get_neighbors
        game.set_bombs 
        until game.won? 
            game.calculate_surrounding_bombs 
            game.render 
            
        end 
    end 

    private 
    attr_reader :game 

end 

game = Minesweeper.new

