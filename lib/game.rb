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
            print "\n input error (#{inputs}), try again\n"
            return Game.get_custom_level
        end

        return inputs
    end

    def self.start_up
        levels = { 
            "test" => [4,4, 2],
            "beginner" => [9, 9, 10], 
            "intermediate" => [16, 16, 10],
            "expert" => [16, 30, 99], 
            "custom" => "custom"
        }.freeze
      
        print"\n type in a difficulty level: beginner, intermediate, expert, or custom\n ---> " 
        level = gets.chomp
        pass = levels.has_key?(level)
        until pass
            print "\n error your input was (#{level})\n"
            return Game.start_up
        end
        
        return Game.get_custom_level if level == "custom" 
        return levels[level]


    end
  
    def self.load_game(file_name)
        saved_game = File.read("saved_games/#{file_name}")
        YAML::load(saved_game)
    end

    def initialize
        level = Game.start_up
        @board = Board.new(level)
        @blow_up = false
    end
    
    def render(pos) 
        print "\n".ljust(3).on_white

        board.grid.each_with_index do |row, i| 

            row.each_with_index do |tile, j|
                if pos == [i, j]
                    print tile.value.ljust(3).yellow.on_blue
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
                    print val.ljust(3).black.on_red
                end
            end
            print "\n".ljust(3).on_white
        end
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
        'back' to select a new tile.
        'save' to save your game.\n"
    end

    def get_action
        valid_actions = ['r', 'f', 'back', 'save']
        print "---->  "
        action = gets.chomp
        if valid_actions.include?(action)
            return action
        end
        p "try again, valid actions are" + "#{valid_actions}".red
        prompt_for_action
        return get_action
    end
    
    def execute(input, action)
        h, w = input
        case action
        when "r"
            board[h][w].reveal
            flag_msg = "\nthis tile is flagged. to reveal it. the tile must be unflagged first\n" 
            print flag_msg.red if board[h][w].value == "F"
            @blow_up = true if board[h][w].bombed
        when "f"
            board[h][w].flag
            reveal_msg = "\nthis tile is already revealed.\n"
            print reveal_msg.blue if board[h][w].revealed
        when "back"
            return nil
        when "save"
            self.save_game
        else 
            raise "Something went wrong. is your input -> '#{input}' and action -> '#{action}' in the correct format?"
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
            board.grid.each { |rows| rows.each { |tile| tile.value = "X" if tile.bombed } }
            render
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
    
    def run
        system("clear")
        until game_over?
            render
            #input = get_input
            #print "\n selected tile #{input} \n"
            #prompt_for_action
            action = get_action
            #execute(input, action)
            system('clear')
        end
    end


    include Remedy
    
    def keyboard
        user_input = Interaction.new

        w = (board.grid[0].length / 2)
        h = (board.grid.length / 2)


        user_input.loop do |key|
            #current_tile = board.grid[h][w]

            case key.to_s
            when "up"
                 #decrement h
                 h -= 1
            when "down"
                 #increment h
                 h += 1
            when "left"
                 #decrement w
                 w -= 1
            when "right"
                 #increment w
                 w += 1
            when "space"
                #reveal
                #wrap h and w by hiegit and width with  h % (height + 1) or length
                
                self.execute([h, w], "r")
            when "control_s"
                #save
            when "f"
                #flag
                #wrap h and w by hiegit and width with %
                self.execute([h, w], "f")

            end 
            system('clear')

            h = (h % board.grid.length)
            w = (w % board.grid[0].length)
            selected_tile = board.grid[h][w]
            render([h,w])

           #blink selected tile
        end
    end


end


if  __FILE__ == $PROGRAM_NAME
   

  case ARGV.length
    when 0
        g = Game.new
        g.keyboard

        g.run
    when 1 
        game_file = ARGV.shift
        Game.load_game(game_file).run
    end 
end
