require_relative "board.rb"

class Minesweeper 

    attr_reader :game, :player 

    #initialize a 2D array of a 9 x 9 minesweeper board 
    def initialize
        introduction 
        @game = Board.new(Array.new(9) { Array.new(9) })
        print "\nEnter your name: "
        user_name = gets.chomp 
        @player = user_name
    end 

    def introduction 
        puts "Welcome to Minesweeper!"
        puts "You win the game when you reveal all tiles that don't have a bomb."
        puts "You lose if you hit a bomb." 
        puts "Numbers on the board show the number of adjacent bombs."
        puts "To reveal a tile, enter r and then the tile's coordinates. For ex., to reveal tile 0,0 you'd enter r0,0"
        puts "If you think a tile has a bomb, then you can flag it. For ex., to flag tile 0,0 you'd enter f0,0"
        puts "To reveal a flagged tile, you must unflag it. For ex., to unflag tile 0,0 you'd enter u0,0"
        puts "To recap, enter r to reveal, f to flag, or u to unflag and then enter the tile's coordinates. Coordinates must be entered with a comma between them as shown in the above examples."
        puts "Good Luck!"
    end 

    def run 
        game.get_neighbors
        game.set_bombs 
        game.calculate_surrounding_bombs 
        game.render 
        until game.over? 
            valid_reveal = false 
            while !valid_reveal
                player_entry = get_entry 
                position = game.get_player_entry_position(player_entry)
                if game[position.first, position.last].flagged && player_entry[0] != 'u'
                    system("clear")
                    game.render 
                    puts "Tile #{position.first},#{position.last} is flagged. To unflag this tile, enter u#{position.first},#{position.last}"
                elsif game[position.first, position.last].revealed
                    system("clear")
                    game.render 
                    puts "Tile #{position.first},#{position.last} is already revealed. Choose a tile that hasn't been revealed."
                else 
                    valid_reveal = true 
                end 
            end 
            game.update_tile(player_entry)
            system("clear")
            game.render 
            #reveal appropriate tiles 
        end 

        if game.won? 
            puts "Congratulations! You beat Minesweeper!"
        else 
            game.reveal_all_bombs 
            system("clear")
            game.render 
            puts "You hit a bomb. You lose. Game over."
        end 
    end 

    def get_entry
        valid_entry = false 
        while !valid_entry
            print "#{player}, make an entry: "
            user_entry = gets.chomp 
            if valid_user_entry?(user_entry) 
                valid_entry = true 
            else 
                system("clear")
                game.render 
                puts "Invalid entry. Please make a valid entry."
                puts "Example to reveal tile 0,0: r0,0"
                puts "Example to flag tile 0,0: f0,0"
                puts "Example to unflag tile 0,0: u0,0"
            end 
        end 
        user_entry
    end 

    def valid_user_entry?(user_entry)
        user_entry.downcase! 
        return false if user_entry[0] != 'r' && user_entry[0] != 'f' && user_entry[0] != 'u'
        user_entry = user_entry[1..-1]
        return false if !user_entry.include?(',')
        arr = user_entry.split(',')
        return false if arr.any? { |char| char.length != 1 } 
        if arr.all? { |char| char.ord >= 48 && char.ord <= 56 }
            true 
        else 
            false 
        end 
    end 

end 

