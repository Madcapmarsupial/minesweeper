#require 'colorize'
require 'byebug'
class Tile
    attr_accessor :value, :bombed, :flagged, :revealed, :pos
    attr_reader :board

    def initialize(board, pos)
        @value = "*"
        @board = board
        @pos = pos
        @bombed = false
        @flagged = false
        @revealed = false
    end

    def inspect
        @value
    end

    def set_mine!
        @bombed = true
    end

    def neighbor_pos_list
        y, x = @pos
        neighbors_list = []
        (y-1..y+1).each do |h|  
            (x-1..x+1).each do |w| 
                if w.between?(0, @board.width-1) && h.between?(0, @board.height-1)
                    neighbors_list << [h, w]  
                end
            end 
        end
        neighbors_list.delete(@pos)
        return neighbors_list
    end

    def set_tiles(list_of_neighbors)
        list_of_neighbors.map! do |coords|
            h, w = coords
            @board[h][w]
        end
    end

    def get_neighbors
        return set_tiles(neighbor_pos_list)
    end

    def neighbor_bomb_count
        return "X" if @revealed && @bombed
        return @value if bombed
        
        bomb_count = 0
        tiles = self.get_neighbors
        tiles.each { |tile| bomb_count += 1 if tile.bombed }

        if bomb_count == 0 
            return  "_"
         else 
            return bomb_count.to_s
        end
    end 

    def reveal  
        return "F" if @flagged 
        return "boom" if @bombed

        @revealed = true 
        @value = neighbor_bomb_count 
        if @value == "_" 
            get_neighbors.each do |tile| 
               if tile.revealed == false && !flagged
                    tile.reveal
               end
            end
        else #if it is adjacent to a bomb
            self.set_value
        end         
    end

    def flag
      if revealed == false
        @flagged = !flagged
        if flagged == true
            @value = "F"
        else
            @value = "*"
        end
      else
        return "already revealed"
      end
    end

    def set_value
        @value = self.neighbor_bomb_count
    end



end