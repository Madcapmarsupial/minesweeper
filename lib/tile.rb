#require 'colorize'

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

    def get_list
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

    def neighbor_tiles(list_of_neighbors)
        list_of_neighbors.map! do |coords|
            h, w = coords
            @board[h][w]
        end
    end

    
    def reveal 
       @value = self.neighbor_bomb_count
    end

    def neighbor_bomb_count
        return "X" if bombed

        list = self.get_list
        neighbors = neighbor_tiles(list)
        bomb_count = 0
        neighbors.each { |neighbor| bomb_count += 1 if neighbor.bombed }

        if bomb_count == 0 
            return  "_"
        else 
            p bomb_count
            return bomb_count.to_s
        end
    end 

    def inspect
        @value
    end

    def set_mine!
        @bombed = true
    end

end