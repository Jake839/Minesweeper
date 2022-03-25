require_relative "board.rb"
require_relative "player.rb"

class Minesweeper 

    attr_reader :game, :player 

    #initialize a 2D array of a 9 x 9 minesweeper board 
    def initialize
        introduction 
        @game = Board.new(Array.new(9) { Array.new(9) })
        print "\nEnter your name: "
        user_name = gets.chomp 
        @player = Player.new(user_name)
    end 

    def introduction 
        puts "Welcome to Minesweeper!"
        puts "You win the game when you reveal all tiles that don't have a bomb."
        puts "You lose if you hit a bomb." 
        puts "Numbers on the board show the number of adjacent bombs."
        puts "To reveal a tile, enter r and then the tile's coordinates. For ex., to reveal tile 0,0 you'd enter r0,0"
        puts "If you think a tile has a bomb, then you can flag it. For ex., to flag tile 0,0 you'd enter f0,0"
        puts "To recap, enter r to reveal or f to flag and then enter the tile's coordinates. Coordinates must be entered with a comma between them as shown in the above examples."
        puts "Good Luck!"
    end 

    def run 
        game.get_neighbors
        game.set_bombs 
        game.calculate_surrounding_bombs 
        #until game.over? 
            game.render 
            player_entry = player.get_entry 
            game.update_tile(player_entry)
            #update tile 
            #reveal appropriate tiles 
            #clear 
        #end 

        # game.render 
        # if game.won? 
        #     puts "Congratulations! You beat Minesweeper!"
        # else 
        #     #make code so all bombs are shown 
        #     puts "You hit a bomb. You lose. Game over."
        # end 
    end 

end 

