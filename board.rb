require_relative "tile.rb"
require "byebug"

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

    def get_neighbors 
        board.each do |row| 
            row.each do |tile| 
                tile_row = tile.position[0] 
                tile_col = tile.position[1] 

                #get neighbors above tile 
                row_above_tile = tile_row - 1 
                col_above_tile = tile_col - 1 
                3.times do 
                    tile.neighbors << [row_above_tile, col_above_tile] if in_valid_range?(row_above_tile) && in_valid_range?(col_above_tile)
                    col_above_tile += 1 
                end 

                #get neighbors beside tile 
                row_beside_tile = tile_row 
                col_beside_tile = tile_col - 1 
                2.times do 
                    tile.neighbors << [row_beside_tile, col_beside_tile] if in_valid_range?(row_beside_tile) && in_valid_range?(col_beside_tile)
                    col_beside_tile += 2 
                end 

                #get neighbors below tile 
                row_below_tile = tile_row + 1 
                col_below_tile = tile_col - 1 
                3.times do 
                    tile.neighbors << [row_below_tile, col_below_tile] if in_valid_range?(row_below_tile) && in_valid_range?(col_below_tile) 
                    col_below_tile += 1 
                end 
            end 
        end 
    end 

    def get_all_positions
        all_positions = []
        board.each do |row| 
            row.each { |tile| all_positions << tile.position } 
        end 
        all_positions
    end 

    def set_bombs
        all_positions = get_all_positions 
        bomb_ct = 0 
        until bomb_ct == 10 
            selected_position = all_positions.sample 
            if self[selected_position.first, selected_position.last].has_bomb == false 
                self[selected_position.first, selected_position.last].has_bomb = true 
                bomb_ct += 1 
            end 
        end 
    end 

    def [](row, col)
        board[row][col]
    end 

    def in_valid_range?(num)
        (0..8).include?(num) 
    end 

    private 
    attr_reader :board 

end 