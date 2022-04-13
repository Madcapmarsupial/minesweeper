require_relative 'tile.rb'

class Board
    attr_reader :height, :width, :mine_count

    def self.make_empty_grid(height, width)
        grid = Array.new(height) { Array.new(width) }
    end

    def [](index)
        @grid[index]
    end
   
    def []=(index, value)
        @grid[index] = value
    end

    def initialize(level)
        difficulties = { 
            "beginner" => [9, 9, 10], 
            "intermediate" => [16, 16, 10],
            "expert" => [16, 30, 99] 
        }
        difficulty = difficulties[level]
        @height = difficulty[0]
        @width = difficulty[1]
        @mine_count = difficulty.last
        @grid = Board.make_empty_grid(height, width)
    end

    def fill_grid
        @grid.map! do |row|
            row.map! do |ele|
                ele = Tile.new(self)
            end
        end
        "done"
    end

    def seed_mines
        coords = []

        (0...mine_count).each do |i|
            h = rand(height - 1)
            w = rand(width - 1)

            if coords.include?([h, w])
                i -= 1
            else 
                coords << [h, w] 
                @grid[h][w].set_mine!
            end
        end
        p coords
        "mines set!"
    end

    
end