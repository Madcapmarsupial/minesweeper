require_relative 'tile.rb'

class Board
    attr_reader :height, :width, :mine_count

    def self.make_empty_grid(height, width)
        grid = Array.new(height) { Array.new(width) }
    end

    def initialize(level)
        difficulties = { 
            "test" => [3,3, 2],
            "beginner" => [9, 9, 10], 
            "intermediate" => [16, 16, 10],
            "expert" => [16, 30, 99] 
        }
        difficulty = difficulties[level]
        @height = difficulty[0]
        @width = difficulty[1]
        @mine_count = difficulty.last
        @grid = Board.make_empty_grid(height, width)
        self.fill_grid
        p self.seed_mines
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
        coords = []
        #(0...mine_count).each do |i|
        mines_placed = 0
        until @mine_count == mines_placed
            h = rand(height)
            w = rand(width)

            if coords.include?([h, w])
                next
            else 
                @grid[h][w].set_mine!
                coords << [h, w] 
                mines_placed += 1
            end
        end
        p coords
        "mines set!"
    end

end

if  __FILE__ == $PROGRAM_NAME
     b = Board.new("beginner")
     b.fill_grid
     b.seed_mines
end
