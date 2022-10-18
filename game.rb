# frozen_string_literal: true

require_relative 'computer'
require_relative 'display'

# Game class
class Game
  def initialize
    @computer = Computer.new
    @display = Display.new
  end

  def play_round(choice)
    @computer.check_letter(choice)
    @computer.send_outcome(@display) if @computer.game_over?
  end

  def choose_save_or_guess
    @display.show_display(@computer)
    puts 'Choose a letter or type "1" to save your game:'
    choice = gets.chomp
    if choice == '1'
      'save'
    else
      make_guess(choice)
    end
  end

  def make_guess(choice)
    until ('a'..'z').include?(choice) && @computer.letters_guessed.exclude?(choice)
      puts select_output(choice)
      choice = gets.chomp.downcase
    end
    play_round(choice)
  end

  def select_output(choice)
    if @computer.letters_guessed.include?(choice)
      'You already guessed that letter. Please choose a new one: '
    else
      'Please choose a single letter: '
    end
  end

  def game_over?
    @computer.game_over?
  end
end
