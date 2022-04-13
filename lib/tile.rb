#require 'colorize'

class Tile
    attr_accessor :value, :bombed, :flagged, :revealed
    attr_reader :board

    def initialize(board)
        @value = "*"
        @board = board
        @bombed = false
        @flagged = false
        @revealed = false
        #@neighbors_List
    end

    def neighbors

    end

    def neighbor_bomb_count
    end

    def reveal 
    end

    def set_mine!
        @bombed = true
    end

    def inspect
        @value 
            #'bombed' => @bombed, 'flagged' => @flagged, 'revealed' => @revealed }
    end 

    def values
        {'bombed' => @bombed, 'flagged' => @flagged, 'revealed' => @revealed }

    end
end