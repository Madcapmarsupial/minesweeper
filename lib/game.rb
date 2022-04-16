require_relative 'board.rb'
require "byebug"

class Game
    attr_reader :board

    def initialize(board)
        @board = board
        @blow_up = false
    end
    
    def render 
        print "\n"
        board.grid.each { |row| p row }
    end

    def win?
        tiles = []
        board.grid.each do |rows| 
            tiles += rows.select { |tile| !tile.bombed }
        end

        return tiles.all? { |tile| tile.revealed }
    end
    

    def prompt_for_input
        print "\n SELECT A TILE\n input two numbers seperated by a comma ->  '2,3'
        the first between 0 and #{board.height-1} 
        the second between 0 and #{board.width-1}\n"
    end

    def get_input
        prompt_for_input
        print "---->  "
        input = gets.chomp.split(",")
        input.map!(&:to_i)
        h, w = input
        pass_conditions = (
            input.length == 2 && 
            (h < board.height && w < board.width) && 
            input.all? {|num| num.is_a?(Integer)}
            )
        until pass_conditions
            print "INPUT ERROR.  your input was #{input}"
            prompt_for_input
            return get_input
        end
        return input
    end


    def prompt_for_action
        print "\nPICK AN ACTION
        'f' to Flag the tile (or unflag if already flagged)
        'r' to Reveal it.
        'back' to select a new tile.\n"
    end

    def get_action
        valid_actions = ['r', 'f', 'back']
        print "---->  "
        action = gets.chomp
        if valid_actions.include?(action)
            return action
        end
        p "try again, valid actions are #{valid_actions}"
        prompt_for_action
        return get_action
    end
    
    def execute(input, action)
        h, w = input
        case action
        when "r"
            board[h][w].reveal
            flag_msg = "\nthis tile is flagged. to reveal it. the tile must be unflagged first\n" 
            print flag_msg if board[h][w].value == "F"
            @blow_up = true if board[h][w].bombed
        when "f"
            board[h][w].flag
            reveal_msg = "\nthis tile is already revealed.\n"
            print reveal_msg if board[h][w].revealed
        when "back"
            return nil
        else 
            raise "Something went wrong. is your input -> '#{input}' and action -> '#{action}' in the correct format?"
        end
    end

    def game_over?
        if @blow_up
            print "\n
            BOOM!  
            Game Over\n"
            return true
        elsif win?
            print "\nYOU WIN!\n"
            return true
        end

        return false
    end

    def run
        render
        until game_over?
            input = get_input
            print "\n selected tile #{input} \n"
            prompt_for_action
            action = get_action
            #debugger
            execute(input, action)
            render
        end
    end
    
end


if  __FILE__ == $PROGRAM_NAME
    b = Board.new("test")
    g = Game.new(b)
    g.run
end