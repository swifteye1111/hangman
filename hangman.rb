require 'active_support/core_ext/enumerable'
require 'yaml'
# load dictionary
# randomly select word between 5-12 chars long, store as secret word

# turn:
  # player makes guess, case insensitive
  # update display to reflect whether letter was correct or not
  # if out of guesses, player loses

# add option to save game (serialize Game class)

# add option to open a saved game when loads

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

  def get_guess_or_save
    @display.show_display(@computer)
    puts 'Choose a letter or type "1" to save your game:'
    choice = gets.chomp
    if choice == '1'
      'save'
    else
      until ('a'..'z').include?(choice) && @computer.letters_guessed.exclude?(choice)
        puts select_output(choice)
        choice = gets.chomp.downcase
      end
      play_round(choice)
    end
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

# Computer class
class Computer
  attr_reader :visible_letters, :remaining_guesses, :letters_guessed

  def initialize
    @secret_word = generate_secret_word
    @visible_letters = generate_visible_letters # create string of _'s of length @secret_word.length
    @remaining_guesses = 10
    @letters_guessed = []
  end

  def take_turn(letter)
    @visible_letters = check_letter(letter)
    Display.show_display(letter)
  end

  def check_letter(letter)
    # check letter against secret_word,
    # return visible_letters with letter filled in
    @letters_guessed.push(letter)
    i = 0
    @secret_word.each_char do |char|
      @visible_letters[i] = letter if char == letter
      i += 1
    end
    @remaining_guesses -= 1
  end

  def game_over?
    return true if @visible_letters == @secret_word || @remaining_guesses.zero?

    return false
  end

  def send_outcome(display)
    display.show_outcome(self, @secret_word)
  end

  private

  def generate_secret_word
    words = []
    File.open('words.txt').readlines.each do |word|
      words.push(word.strip) if word.length.between?(6, 13) # allow for newline chars
    end
    words.sample
  end

  def generate_visible_letters
    @visible_letters = @secret_word.gsub(/[a-zA-Z]/, '_')
  end
end

# Display:
  # remaining guesses
  # correct letters and position
  # incorrect letters already chosen
class Display
  def show_display(comp)
    puts "Word: #{comp.visible_letters}"
    puts "You have #{comp.remaining_guesses} guesses remaining."
    puts "Letters guessed: #{comp.letters_guessed.join(' ')}" unless comp.letters_guessed.empty?
  end

  def show_outcome(comp, secret_word)
    if comp.remaining_guesses.zero?
      puts "You lost with #{comp.remaining_guesses} guess(es) remaining. The secret word was #{secret_word.upcase}."
    else
      puts "You won! You guessed the secret word #{secret_word.upcase} with #{comp.remaining_guesses} guess(es) remaining!"
    end
  end
end

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
