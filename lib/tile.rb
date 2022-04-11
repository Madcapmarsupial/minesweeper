#require 'colorize'

class Tile
    def initialize(bombed, board)
        @board = board
        @bombed = bombed
        @flagged = false
        @revealed = false
    end

    def neighbors

    end

    def neighbor_bomb_count
    end

    def reveal 
    end

    def inspect
        #custom field
    end

end