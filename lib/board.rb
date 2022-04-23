require_relative 'tile.rb'

class Board
    attr_reader :height, :width, :mine_count, :grid

    def self.make_empty_grid(height, width)
        grid = Array.new(height) { Array.new(width) }
    end

    def initialize(difficulty)
        @height = difficulty[0]
        @width = difficulty[1]
        @mine_count = difficulty.last
        @grid = Board.make_empty_grid(height, width)
        self.fill_grid
        self.seed_mines
    end
    
    def [](index)
        @grid[index]
    end
   
    def []=(index, value)
        @grid[index] = value
    end

    def fill_grid
        @grid.each_with_index do |row, i|
            row.each_with_index do |ele, j|
                @grid[i][j]= Tile.new(self, [i, j])
            end
        end
        "done"
    end

    def seed_mines
        placed_positions = []
        mines_placed = 0

        until @mine_count == mines_placed
            h = rand(height)
            w = rand(width)

            if placed_positions.include?([h, w])
                next
            else 
                @grid[h][w].set_mine!
                placed_positions << [h, w] 
                mines_placed += 1
            end
        end
        "mines set!"
    end

end

