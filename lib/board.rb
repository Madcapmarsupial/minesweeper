class Board
    def self.make_empty_grid(height, width, mine_count)
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
        board_size = difficulty.slice(0..1)
        mine_count = difficulty.last
        @grid = Board.make_empty_grid(board_size[0], board_size[1], mine_count)
    end

    def place_bombs

    end
end