require_relative 'board.rb'

class Game
    def initialize(board)
        @board = board
    end
    


    def render 
        #loop through and show each tiles curent value
        (0..@board.height).each { |i| p @board[i] }
    end
    
    def run
        over = false
        until over
        self.render
        pos = gets.chomp.split(",")
        pos.map!(&:to_i)
        result = @board[pos.first][pos.last].reveal
        over = true if result == "boom"
        end
        
    end
    
end


if  __FILE__ == $PROGRAM_NAME
    b = Board.new("beginner")
    g = Game.new(b)
    g.run
end
