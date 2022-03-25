require_relative "board.rb"

class Minesweeper 

    attr_reader :game 

    #initialize a 2D array of a 9 x 9 minesweeper board 
    def initialize
        @game = Board.new(Array.new(9) { Array.new(9) })
        #@player = Player.new
    end 

    def run 
        game.get_neighbors
        game.set_bombs 
        game.calculate_surrounding_bombs 
        #until game.over? 
            game.render 
            
        #end 

        if game.won? 
            puts "Congratulations! You beat Minesweeper!"
        else 
            puts "You hit a bomb. You lose. Game over."
        end 
    end 

end 

game = Minesweeper.new

