require_relative 'board.rb'
require 'yaml'
require 'colorize'
require "remedy"

class Game
    attr_reader :board

    def self.get_custom_level
        print "\n input the... height, width, and number of mines. \n all larger than 0 and seperated by commas -> '4,4,2'\n --> "
        inputs = gets.chomp!.split(",")
        inputs.map!(&:to_i)
        pass_test = (
            inputs.length == 3 &&
            inputs.all? { |ele| ele.is_a?(Integer) && ele > 0 }
        )

        until pass_test
            print "\n error. your input was --> (#{inputs})... try again\n".red
            return Game.get_custom_level
        end

        return inputs
    end

    def self.new_game
        levels = { 
            "test" => [4,4, 2],
            "beginner" => [9, 9, 10], 
            "intermediate" => [16, 16, 10],
            "expert" => [16, 30, 99], 
            "custom" => "custom"
        }.freeze
      
        print"\n type in a difficulty level:\n beginner, intermediate, expert, or custom.\n ---> " 
        level = gets.chomp
        pass = levels.has_key?(level)
        until pass
            print "\n error your input was (#{level})\n".red
            return Game.new_game
        end
        
        return Game.get_custom_level if level == "custom" 
        return levels[level]
    end
  
    def self.load_game(file_name)
        saved_game = File.read("saved_games/#{file_name}")
        YAML::load(saved_game)
    end

    def initialize
        level = Game.new_game
        @board = Board.new(level)
        @blow_up = false
    end
    
    def reveal_mines 
        board.grid.each { |rows| rows.each { |tile| tile.value = "X" if tile.bombed } }
    end

    def render(pos) 
        pos = wrap(pos)
        print "\n".ljust(3).on_white
        board.grid.each_with_index do |row, i| 
            row.each_with_index do |tile, j|
                if pos == [i, j]
                    print tile.value.ljust(3).yellow.on_light_blue
                    next
                end
                val = tile.value
                case val
                when "F"
                    print val.ljust(3).black.on_red
                when "*"
                    print val.ljust(3).black.on_white
                when "_"
                    print val.ljust(3).light_white.on_white
                when "1".."2"
                    print val.ljust(3).green.on_white
                when "3".."5"
                    print val.ljust(3).red.on_white
                when "6".."8"
                    print val.ljust(3).blue.on_white
                when "X"
                    print val.ljust(3).red.on_black
                end
            end
            print "\n".ljust(3).on_white
        end
    end
    
    def wrap(input)
        #input should be a 2d array of the form [height, width]
        h = (input.first % board.grid.length)
        w = (input.last % board.grid[0].length)
        return [h, w]
    end

    def execute(input, action)
        h, w = wrap(input)
        tile = board[h][w]
        case action
        when "r"
            if tile.value == "F"
                flag_msg = "\nthis tile is flagged. to reveal it the tile must be unflagged first\n" 
                print flag_msg.blue
                sleep(2)
            else
                tile.reveal 
                @blow_up = true if tile.bombed
            end
        when "f"
            tile.flag
            if tile.revealed
                print "\nthis tile is already revealed.\n".blue
                sleep(2)
            end
        end
    end

    def win?
        tiles = []
        board.grid.each do |rows| 
            tiles += rows.select { |tile| !tile.bombed }
        end
        return tiles.all? { |tile| tile.revealed }
    end
    
    def game_over?
        if @blow_up
            print "\n
            BOOM!  
            Game Over\n".red
            return true
        elsif win?
            print "\nYOU WIN!\n".green
            return true
        end

        return false
    end

    def save_game
        print "\n please input the name of your game\n --->"
        file_name = (gets.chomp + ".txt")
        game_data = self.to_yaml

        File.open("saved_games/#{file_name}", "w+") { |f| f.write(game_data) }
    end
    
    include Remedy
    def run
        system('clear')
        user_input = Interaction.new
        h = (board.grid.length / 2)
        w = (board.grid[0].length / 2)
        render([h,w])
        user_input.loop do |key|
            case key.to_s
            when "up"
                 h -= 1
            when "down"
                 h += 1
            when "left"
                 w -= 1
            when "right"
                 w += 1
            when "space"
                self.execute([h, w], "r")
            when "control_s"
                self.save_game
            when "f"
                self.execute([h, w], "f")
            end
            system('clear')
            reveal_mines if @blow_up
            render([h, w])
            break if game_over?
        end
    end

end


if  __FILE__ == $PROGRAM_NAME
    system('clear')
    print "WELCOME TO MINESWEEPER!"

    case ARGV.length
    when 0
        g = Game.new
        g.run
    when 1 
        game_file = ARGV.shift
        Game.load_game(game_file).run
    end 
end
