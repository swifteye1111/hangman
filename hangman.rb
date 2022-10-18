# frozen_string_literal: true

require 'active_support/core_ext/enumerable'
require 'yaml'
require_relative 'game'

def new_or_load?
  puts 'Enter 1 to play a new game or 2 to load a saved game."'
  gets.chomp
end

def load_game
  begin
    name = choose_game
    saved_game = File.open("saved/#{name}.yaml", 'r')
    loaded_game = YAML.load(saved_game, permitted_classes: [Game, Computer, Display])
    puts "Game #{name} loaded!"
    saved_game.close
    loaded_game
  rescue StandardError => e
    puts e
    retry
  end
end

def save_game(game)
  name = name_game
  Dir.mkdir('saved') unless Dir.exist?('saved')
  filename = "saved/#{name}.yaml"

  File.open(filename, 'w') do |file|
    file.write YAML.dump(game)
  end
end

def name_game
  puts 'Name your saved game:'
  gets.chomp
end

def choose_game
  puts 'Choose a game to load:'
  saved_games = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
  puts saved_games
  name = gets.chomp
  until saved_games.include?(name)
    puts 'Game not found. Please choose from the list:'
    puts saved_games
    name = gets.chomp
  end
  name
end

game = new_or_load? == '1' ? Game.new : load_game

until game.game_over?
  if game.get_guess_or_save == 'save'
    if save_game(game)
      puts 'Game saved!'
      break
    end
  end
end
