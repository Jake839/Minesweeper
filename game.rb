require_relative "board.rb"
require 'yaml'
require 'Remedy'
require 'byebug'

class Minesweeper 

    attr_reader :game, :player, :saved 

    #initialize a 2D array of a 9 x 9 minesweeper board 
    def initialize
        introduction 
        print "\nEnter your name: "
        user_name = gets.chomp 
        @player = user_name
        @saved = false 
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
        puts "You can also save your game by entering s."
        puts "Good Luck!"
    end 

    def set_board
        @game = Board.new(Array.new(9) { Array.new(9) })
        game.get_neighbors
        game.set_bombs 
        game.calculate_surrounding_bombs 
    end 

    def run 
        if File.file?('saved_game.yml')
            prompt_for_saved_game
        else 
            set_board
        end 
       
        until game.over? || saved 
            print_board
            player_entry = get_valid_player_entry
            if is_entry_s?(player_entry)
                save 
            else 
                game.update_tile(player_entry)
            end 
        end 

        finish_game
    end 

    def get_valid_player_entry 
        valid_reveal = false 
        while !valid_reveal
            player_entry = get_entry 
            if is_entry_s?(player_entry)
                valid_reveal = true 
            else 
                position = game.get_player_entry_position(player_entry)
                if game[position.first, position.last].flagged && player_entry[0] != 'u'
                    print_board 
                    puts "Tile #{position.first},#{position.last} is flagged. To unflag this tile, enter u#{position.first},#{position.last}"
                elsif game[position.first, position.last].revealed
                    print_board
                    puts "Tile #{position.first},#{position.last} is already revealed. Choose a tile that hasn't been revealed."
                else 
                    valid_reveal = true 
                end 
            end 
        end 
        player_entry
    end 

    def finish_game 
        if saved       
            puts "Game saved."
        elsif game.won? 
            print_board
            puts "Congratulations! You beat Minesweeper!"
        else 
            game.reveal_all_bombs 
            print_board
            puts "You hit a bomb. You lose. Game over."
        end 
    end 

    def print_board 
        system("clear")
        game.render 
    end 

    def is_entry_s?(entry)
        entry == 's'
    end 

    def get_entry
        valid_entry = false 
        while !valid_entry
            puts "#{player}, make an entry or enter s to save game."
            print "Entry: "
            user_entry = gets.chomp.downcase  
            if valid_user_entry?(user_entry) 
                valid_entry = true 
            else 
                print_board
                puts "Invalid entry. Please make a valid entry."
                puts "Example to reveal tile 0,0: r0,0"
                puts "Example to flag tile 0,0: f0,0"
                puts "Example to unflag tile 0,0: u0,0"
            end 
        end 
        user_entry
    end 

    def valid_user_entry?(user_entry)
        return true if is_entry_s?(user_entry)
        return false if user_entry[0] != 'r' && user_entry[0] != 'f' && user_entry[0] != 'u'
        user_entry = user_entry[1..-1]
        return false if !user_entry.include?(',')
        pos_arr = user_entry.split(',')
        return false if pos_arr.any? { |char| char.length != 1 } 
        if pos_arr.all? { |char| char.ord >= 48 && char.ord <= 56 }
            true 
        else 
            false 
        end 
    end 

    def save 
        File.open("saved_game.yml", "w") { |file| file.write(game.to_yaml)}
        @saved = true
    end 

    def prompt_for_saved_game
        puts "Do you want to continue your saved game? Enter y for yes or any other key for no."
        user_choice = gets.chomp.downcase 
        if user_choice == 'y'
            @game = Psych.unsafe_load(File.read("saved_game.yml"))
            @saved = false 
        else   
            set_board 
        end 
    end 

end 

