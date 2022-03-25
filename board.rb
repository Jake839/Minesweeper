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

    #method calculates the surrounding bombs for every tile 
    def calculate_surrounding_bombs
        board.each do |row| 
            row.each do |tile| 
                bombs = 0 
                tile.neighbors.each do |neighbor| 
                    tile_neighbor = self[neighbor.first, neighbor.last]
                    bombs += 1 if tile_neighbor.has_bomb
                end 
                tile.surrounding_bombs = bombs
            end 
        end 
    end 

    #method uses syntactic sugar to call a tile in the board 
    def [](row, col)
        board[row][col]
    end 

    def in_valid_range?(num)
        (0..8).include?(num) 
    end 

    #method prints board 
    def render 
        #assign tile values. load minesweeper board in 2D array so it can be drawn by drawgrid method. 
        minesweeper_board = []
        board.each do |row| 
            row_arr = []
            row.each do |tile| 
                if tile.revealed
                    if tile.surrounding_bombs == 0 
                        tile.value = '_'
                    else 
                        tile.value = tile.surrounding_bombs 
                    end 
                else 
                    if tile.flagged
                        tile.value = 'F'
                    else     
                        tile.value = '_'
                    end 
                end 
                row_arr << tile.value 
            end 
            minesweeper_board << row_arr
        end 

        #draw minesweeper board 
        drawgrid(minesweeper_board) 
    end 

    #method renders an ASCII grid based on a 2D array
    def drawgrid(args, boxlen=3)
        #Define box drawing characters
        side = '│'
        topbot = '─'
        tl = ' ┌'
        tr = '┐'
        bl = ' └'
        br = '┘'
        lc = ' ├'
        rc = '┤'
        tc = '┬'
        bc = '┴'
        crs = '┼'
        ##############################
        board_row_idx = 0 
        draw = [] 

        args.each_with_index do |row, rowindex|
            # TOP OF ROW Upper borders
            row.each_with_index do |col, colindex|
                if rowindex == 0
                    colindex == 0 ? start = tl : start = tc
                    draw << start + (topbot*boxlen)
                    colindex == row.length - 1 ? draw << tr : ""
                end
            end
            draw << "\n" if rowindex == 0

            # MIDDLE OF ROW: DATA
            row.each_with_index do |col, index|
                if ((board_row_idx % 9 == 0 && board_row_idx >= 9) || board_row_idx == 0) && index == 0 
                    draw << "#{board_row_idx / 9}" 
                end 
                draw << side + col.to_s.center(boxlen)
                board_row_idx += 1 
            end
            draw << side + "\n"

            # END OF ROW
            row.each_with_index do |col, colindex|
                if colindex == 0
                    rowindex == args.length - 1 ? draw << bl : draw << lc
                    draw << (topbot*boxlen)
                else
                    rowindex == args.length - 1 ? draw << bc : draw << crs
                    draw << (topbot*boxlen)
                end
                endchar = rowindex == args.length - 1 ? br : rc

                #Overhang elimination if the next row is shorter
                if args[rowindex+1]
                    if args[rowindex+1].length < args[rowindex].length
                    endchar = br
                    end
                end
                colindex == row.length - 1 ? draw << endchar : ""
            end

            draw << "\n"
        end

        puts "MINESWEEPER\n".rjust(25)
        (0...9).each { |i| print "   #{i}" } 
        puts "\n"
        draw.each { |char| print "#{char}" } 

        true
    end 

    private 
    attr_reader :board 

end 


